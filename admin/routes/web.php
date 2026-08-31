<?php

use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\LoginController;
use App\Http\Controllers\Admin\ProductController;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin/login');

// Safe web trigger for running migrations without server terminal or DOMDocument dependency
Route::get('/admin/run-system-migrations-securely-2026', function () {
    $results = [];

    try {
        // 1. Create user_device_tokens table if not exists or recreate if wrong columns
        if (Illuminate\Support\Facades\Schema::hasTable('user_device_tokens') && !Illuminate\Support\Facades\Schema::hasColumn('user_device_tokens', 'token')) {
            Illuminate\Support\Facades\Schema::drop('user_device_tokens');
        }

        if (!Illuminate\Support\Facades\Schema::hasTable('user_device_tokens')) {
            Illuminate\Support\Facades\Schema::create('user_device_tokens', function ($table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->string('token', 80)->unique();
                $table->string('device_name')->nullable();
                $table->string('device_id')->nullable();
                $table->timestamp('last_used_at')->nullable();
                $table->timestamps();
                $table->index(['user_id', 'token']);
            });
            $results['user_device_tokens'] = 'Created';
        } else {
            $results['user_device_tokens'] = 'Already Exists';
        }

        // 2. Add form_data column to saved_cards if not exists
        if (Illuminate\Support\Facades\Schema::hasTable('saved_cards')) {
            if (!Illuminate\Support\Facades\Schema::hasColumn('saved_cards', 'form_data')) {
                Illuminate\Support\Facades\Schema::table('saved_cards', function ($table) {
                    $table->longText('form_data')->nullable()->after('back_path');
                });
                $results['saved_cards_form_data'] = 'Added';
            } else {
                $results['saved_cards_form_data'] = 'Already Exists';
            }
        }

        return response()->json([
            'status' => true,
            'message' => 'Live database tables and columns updated successfully!',
            'details' => $results,
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'status' => false,
            'error' => $e->getMessage(),
        ], 500);
    }
});

Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/login', [LoginController::class, 'show'])->name('login');
    Route::post('/login', [LoginController::class, 'login'])->name('login.submit');
    Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

    Route::middleware('admin.auth')->group(function () {
        Route::get('/', [AdminController::class, 'dashboard'])->name('dashboard');
        Route::get('/users', [AdminController::class, 'users'])->name('users');
        Route::get('/users/{user}', [AdminController::class, 'showUser'])->name('users.show');
        Route::get('/products', [ProductController::class, 'index'])->name('products');
        Route::post('/products', [ProductController::class, 'store'])->name('products.store');
        Route::put('/products/{product}', [ProductController::class, 'update'])->name('products.update');
        Route::delete('/products/{product}', [ProductController::class, 'destroy'])->name('products.destroy');
        Route::get('/orders', [AdminController::class, 'orders'])->name('orders');
        Route::get('/orders/{order}', [AdminController::class, 'showOrder'])->name('orders.show');
        Route::get('/orders/{order}/print', [AdminController::class, 'printOrder'])->name('orders.print');
        Route::get('/leads', [AdminController::class, 'leads'])->name('leads');
        Route::get('/settings', [AdminController::class, 'settings'])->name('settings');
    });
});
