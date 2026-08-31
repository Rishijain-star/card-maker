<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Support\ProductCatalog;
use App\Support\StaticAdminData;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    public function index(): View
    {
        return view('admin.products', [
            'pageTitle' => 'Products',
            'appName' => StaticAdminData::APP_NAME,
            'sidebar' => StaticAdminData::sidebar(),
            'adminUsername' => session('admin_username', 'admin'),
            'products' => Product::query()->latest()->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:255'],
            'price' => ['required', 'integer', 'min:1'],
            'image' => ['nullable', 'image', 'max:2048'],
        ]);

        $imageName = null;
        if ($request->hasFile('image')) {
            $imageName = $this->saveImage($request->file('image'));
        }

        Product::query()->create([
            'name' => $data['name'],
            'description' => $data['description'] ?? '',
            'price' => $data['price'],
            'image' => $imageName,
            'status' => 'Active',
            'slug' => ProductCatalog::slugFromName($data['name']),
            'sizes' => ProductCatalog::sizesForName($data['name']),
        ]);

        return redirect()
            ->route('admin.products')
            ->with('success', 'Product added successfully.');
    }

    public function update(Request $request, Product $product): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:255'],
            'price' => ['sometimes', 'required', 'integer', 'min:1'],
            'image' => ['nullable', 'image', 'max:2048'],
        ]);

        if ($request->hasFile('image')) {
            $this->deleteImage($product->image);
            $product->image = $this->saveImage($request->file('image'));
        }

        if (isset($data['name'])) {
            $product->name = $data['name'];
            $product->slug = ProductCatalog::slugFromName($data['name']);
            $product->sizes = ProductCatalog::sizesForName($data['name']);
        }
        if (array_key_exists('description', $data)) {
            $product->description = $data['description'] ?? '';
        }
        if (isset($data['price'])) {
            $product->price = $data['price'];
        }

        $product->save();

        return redirect()
            ->route('admin.products')
            ->with('success', 'Product updated successfully.');
    }

    public function destroy(Product $product): RedirectResponse
    {
        $this->deleteImage($product->image);
        $product->delete();

        return redirect()
            ->route('admin.products')
            ->with('success', 'Product deleted successfully.');
    }

    private function saveImage(\Illuminate\Http\UploadedFile $file): string
    {
        $dir = public_path('uploads/products');
        if (! is_dir($dir)) {
            mkdir($dir, 0755, true);
        }

        $name = Str::uuid()->toString().'.'.$file->getClientOriginalExtension();
        $file->move($dir, $name);

        return $name;
    }

    private function deleteImage(?string $filename): void
    {
        if ($filename === null || $filename === '') {
            return;
        }

        $path = public_path('uploads/products/'.$filename);
        if (is_file($path)) {
            unlink($path);
        }
    }
}
