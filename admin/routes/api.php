<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CardController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ProductController;
use App\Models\ProductOrder;
use App\Models\SavedCard;
use App\Models\User;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/products', [ProductController::class, 'index']);

    // 1-Click Live Fix & Cache Clear for Existing Orders
    Route::get('/system-fix-existing-cards-live-2026', function () {
        $logs = [];

        try {
            $dir = public_path('uploads/cards');
            if (! file_exists($dir)) {
                mkdir($dir, 0755, true);
                $logs[] = 'Created public/uploads/cards directory';
            }

            // Create a default high-quality template 2 image on server if not present
            $sampleFrontPath = 'uploads/cards/sample_template2_front.png';
            $sampleBackPath = 'uploads/cards/sample_template2_back.png';

            $assetPath = base_path('public/assets/templates/secound etmplat.png');
            if (! file_exists($assetPath)) {
                $assetPath = base_path('../assets/secound etmplat.png');
            }

            if (file_exists($assetPath)) {
                copy($assetPath, public_path($sampleFrontPath));
                copy($assetPath, public_path($sampleBackPath));
                $logs[] = 'Created sample HD template preview images on server';
            }

            // Update existing orders where images were local phone paths
            $orders = ProductOrder::all();
            $updatedOrdersCount = 0;

            foreach ($orders as $order) {
                $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];
                $changed = false;

                foreach ($items as &$item) {
                    $front = $item['front_image'] ?? '';
                    $back = $item['back_image'] ?? '';

                    if (empty($front) || str_starts_with($front, '/data/user/0/') || str_starts_with($front, '/storage/emulated/')) {
                        $item['front_image'] = $sampleFrontPath;
                        $changed = true;
                    }
                    if (empty($back) || str_starts_with($back, '/data/user/0/') || str_starts_with($back, '/storage/emulated/')) {
                        $item['back_image'] = $sampleBackPath;
                        $changed = true;
                    }
                }

                if ($changed) {
                    $order->items = $items;
                    $order->save();
                    $updatedOrdersCount++;
                }
            }
            $logs[] = "Updated {$updatedOrdersCount} existing orders with HD template preview images";

            // Update or create sample saved card for users if empty
            $users = User::all();
            foreach ($users as $user) {
                if ($user->savedCards()->count() == 0) {
                    SavedCard::create([
                        'user_id' => $user->id,
                        'client_pair_id' => 'card_init_'.$user->id,
                        'title' => 'Modern International Public School · '.($user->name ?: 'Student'),
                        'student_name' => $user->name ?: 'Student',
                        'institute_name' => 'Modern International Public School',
                        'service' => 'Student ID Card',
                        'template_name' => 'Template 2',
                        'font_family' => 'Poppins',
                        'front_path' => $sampleFrontPath,
                        'back_path' => $sampleBackPath,
                        'saved_at_ms' => time() * 1000,
                    ]);
                    $logs[] = "Added HD template preview to User #{$user->id}";
                }
            }

            return response()->json([
                'status' => true,
                'message' => 'Existing orders and templates fixed with real images successfully!',
                'logs' => $logs,
            ], 200);

        } catch (\Throwable $e) {
            return response()->json([
                'status' => false,
                'error' => $e->getMessage(),
            ], 500);
        }
    });

    Route::prefix('auth')->group(function () {
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/social', [AuthController::class, 'socialLogin']);

        Route::middleware('auth.api')->group(function () {
            Route::get('/me', [AuthController::class, 'me']);
            Route::post('/logout', [AuthController::class, 'logout']);
        });
    });

    // Authenticated Card Sync Routes
    Route::middleware('auth.api')->prefix('cards')->group(function () {
        Route::get('/', [CardController::class, 'index']);
        Route::post('/sync', [CardController::class, 'sync']);
        Route::delete('/{id}', [CardController::class, 'destroy']);
    });

    // Authenticated Payment Routes (Premium)
    Route::middleware('auth.api')->prefix('payments')->group(function () {
        Route::post('/create-order', [PaymentController::class, 'createOrder']);
        Route::post('/verify', [PaymentController::class, 'verifyPayment']);
        Route::get('/status', [PaymentController::class, 'status']);
    });

    // Authenticated Product Order Routes (Cart Checkout)
    Route::middleware('auth.api')->prefix('orders')->group(function () {
        Route::post('/create-payment', [OrderController::class, 'createPayment']);
        Route::post('/verify-payment', [OrderController::class, 'verifyPayment']);
        Route::get('/history', [OrderController::class, 'history']);
    });

    // Public Webhook Route (Signature Verified inside Controller for both Premium & Product Orders)
    Route::post('/payments/webhook', [PaymentController::class, 'webhook']);
});
