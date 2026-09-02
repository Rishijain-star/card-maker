<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Support\ProductCatalog;
use App\Support\StaticAdminData;
use Illuminate\Contracts\View\View;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    public function index(): View
    {
        $this->ensureCategoryColumn();

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
        $this->ensureCategoryColumn();

        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'category' => ['nullable', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:255'],
            'price' => ['required', 'integer', 'min:1'],
            'image' => [
                'nullable',
                'file',
                'max:4096',
                function ($attribute, $value, $fail) {
                    if ($value instanceof \Illuminate\Http\UploadedFile) {
                        $ext = strtolower($value->getClientOriginalExtension());
                        if (!in_array($ext, ['jpg', 'jpeg', 'png', 'webp', 'gif'])) {
                            $fail('The ' . $attribute . ' must be an image (jpg, jpeg, png, webp, gif).');
                        }
                    }
                },
            ],
        ]);

        $imageName = null;
        if ($request->hasFile('image')) {
            $imageName = $this->saveImage($request->file('image'));
        }

        $category = !empty($data['category'])
            ? trim($data['category'])
            : ProductCatalog::categoryFromName($data['name']);

        Product::query()->create([
            'name' => $data['name'],
            'category' => $category,
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
        $this->ensureCategoryColumn();

        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:120'],
            'category' => ['nullable', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:255'],
            'price' => ['sometimes', 'required', 'integer', 'min:1'],
            'image' => [
                'nullable',
                'file',
                'max:4096',
                function ($attribute, $value, $fail) {
                    if ($value instanceof \Illuminate\Http\UploadedFile) {
                        $ext = strtolower($value->getClientOriginalExtension());
                        if (!in_array($ext, ['jpg', 'jpeg', 'png', 'webp', 'gif'])) {
                            $fail('The ' . $attribute . ' must be an image (jpg, jpeg, png, webp, gif).');
                        }
                    }
                },
            ],
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
        if (array_key_exists('category', $data)) {
            $product->category = !empty($data['category'])
                ? trim($data['category'])
                : ProductCatalog::categoryFromName($product->name);
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

    private function ensureCategoryColumn(): void
    {
        try {
            if (! Schema::hasColumn('products', 'category')) {
                Schema::table('products', function (Blueprint $table) {
                    $table->string('category', 100)->nullable()->default('General')->after('slug');
                });
            }
        } catch (\Throwable $e) {
            // Ignore if column already exists or table issue
        }
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
