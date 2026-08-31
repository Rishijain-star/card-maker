<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SavedCard;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CardController extends Controller
{
    /**
     * Helper to decode and store base64 image to public/uploads/cards
     */
    public static function storeBase64CardImage(?string $data, string $prefix): ?string
    {
        if (empty($data)) {
            return null;
        }

        // If it's already an existing web URL or clean relative path
        if (str_starts_with($data, 'http://') || str_starts_with($data, 'https://') || str_starts_with($data, 'uploads/')) {
            return $data;
        }

        // If it starts with local device path without base64, return null
        if (str_starts_with($data, '/data/') || str_starts_with($data, '/storage/')) {
            return null;
        }

        $raw = $data;
        if (str_contains($raw, 'base64,')) {
            $parts = explode('base64,', $raw);
            $raw = $parts[1] ?? '';
        }

        $decoded = base64_decode($raw, true);
        if ($decoded !== false && strlen($decoded) > 20) {
            $dir = public_path('uploads/cards');
            if (! file_exists($dir)) {
                mkdir($dir, 0755, true);
            }

            $filename = $prefix . '_' . uniqid() . '.png';
            file_put_contents($dir . '/' . $filename, $decoded);

            return 'uploads/cards/' . $filename;
        }

        return null;
    }

    /**
     * Fetch all saved cards belonging exclusively to the authenticated user.
     * GET /api/v1/cards
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $cards = SavedCard::where('user_id', $user->id)
            ->latest('saved_at_ms')
            ->get();

        $host = $request->getSchemeAndHttpHost();

        $cardList = $cards->map(function ($card) use ($host) {
            $frontUrl = null;
            if ($card->front_path) {
                $frontUrl = str_starts_with($card->front_path, 'http') ? $card->front_path : $host . '/' . ltrim($card->front_path, '/');
            }

            $backUrl = null;
            if ($card->back_path) {
                $backUrl = str_starts_with($card->back_path, 'http') ? $card->back_path : $host . '/' . ltrim($card->back_path, '/');
            }

            return [
                'id' => $card->id,
                'client_pair_id' => $card->client_pair_id,
                'title' => $card->title,
                'student_name' => $card->student_name,
                'institute_name' => $card->institute_name,
                'service' => $card->service,
                'template_name' => $card->template_name,
                'font_family' => $card->font_family,
                'front_path' => $card->front_path,
                'back_path' => $card->back_path,
                'front_url' => $frontUrl,
                'back_url' => $backUrl,
                'form_data' => $card->form_data,
                'saved_at_ms' => $card->saved_at_ms,
                'created_at' => $card->created_at?->toIso8601String(),
            ];
        });

        return response()->json([
            'status' => true,
            'data' => $cardList,
            'meta' => [
                'total_saved' => $cards->count(),
                'save_limit' => $user->getSaveLimit(),
                'remaining_capacity' => $user->getRemainingCardCapacity(),
                'is_premium' => $user->isPremiumActive(),
                'plan' => $user->premium_plan,
            ],
        ]);
    }

    /**
     * Sync/Upload a saved card from mobile app to server.
     * Enforces atomic quota checking with concurrency protection.
     * POST /api/v1/cards/sync
     */
    public function sync(Request $request): JsonResponse
    {
        $user = $request->user();

        $pairId = $request->input('client_pair_id') ?: (string) (time() . rand(100, 999));
        $title = $request->input('title') ?: 'ID Card';
        $studentName = $request->input('student_name') ?: '';
        $instituteName = $request->input('institute_name') ?: '';
        $service = $request->input('service') ?: 'Student ID Card';
        $templateName = $request->input('template_name') ?: 'Template 1';
        $fontFamily = $request->input('font_family') ?: 'Poppins';
        $savedAtMs = $request->input('saved_at_ms') ?: (int) (microtime(true) * 1000);

        $formData = $request->input('form_data');
        if (is_string($formData)) {
            $decoded = json_decode($formData, true);
            if (json_last_error() === JSON_ERROR_NONE) {
                $formData = $decoded;
            }
        }

        // Atomic transaction with row lock on user to prevent race condition quota bypass
        $result = DB::transaction(function () use ($user, $pairId, $title, $studentName, $instituteName, $service, $templateName, $fontFamily, $savedAtMs, $formData, $request) {
            // Lock user row for update
            $lockedUser = User::where('id', $user->id)->lockForUpdate()->first();
            $limit = $lockedUser->getSaveLimit();

            $existingCard = SavedCard::where('user_id', $lockedUser->id)
                ->where('client_pair_id', $pairId)
                ->first();

            // If it is a new card, check if limit would be exceeded
            if (! $existingCard) {
                $currentCount = $lockedUser->savedCards()->count();
                if ($currentCount >= $limit) {
                    return [
                        'error' => true,
                        'message' => "Card limit reached ({$currentCount}/{$limit}). Upgrade your plan to save more cards.",
                        'current_count' => $currentCount,
                        'limit' => $limit,
                    ];
                }
            }

            // Decode and store images
            $frontPath = self::storeBase64CardImage($request->input('front_image_base64'), 'card_' . $lockedUser->id . '_front');
            $backPath = self::storeBase64CardImage($request->input('back_image_base64'), 'card_' . $lockedUser->id . '_back');

            if ($existingCard) {
                $existingCard->update([
                    'title' => $title,
                    'student_name' => $studentName,
                    'institute_name' => $instituteName,
                    'service' => $service,
                    'template_name' => $templateName,
                    'font_family' => $fontFamily,
                    'front_path' => $frontPath ?: $existingCard->front_path,
                    'back_path' => $backPath ?: $existingCard->back_path,
                    'form_data' => $formData ?: $existingCard->form_data,
                    'saved_at_ms' => $savedAtMs,
                ]);
                $card = $existingCard;
            } else {
                $card = SavedCard::create([
                    'user_id' => $lockedUser->id,
                    'client_pair_id' => $pairId,
                    'title' => $title,
                    'student_name' => $studentName,
                    'institute_name' => $instituteName,
                    'service' => $service,
                    'template_name' => $templateName,
                    'font_family' => $fontFamily,
                    'front_path' => $frontPath,
                    'back_path' => $backPath,
                    'form_data' => $formData,
                    'saved_at_ms' => $savedAtMs,
                ]);
            }

            return [
                'error' => false,
                'card' => $card,
                'total_saved' => $lockedUser->savedCards()->count(),
                'limit' => $limit,
                'remaining' => $lockedUser->getRemainingCardCapacity(),
            ];
        });

        if (! empty($result['error'])) {
            return response()->json([
                'status' => false,
                'message' => $result['message'],
                'limit_reached' => true,
                'current_count' => $result['current_count'],
                'limit' => $result['limit'],
            ], 403);
        }

        $card = $result['card'];
        $host = $request->getSchemeAndHttpHost();

        return response()->json([
            'status' => true,
            'message' => 'Card synced successfully',
            'data' => [
                'card_id' => $card->id,
                'client_pair_id' => $card->client_pair_id,
                'front_url' => $card->front_path ? (str_starts_with($card->front_path, 'http') ? $card->front_path : $host . '/' . ltrim($card->front_path, '/')) : null,
                'back_url' => $card->back_path ? (str_starts_with($card->back_path, 'http') ? $card->back_path : $host . '/' . ltrim($card->back_path, '/')) : null,
                'form_data' => $card->form_data,
            ],
            'meta' => [
                'total_saved' => $result['total_saved'],
                'save_limit' => $result['limit'],
                'remaining_capacity' => $result['remaining'],
            ],
        ], 200);
    }

    /**
     * Delete a saved card belonging to authenticated user and free quota slot.
     * DELETE /api/v1/cards/{idOrPairId}
     */
    public function destroy(Request $request, string $idOrPairId): JsonResponse
    {
        $user = $request->user();

        $card = SavedCard::where('user_id', $user->id)
            ->where(function ($q) use ($idOrPairId) {
                $q->where('id', $idOrPairId)->orWhere('client_pair_id', $idOrPairId);
            })
            ->first();

        if (! $card) {
            return response()->json([
                'status' => false,
                'message' => 'Card not found or does not belong to your account.',
            ], 404);
        }

        // Delete physical files if safe to remove
        if (! empty($card->front_path) && file_exists(public_path($card->front_path))) {
            @unlink(public_path($card->front_path));
        }
        if (! empty($card->back_path) && file_exists(public_path($card->back_path))) {
            @unlink(public_path($card->back_path));
        }

        $card->delete();

        return response()->json([
            'status' => true,
            'message' => 'Card deleted successfully.',
            'meta' => [
                'total_saved' => $user->savedCards()->count(),
                'save_limit' => $user->getSaveLimit(),
                'remaining_capacity' => $user->getRemainingCardCapacity(),
            ],
        ]);
    }
}
