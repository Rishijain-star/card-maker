<?php

use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\LoginController;
use App\Http\Controllers\Admin\ProductController;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin/login');

// Safe web trigger for running migrations and clearing cache without server terminal
Route::get('/admin/run-system-migrations-securely-2026', function () {
    try {
        Artisan::call('migrate', ['--force' => true]);
        $migrateOutput = Artisan::output();

        Artisan::call('optimize:clear');
        $clearOutput = Artisan::output();

        return response()->json([
            'status' => true,
            'message' => 'Migrations and cache clearing executed successfully!',
            'migrate_output' => $migrateOutput,
            'cache_output' => $clearOutput,
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
