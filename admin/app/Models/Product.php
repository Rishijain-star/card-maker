<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'description',
        'price',
        'image',
        'status',
        'sizes',
    ];

    protected $casts = [
        'sizes' => 'array',
        'price' => 'integer',
    ];

    public function imageUrl(): ?string
    {
        if ($this->image === null || $this->image === '') {
            return null;
        }

        return asset('uploads/products/'.$this->image);
    }
}
