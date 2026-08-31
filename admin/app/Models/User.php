<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Str;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'api_token',
        'is_premium',
        'premium_plan',
        'premium_activated_at',
        'premium_expires_at',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'api_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_premium' => 'boolean',
            'premium_activated_at' => 'datetime',
            'premium_expires_at' => 'datetime',
        ];
    }

    /**
     * Ensure email is always trimmed and lowercased.
     */
    protected function email(): Attribute
    {
        return Attribute::make(
            set: fn (string $value) => strtolower(trim($value)),
        );
    }

    public function paymentOrders(): HasMany
    {
        return $this->hasMany(PaymentOrder::class);
    }

    public function productOrders(): HasMany
    {
        return $this->hasMany(ProductOrder::class);
    }

    public function savedCards(): HasMany
    {
        return $this->hasMany(SavedCard::class);
    }

    public function deviceTokens(): HasMany
    {
        return $this->hasMany(UserDeviceToken::class);
    }

    /**
     * Issue a secure multi-device token.
     */
    public function createDeviceToken(?string $deviceName = null, ?string $deviceId = null): string
    {
        $token = 'bearer_' . Str::random(48);

        $this->deviceTokens()->create([
            'token' => $token,
            'device_name' => $deviceName ?: 'Mobile Device',
            'device_id' => $deviceId,
            'last_used_at' => now(),
        ]);

        // Keep users.api_token updated with latest token for backward compatibility
        $this->updateQuietly(['api_token' => $token]);

        return $token;
    }

    /**
     * Check if user currently has valid active premium access.
     */
    public function isPremiumActive(): bool
    {
        if (! $this->is_premium) {
            return false;
        }

        if ($this->premium_expires_at !== null && $this->premium_expires_at->isPast()) {
            return false;
        }

        return true;
    }

    /**
     * Compute dynamic payment status: 'Paid', 'Unpaid', or 'New'
     */
    public function getPaymentStatus(): string
    {
        if ($this->isPremiumActive()) {
            return 'Paid';
        }

        $hasPaidOrder = $this->productOrders()->whereIn('status', ['paid', 'delivered'])->exists();
        if ($hasPaidOrder) {
            return 'Paid';
        }

        $hasPendingOrder = $this->productOrders()->where('status', 'created')->exists();
        if ($hasPendingOrder) {
            return 'Unpaid';
        }

        return 'New';
    }

    /**
     * Calculate allowed template save limit.
     */
    public function getSaveLimit(): int
    {
        if (! $this->isPremiumActive()) {
            return 5;
        }

        return match ($this->premium_plan) {
            'yearly' => 35000,
            'basic' => 2500,
            'startup' => 500,
            default => 5,
        };
    }

    /**
     * Calculate remaining card saving capacity.
     */
    public function getRemainingCardCapacity(): int
    {
        $savedCount = $this->savedCards()->count();
        $limit = $this->getSaveLimit();

        return max(0, $limit - $savedCount);
    }
}
