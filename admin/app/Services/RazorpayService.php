<?php

namespace App\Services;

use Exception;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class RazorpayService
{
    /**
     * Authoritative plan definitions.
     *
     * @var array<string, array{name: string, amount: int, currency: string, duration_days: int, save_limit: int}>
     */
    public const PLANS = [
        'startup' => [
            'name' => 'Startup',
            'amount' => 11800, // ₹118 in paise
            'currency' => 'INR',
            'duration_days' => 30,
            'save_limit' => 500,
        ],
        'basic' => [
            'name' => 'Basic',
            'amount' => 23600, // ₹236 in paise
            'currency' => 'INR',
            'duration_days' => 30,
            'save_limit' => 2500,
        ],
        'yearly' => [
            'name' => 'Yearly',
            'amount' => 212400, // ₹2,124 in paise (25% OFF discount applied)
            'currency' => 'INR',
            'duration_days' => 365,
            'save_limit' => 35000,
        ],
    ];

    public function getKeyId(): string
    {
        return (string) config('services.razorpay.key_id');
    }

    protected function getKeySecret(): string
    {
        return (string) config('services.razorpay.key_secret');
    }

    protected function getWebhookSecret(): string
    {
        return (string) config('services.razorpay.webhook_secret');
    }

    /**
     * Get plan configuration by package_id.
     *
     * @return array{name: string, amount: int, currency: string, duration_days: int, save_limit: int}|null
     */
    public function getPlan(string $packageId): ?array
    {
        return self::PLANS[$packageId] ?? null;
    }

    /**
     * Create an order on Razorpay for Premium subscription.
     *
     * @throws Exception
     */
    public function createOrder(string $packageId, int $userId): array
    {
        $plan = $this->getPlan($packageId);
        if (! $plan) {
            throw new Exception("Invalid package identifier: {$packageId}");
        }

        $receipt = 'rcpt_'.substr(md5(uniqid((string) $userId, true)), 0, 16);

        return $this->createCustomOrder(
            $plan['amount'],
            $plan['currency'],
            $receipt,
            [
                'user_id' => (string) $userId,
                'package_id' => $packageId,
                'plan_name' => $plan['name'],
                'type' => 'premium',
            ]
        );
    }

    /**
     * Generic order creation on Razorpay (for product cart checkout & custom orders).
     *
     * @param  array<string, string>  $notes
     *
     * @throws Exception
     */
    public function createCustomOrder(int $amountPaise, string $currency, string $receipt, array $notes = []): array
    {
        $response = Http::withBasicAuth($this->getKeyId(), $this->getKeySecret())
            ->timeout(15)
            ->post('https://api.razorpay.com/v1/orders', [
                'amount' => $amountPaise,
                'currency' => $currency,
                'receipt' => $receipt,
                'notes' => $notes,
            ]);

        if (! $response->successful()) {
            Log::error('Razorpay Custom Order Creation Failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);
            throw new Exception('Failed to create Razorpay order: '.$response->json('error.description', 'API Error'));
        }

        return $response->json();
    }

    /**
     * Verify HMAC-SHA256 signature from client.
     */
    public function verifySignature(string $orderId, string $paymentId, string $signature): bool
    {
        $expectedSignature = hash_hmac('sha256', $orderId.'|'.$paymentId, $this->getKeySecret());

        return hash_equals($expectedSignature, $signature);
    }

    /**
     * Fetch payment status and details from Razorpay API.
     */
    public function fetchPayment(string $paymentId): ?array
    {
        try {
            $response = Http::withBasicAuth($this->getKeyId(), $this->getKeySecret())
                ->timeout(15)
                ->get("https://api.razorpay.com/v1/payments/{$paymentId}");

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('Razorpay Fetch Payment Failed', [
                'payment_id' => $paymentId,
                'status' => $response->status(),
                'body' => $response->body(),
            ]);
        } catch (Exception $e) {
            Log::error('Razorpay Fetch Payment Exception', [
                'payment_id' => $paymentId,
                'error' => $e->getMessage(),
            ]);
        }

        return null;
    }

    /**
     * Verify webhook signature.
     */
    public function verifyWebhookSignature(string $rawPayload, string $signatureHeader): bool
    {
        $webhookSecret = $this->getWebhookSecret();
        if (empty($webhookSecret)) {
            Log::warning('RAZORPAY_WEBHOOK_SECRET is not configured');

            return false;
        }

        $expectedSignature = hash_hmac('sha256', $rawPayload, $webhookSecret);

        return hash_equals($expectedSignature, $signatureHeader);
    }
}
