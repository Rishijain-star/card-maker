@extends('admin.layouts.app')

@section('content')
@if (session('success'))
    <div class="alert-success">{{ session('success') }}</div>
@endif

<div class="panel" style="margin-bottom:20px">
    <div class="panel-head">
        <h3>Add Product</h3>
        <button type="button" class="btn-primary" onclick="toggleAddForm()">+ Add Product</button>
    </div>
    <div id="addProductForm" class="product-form-wrap" style="display:none">
        <form method="POST" action="{{ route('admin.products.store') }}" enctype="multipart/form-data" class="product-form">
            @csrf
            <div class="form-row">
                <div class="field">
                    <label>Name</label>
                    <input type="text" name="name" value="{{ old('name') }}" placeholder="e.g. ID CARD" required>
                    @error('name')<span class="field-error">{{ $message }}</span>@enderror
                </div>
                <div class="field">
                    <label>Price (₹)</label>
                    <input type="number" name="price" value="{{ old('price') }}" min="1" placeholder="25" required>
                    @error('price')<span class="field-error">{{ $message }}</span>@enderror
                </div>
            </div>
            <div class="field">
                <label>Description</label>
                <input type="text" name="description" value="{{ old('description') }}" placeholder="Short description">
                @error('description')<span class="field-error">{{ $message }}</span>@enderror
            </div>
            <div class="field">
                <label>Image</label>
                <input type="file" name="image" accept="image/*">
                @error('image')<span class="field-error">{{ $message }}</span>@enderror
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-primary">Save Product</button>
                <button type="button" class="btn-secondary" onclick="toggleAddForm()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div class="panel">
    <div class="panel-head">
        <h3>All Products</h3>
        <span>{{ $products->count() }} items</span>
    </div>
    <div class="products-list">
        @forelse ($products as $product)
            <form method="POST" action="{{ route('admin.products.update', $product) }}" enctype="multipart/form-data" class="product-row">
                @csrf
                @method('PUT')
                <div class="product-thumb">
                    @if ($product->imageUrl())
                        <img src="{{ $product->imageUrl() }}" alt="{{ $product->name }}">
                    @else
                        <div class="product-thumb-placeholder">📦</div>
                    @endif
                </div>
                <div class="product-fields">
                    <div class="field">
                        <label>Name</label>
                        <input type="text" name="name" value="{{ $product->name }}" required>
                    </div>
                    <div class="field">
                        <label>Description</label>
                        <input type="text" name="description" value="{{ $product->description }}">
                    </div>
                    @if (!empty($product->sizes))
                        <div class="field">
                            <label>Sizes (auto from product type)</label>
                            <input type="text" value="{{ implode(', ', $product->sizes) }}" disabled>
                        </div>
                    @endif
                </div>
                <div class="product-price-col">
                    <div class="field">
                        <label>Price (₹)</label>
                        <input type="number" name="price" value="{{ $product->price }}" min="1" required class="price-input">
                    </div>
                    <div class="field">
                        <label>Change image</label>
                        <input type="file" name="image" accept="image/*">
                    </div>
                    <button type="submit" class="btn-save">Update</button>
                </div>
            </form>
        @empty
            <div class="empty-products">No products yet. Click "Add Product" above.</div>
        @endforelse
    </div>
</div>

<script>
function toggleAddForm() {
    const el = document.getElementById('addProductForm');
    el.style.display = el.style.display === 'none' ? 'block' : 'none';
}
@if ($errors->any() && old('name'))
toggleAddForm();
@endif
</script>
@endsection
