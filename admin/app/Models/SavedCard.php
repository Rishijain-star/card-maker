<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SavedCard extends Model
{
    use HasFactory;

    protected $table = 'saved_cards';

    protected $fillable = [
        'user_id',
        'client_pair_id',
        'title',
        'institute_name',
        'student_name',
        'service',
        'template_name',
        'font_family',
        'front_path',
        'back_path',
        'saved_at_ms',
        'form_data',
    ];

    protected $casts = [
        'form_data' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function frontUrl(): ?string
    {
        if (empty($this->front_path)) {
            return null;
        }

        return asset($this->front_path);
    }

    public function backUrl(): ?string
    {
        if (empty($this->back_path)) {
            return null;
        }

        return asset($this->back_path);
    }
}
