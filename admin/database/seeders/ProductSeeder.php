<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Support\ProductCatalog;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        if (Product::query()->exists()) {
            return;
        }

        $defaults = [
            ['name' => 'ID CARD', 'description' => 'School & Office Cards', 'price' => 25],
            ['name' => 'LANYARD', 'description' => 'Custom Printed Lanyards', 'price' => 30],
            ['name' => 'BADGE', 'description' => 'Name & Pin Badges', 'price' => 20],
            ['name' => 'BELT', 'description' => 'School Belts with Buckle', 'price' => 120],
        ];

        foreach ($defaults as $item) {
            Product::query()->create([
                ...$item,
                'status' => 'Active',
                'slug' => ProductCatalog::slugFromName($item['name']),
                'sizes' => ProductCatalog::sizesForName($item['name']),
            ]);
        }
    }
}
