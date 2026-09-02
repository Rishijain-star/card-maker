<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $baseUrl = $request->getSchemeAndHttpHost();

        $products = Product::query()
            ->where('status', 'Active')
            ->latest()
            ->get()
            ->map(function (Product $product) use ($baseUrl): array {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'slug' => $product->slug,
                    'category' => !empty($product->category)
                        ? $product->category
                        : \App\Support\ProductCatalog::categoryFromName($product->name),
                    'description' => $product->description ?? '',
                    'price' => (int) $product->price,
                    'image_url' => $product->image
                        ? ($product->imageUrl() && str_contains($product->imageUrl(), '/public/')
                            ? $product->imageUrl()
                            : $baseUrl.'/public/uploads/products/'.$product->image)
                        : null,
                    'status' => $product->status,
                    'sizes' => $product->sizes ?? [],
                    'supports_sizes' => ! empty($product->sizes),
                ];
            })
            ->values();

        return response()->json([
            'success' => true,
            'data' => $products,
        ]);
    }
}
