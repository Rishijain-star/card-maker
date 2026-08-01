<?php

use App\Models\Product;
use App\Support\ProductCatalog;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->string('slug', 120)->nullable()->after('name');
            $table->json('sizes')->nullable()->after('status');
        });

        Product::query()->each(function (Product $product): void {
            ProductCatalog::applyCatalogMeta($product);
            $product->save();
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['slug', 'sizes']);
        });
    }
};
