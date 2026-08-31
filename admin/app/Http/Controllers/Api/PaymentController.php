<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PaymentOrder;
use App\Models\ProductOrder;
use App\Models\User;
use App\Services\RazorpayService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class PaymentController extends Controller
{
    public function __construct(protected RazorpayService $razorpayService)
    {
    }

    /**
     * Create a Razorpay Order for the authenticated user (Premium Plan).
     * POST /api/v1/payments/create-order
     */
    public function createOrder(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'package_id' => 'required|string|in:startup,basic,yearly',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();
        $packageId = $request->input('package_id');

        try {
            $razorpayOrder = $this->razorpayService->createOrder($packageId, $user->id);

            $paymentOrder = PaymentOrder::create([
                'user_id' => $user->id,
                'package_id' => $packageId,
                'amount' => (int) $razorpayOrder['amount'],
                'currency' => $razorpayOrder['currency'] ?? 'INR',
                'razorpay_order_id' => $razorpayOrder['id'],
                'status' => 'created',
            ]);

            Log::info('[PAYMENT_API] Premium Order Created Successfully', [
                'user_id' => $user->id,
                'package_id' => $packageId,
                'order_id' => $paymentOrder->razorpay_order_id,
                'amount' => $paymentOrder->amount,
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Order created successfully',
                'data' => [
                    'order_id' => $paymentOrder->razorpay_order_id,
                    'amount' => $paymentOrder->amount,
                    'currency' => $paymentOrder->currency,
                    'key_id' => $this->razorpayService->getKeyId(),
                    'package_id' => $packageId,
                ],
            ], 201);
        } catch (Exception $e) {
            Log::error('[PAYMENT_API] Create Order Error', [
                'user_id' => $user->id ?? null,
                'package_id' => $packageId ?? null,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'status' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Verify payment signature and capture status, then unlock Premium.
     * POST /api/v1/payments/verify
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

        // 1. User & Order Ownership Check
        $order = PaymentOrder::where('razorpay_order_id', $orderId)->first();

        if (! $order || $order->user_id !== $user->id) {
            return response()->json([
                'status' => false,
                'message' => 'Payment order not found or does not belong to your account.',
            ], 404);
        }

        // 2. Idempotency Check: Already paid
        if ($order->status === 'paid') {
            return response()->json([
                'status' => true,
                'message' => 'Payment has already been verified and processed.',
                'data' => [
                    'is_premium' => $user->isPremiumActive(),
                    'premium_plan' => $user->premium_plan,
                    'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                    'save_limit' => $user->getSaveLimit(),
                ],
            ]);
        }

        // 3. HMAC-SHA256 Signature Verification
        if (! $this->razorpayService->verifySignature($orderId, $paymentId, $signature)) {
            Log::warning('Invalid Razorpay signature submitted', [
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

        // Validate amount and order ID match
        if ($paymentOrderId !== $orderId || $paymentAmount !== $order->amount) {
            return response()->json([
                'status' => false,
                'message' => 'Payment details do not match the expected order.',
            ], 400);
        }

        // Check if captured vs authorized
        if ($paymentStatus === 'authorized') {
            // Keep order as created, do not grant premium yet
            return response()->json([
                'status' => false,
                'message' => 'Payment is authorized and pending capture. Premium will unlock once captured.',
                'data' => [
                    'is_premium' => $user->isPremiumActive(),
                    'save_limit' => $user->getSaveLimit(),
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

        // 5. Unlock Premium in a Database Transaction
        DB::beginTransaction();
        try {
            $plan = $this->razorpayService->getPlan($order->package_id);
            $durationDays = $plan['duration_days'] ?? 30;

            $order->update([
                'status' => 'paid',
                'razorpay_payment_id' => $paymentId,
                'razorpay_signature' => $signature,
            ]);

            $user->is_premium = true;
            $user->premium_plan = $order->package_id;
            $user->premium_activated_at = now();
            $user->premium_expires_at = now()->addDays($durationDays);
            $user->save();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Payment verified and Premium unlocked successfully!',
                'data' => [
                    'is_premium' => $user->isPremiumActive(),
                    'premium_plan' => $user->premium_plan,
                    'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                    'save_limit' => $user->getSaveLimit(),
                ],
            ], 200);
        } catch (Exception $e) {
            DB::rollBack();
            Log::error('Payment Activation Transaction Failed', ['error' => $e->getMessage()]);

            return response()->json([
                'status' => false,
                'message' => 'An error occurred while activating your Premium status.',
            ], 500);
        }
    }

    /**
     * Get live subscription / premium status for authenticated user.
     * GET /api/v1/payments/status
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'status' => true,
            'data' => [
                'is_premium' => $user->isPremiumActive(),
                'premium_plan' => $user->premium_plan,
                'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                'save_limit' => $user->getSaveLimit(),
            ],
        ]);
    }

    /**
     * Handle incoming webhooks from Razorpay (Unauthenticated, Signature-verified).
     * Handles both Product Orders and Premium Subscription Orders safely.
     * POST /api/v1/payments/webhook
     */
    public function webhook(Request $request): JsonResponse
    {
        $signature = $request->header('X-Razorpay-Signature');
        $rawPayload = $request->getContent();

        if (empty($signature) || ! $this->razorpayService->verifyWebhookSignature($rawPayload, $signature)) {
            Log::warning('Razorpay Webhook Invalid Signature Received');

            return response()->json(['status' => false, 'message' => 'Invalid webhook signature'], 400);
        }

        $payload = json_decode($rawPayload, true);
        $event = $payload['event'] ?? '';

        Log::info('Razorpay Webhook Event Received', ['event' => $event]);

        if ($event === 'payment.captured' || $event === 'order.paid') {
            $paymentEntity = $payload['payload']['payment']['entity'] ?? [];
            $orderId = $paymentEntity['order_id'] ?? ($payload['payload']['order']['entity']['id'] ?? null);
            $paymentId = $paymentEntity['id'] ?? null;
            $status = $paymentEntity['status'] ?? 'captured';
            $amount = (int) ($paymentEntity['amount'] ?? 0);
            $currency = $paymentEntity['currency'] ?? 'INR';

            if ($orderId && $status === 'captured') {
                // 1. Check if it's a Product Order
                $productOrder = ProductOrder::where('razorpay_order_id', $orderId)->first();
                if ($productOrder) {
                    if ($productOrder->status !== 'paid' && $productOrder->total_amount === $amount && $productOrder->currency === $currency) {
                        $productOrder->update([
                            'status' => 'paid',
                            'razorpay_payment_id' => $paymentId,
                        ]);
                        Log::info('Razorpay Webhook fulfilled ProductOrder', ['order_number' => $productOrder->order_number]);
                    }

                    return response()->json(['status' => true, 'message' => 'Product order processed'], 200);
                }

                // 2. Check if it's a Premium Subscription Order
                $order = PaymentOrder::where('razorpay_order_id', $orderId)->first();
                if ($order && $order->status !== 'paid' && $order->amount === $amount) {
                    DB::beginTransaction();
                    try {
                        $plan = $this->razorpayService->getPlan($order->package_id);
                        $durationDays = $plan['duration_days'] ?? 30;

                        $order->update([
                            'status' => 'paid',
                            'razorpay_payment_id' => $paymentId,
                        ]);

                        $user = User::find($order->user_id);
                        if ($user) {
                            $user->is_premium = true;
                            $user->premium_plan = $order->package_id;
                            $user->premium_activated_at = now();
                            $user->premium_expires_at = now()->addDays($durationDays);
                            $user->save();
                        }

                        DB::commit();
                        Log::info('Razorpay Webhook successfully fulfilled Premium order', ['order_id' => $orderId]);
                    } catch (Exception $e) {
                        DB::rollBack();
                        Log::error('Razorpay Webhook Fulfillment Error', ['error' => $e->getMessage()]);
                    }
                }
            }
        } elseif ($event === 'payment.failed') {
            $paymentEntity = $payload['payload']['payment']['entity'] ?? [];
            $orderId = $paymentEntity['order_id'] ?? null;
            $paymentId = $paymentEntity['id'] ?? null;

            if ($orderId) {
                // Check ProductOrder
                $productOrder = ProductOrder::where('razorpay_order_id', $orderId)->first();
                if ($productOrder && $productOrder->status === 'created') {
                    $productOrder->update([
                        'status' => 'failed',
                        'razorpay_payment_id' => $paymentId,
                    ]);
                }

                // Check PaymentOrder
                $order = PaymentOrder::where('razorpay_order_id', $orderId)->first();
                if ($order && $order->status === 'created') {
                    $order->update([
                        'status' => 'failed',
                        'razorpay_payment_id' => $paymentId,
                    ]);
                }
            }
        }

        return response()->json(['status' => true, 'message' => 'Webhook processed successfully'], 200);
    }
}
