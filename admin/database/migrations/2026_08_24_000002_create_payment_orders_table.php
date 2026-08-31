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
        if (! Schema::hasTable('payment_orders')) {
            Schema::create('payment_orders', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->string('package_id', 50); // startup, basic, yearly
                $table->unsignedInteger('amount'); // amount in paise
                $table->string('currency', 10)->default('INR');
                $table->string('razorpay_order_id', 100)->unique();
                $table->string('razorpay_payment_id', 100)->nullable()->index();
                $table->string('razorpay_signature', 255)->nullable();
                $table->string('status', 30)->default('created'); // created, paid, failed
                $table->text('notes')->nullable();
                $table->timestamps();
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payment_orders');
    }
};
