<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\ProductOrder;
use App\Services\RazorpayService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function __construct(protected RazorpayService $razorpayService)
    {
    }

    /**
     * Create a Razorpay Order for cart checkout.
     * POST /api/v1/orders/create-payment
     */
    public function createPayment(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|integer|exists:products,id',
            'items.*.quantity' => 'nullable|integer|min:1',
            'items.*.size' => 'nullable|string',
            'items.*.design_title' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();
        $inputItems = $request->input('items');

        $verifiedItems = [];
        $subtotalRupees = 0;
        $totalQty = 0;

        foreach ($inputItems as $item) {
            $product = Product::find($item['product_id']);
            if (! $product || $product->status !== 'Active') {
                return response()->json([
                    'status' => false,
                    'message' => 'One of the selected products is no longer available.',
                ], 422);
            }

            $unitPrice = (int) $product->price;
            $quantity = isset($item['quantity']) ? max(1, (int) $item['quantity']) : 1;
            $lineTotal = $unitPrice * $quantity;

            $frontPath = CardController::storeBase64CardImage($item['front_image'] ?? null, 'order_' . $user->id . '_front');
            $backPath = CardController::storeBase64CardImage($item['back_image'] ?? null, 'order_' . $user->id . '_back');

            $verifiedItems[] = [
                'product_id' => $product->id,
                'product_name' => $product->name,
                'quantity' => $quantity,
                'unit_price' => $unitPrice,
                'line_total' => $lineTotal,
                'size' => $item['size'] ?? 'Standard',
                'design_title' => $item['design_title'] ?? $product->name,
                'student_name' => $item['student_name'] ?? null,
                'institute_name' => $item['institute_name'] ?? null,
                'front_image' => $frontPath ?: ($item['front_image'] ?? null),
                'back_image' => $backPath ?: ($item['back_image'] ?? null),
            ];

            $subtotalRupees += $lineTotal;
            $totalQty += $quantity;
        }

        if ($subtotalRupees <= 0) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid order total.',
            ], 422);
        }

        $totalAmountPaise = $subtotalRupees * 100;
        $orderNumber = 'ORD-'.rand(1000, 9999);
        $receipt = 'rcpt_prod_'.substr(md5(uniqid((string) $user->id, true)), 0, 14);

        try {
            $razorpayOrder = $this->razorpayService->createCustomOrder(
                $totalAmountPaise,
                'INR',
                $receipt,
                [
                    'user_id' => (string) $user->id,
                    'order_number' => $orderNumber,
                    'type' => 'product_order',
                ]
            );

            $order = ProductOrder::create([
                'order_number' => $orderNumber,
                'user_id' => $user->id,
                'items' => $verifiedItems,
                'total_qty' => $totalQty,
                'subtotal' => $subtotalRupees,
                'total_amount' => $totalAmountPaise,
                'currency' => $razorpayOrder['currency'] ?? 'INR',
                'razorpay_order_id' => $razorpayOrder['id'],
                'status' => 'created',
            ]);

            Log::info('[ORDER_API] Product Order Created Successfully', [
                'user_id' => $user->id,
                'order_number' => $order->order_number,
                'razorpay_order_id' => $order->razorpay_order_id,
                'total_amount' => $order->total_amount,
                'subtotal' => $order->subtotal,
                'items_count' => count($verifiedItems),
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Order created successfully',
                'data' => [
                    'order_id' => $order->razorpay_order_id,
                    'order_number' => $order->order_number,
                    'amount' => $order->total_amount,
                    'subtotal' => $order->subtotal,
                    'currency' => $order->currency,
                    'key_id' => $this->razorpayService->getKeyId(),
                ],
            ], 201);
        } catch (Exception $e) {
            Log::error('[ORDER_API] Create Product Order Error', [
                'user_id' => $user->id ?? null,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'status' => false,
                'message' => 'Failed to create payment order: '.$e->getMessage(),
            ], 500);
        }
    }

    /**
     * Verify payment signature and capture status for a product order.
     * POST /api/v1/orders/verify-payment
     */
    public function verifyPayment(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'razorpay_order_id' => 'required|string',
            'razorpay_payment_id' => 'required|string',
            'razorpay_signature' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();
        $orderId = $request->input('razorpay_order_id');
        $paymentId = $request->input('razorpay_payment_id');
        $signature = $request->input('razorpay_signature');

        // 1. Strict User Ownership Check
        $order = ProductOrder::where('razorpay_order_id', $orderId)->first();

        if (! $order || $order->user_id !== $user->id) {
            return response()->json([
                'status' => false,
                'message' => 'Product order not found or does not belong to your account.',
            ], 404);
        }

        // 2. Idempotency Check: Already paid
        if ($order->status === 'paid' || $order->status === 'delivered') {
            return response()->json([
                'status' => true,
                'message' => 'Order has already been verified and paid.',
                'data' => [
                    'order_number' => $order->order_number,
                    'status' => $order->status,
                    'amount' => $order->subtotal,
                ],
            ]);
        }

        // 3. HMAC-SHA256 Signature Verification
        if (! $this->razorpayService->verifySignature($orderId, $paymentId, $signature)) {
            Log::warning('Invalid Razorpay signature on product order', [
                'user_id' => $user->id,
                'order_id' => $orderId,
                'payment_id' => $paymentId,
            ]);

            return response()->json([
                'status' => false,
                'message' => 'Invalid payment signature. Verification failed.',
            ], 400);
        }

        // 4. Live Razorpay Status Check (Must be 'captured')
        $paymentDetails = $this->razorpayService->fetchPayment($paymentId);

        if (! $paymentDetails) {
            return response()->json([
                'status' => false,
                'message' => 'Could not verify payment status with Razorpay API.',
            ], 400);
        }

        $paymentStatus = $paymentDetails['status'] ?? '';
        $paymentAmount = (int) ($paymentDetails['amount'] ?? 0);
        $paymentOrderId = $paymentDetails['order_id'] ?? '';

        if ($paymentOrderId !== $orderId || $paymentAmount !== $order->total_amount) {
            return response()->json([
                'status' => false,
                'message' => 'Payment details do not match the expected order amount.',
            ], 400);
        }

        if ($paymentStatus === 'authorized') {
            return response()->json([
                'status' => false,
                'message' => 'Payment is authorized and pending capture.',
                'data' => [
                    'order_number' => $order->order_number,
                    'status' => 'created',
                ],
            ], 202);
        }

        if ($paymentStatus !== 'captured') {
            $order->update([
                'status' => 'failed',
                'razorpay_payment_id' => $paymentId,
            ]);

            return response()->json([
                'status' => false,
                'message' => "Payment is not in captured state (Current status: {$paymentStatus}).",
            ], 400);
        }

        // 5. Mark Order Paid in a Database Transaction
        DB::beginTransaction();
        try {
            $order->update([
                'status' => 'paid',
                'razorpay_payment_id' => $paymentId,
                'razorpay_signature' => $signature,
            ]);

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Payment verified and order placed successfully!',
                'data' => [
                    'order_number' => $order->order_number,
                    'status' => 'paid',
                    'amount' => $order->subtotal,
                ],
            ], 200);
        } catch (Exception $e) {
            DB::rollBack();
            Log::error('Product Order Paid Transaction Failed', ['error' => $e->getMessage()]);

            return response()->json([
                'status' => false,
                'message' => 'An error occurred while confirming your order.',
            ], 500);
        }
    }

    /**
     * Get user's product order history.
     * GET /api/v1/orders/history
     */
    public function history(Request $request): JsonResponse
    {
        $user = $request->user();

        $orders = ProductOrder::where('user_id', $user->id)
            ->whereIn('status', ['paid', 'delivered'])
            ->latest()
            ->get()
            ->map(function (ProductOrder $order): array {
                $firstItem = ($order->items[0] ?? []);
                $title = $firstItem['product_name'] ?? 'ID CARDS';
                if (count($order->items) > 1) {
                    $title .= ' + '.(count($order->items) - 1).' more';
                }

                return [
                    'order_id' => $order->order_number,
                    'title' => strtoupper($title),
                    'qty' => $order->total_qty,
                    'amount' => $order->subtotal,
                    'status' => ucfirst($order->status),
                    'date' => $order->created_at->format('d M Y'),
                ];
            });

        return response()->json([
            'status' => true,
            'data' => $orders,
        ]);
    }
}
