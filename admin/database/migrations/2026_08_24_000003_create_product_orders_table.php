<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        if (! Schema::hasTable('product_orders')) {
            Schema::create('product_orders', function (Blueprint $table) {
                $table->id();
                $table->string('order_number', 50)->unique();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->json('items'); // Array of { product_id, product_name, quantity, unit_price, line_total, size, design_title }
                $table->unsignedInteger('total_qty')->default(1);
                $table->unsignedInteger('subtotal'); // In rupees
                $table->unsignedInteger('total_amount'); // In paise (for Razorpay)
                $table->string('currency', 10)->default('INR');
                $table->string('razorpay_order_id', 100)->unique();
                $table->string('razorpay_payment_id', 100)->nullable()->index();
                $table->string('razorpay_signature', 255)->nullable();
                $table->string('status', 30)->default('created'); // created, paid, failed, delivered
                $table->timestamps();
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_orders');
    }
};
