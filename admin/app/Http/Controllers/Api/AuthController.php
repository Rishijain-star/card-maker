<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserDeviceToken;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    /**
     * Register a new user account.
     * Enforces: Exactly ONE account per email (case-insensitive & trimmed).
     */
    public function register(Request $request): JsonResponse
    {
        $rawEmail = (string) $request->input('email', '');
        $cleanEmail = strtolower(trim($rawEmail));

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors(),
            ], 422);
        }

        // 1. Application-level check for existing normalized email
        $existing = User::where('email', $cleanEmail)->first();
        if ($existing) {
            return response()->json([
                'status' => false,
                'message' => 'An account with this email already exists. Please log in.',
                'account_exists' => true,
            ], 422);
        }

        // 2. Atomic database transaction with race-condition protection
        try {
            $user = DB::transaction(function () use ($request, $cleanEmail) {
                return User::create([
                    'name' => trim($request->name),
                    'email' => $cleanEmail,
                    'password' => Hash::make($request->password),
                ]);
            });
        } catch (QueryException $e) {
            // Catches database-level unique constraint collision
            return response()->json([
                'status' => false,
                'message' => 'An account with this email already exists. Please log in.',
                'account_exists' => true,
            ], 422);
        }

        // 3. Issue multi-device session token
        $deviceName = $request->input('device_name', 'Mobile Device');
        $deviceId = $request->input('device_id');
        $token = $user->createDeviceToken($deviceName, $deviceId);

        return response()->json([
            'status' => true,
            'message' => 'Registration successful',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'is_premium' => (bool) $user->is_premium,
                'premium_plan' => $user->premium_plan,
                'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                'save_limit' => $user->getSaveLimit(),
                'saved_cards_count' => 0,
                'remaining_capacity' => $user->getSaveLimit(),
            ],
        ], 201);
    }

    /**
     * Authenticate user into existing account.
     * Generates a device-specific session token without invalidating other devices.
     */
    public function login(Request $request): JsonResponse
    {
        $cleanEmail = strtolower(trim((string) $request->input('email', '')));

        $validator = Validator::make([
            'email' => $cleanEmail,
            'password' => $request->password,
        ], [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        // Find user by normalized email
        $user = User::where('email', $cleanEmail)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid email or password. Try again or create an account.',
            ], 401);
        }

        // Issue new multi-device session token without invalidating other devices
        $deviceName = $request->input('device_name', 'Mobile Device');
        $deviceId = $request->input('device_id');
        $token = $user->createDeviceToken($deviceName, $deviceId);

        $savedCardsCount = $user->savedCards()->count();

        return response()->json([
            'status' => true,
            'message' => 'Login successful',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'is_premium' => $user->isPremiumActive(),
                'premium_plan' => $user->premium_plan,
                'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                'save_limit' => $user->getSaveLimit(),
                'saved_cards_count' => $savedCardsCount,
                'remaining_capacity' => $user->getRemainingCardCapacity(),
            ],
        ], 200);
    }

    /**
     * Get current authenticated user profile & limits.
     * GET /api/v1/auth/me
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        $savedCardsCount = $user->savedCards()->count();

        return response()->json([
            'status' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'is_premium' => $user->isPremiumActive(),
                'premium_plan' => $user->premium_plan,
                'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                'save_limit' => $user->getSaveLimit(),
                'saved_cards_count' => $savedCardsCount,
                'remaining_capacity' => $user->getRemainingCardCapacity(),
            ],
        ]);
    }

    /**
     * Logout from the current device only.
     * POST /api/v1/auth/logout
     */
    public function logout(Request $request): JsonResponse
    {
        $token = $request->bearerToken();

        if (! empty($token)) {
            $deviceToken = UserDeviceToken::with('user')->where('token', $token)->first();
            if ($deviceToken) {
                $user = $deviceToken->user;
                $deviceToken->delete();
                if ($user && $user->api_token === $token) {
                    $user->updateQuietly(['api_token' => null]);
                }
            } else {
                User::where('api_token', $token)->update(['api_token' => null]);
            }
        }

        return response()->json([
            'status' => true,
            'message' => 'Logged out successfully from this device.',
        ]);
    }

    /**
     * Authenticate or link social provider (Google / Apple).
     * Strictly enforces: One Email = One Account.
     * POST /api/v1/auth/social
     */
    public function socialLogin(Request $request): JsonResponse
    {
        $cleanEmail = strtolower(trim((string) $request->input('email', '')));

        $validator = Validator::make([
            'email' => $cleanEmail,
            'name' => $request->input('name'),
        ], [
            'email' => 'required|email',
            'name' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        // 1. If user with this email already exists, link to the existing account!
        $user = User::where('email', $cleanEmail)->first();

        if (! $user) {
            // Create new user with secure random password
            try {
                $user = DB::transaction(function () use ($request, $cleanEmail) {
                    return User::create([
                        'name' => trim($request->input('name') ?: 'User'),
                        'email' => $cleanEmail,
                        'password' => Hash::make(\Illuminate\Support\Str::random(32)),
                    ]);
                });
            } catch (QueryException $e) {
                $user = User::where('email', $cleanEmail)->first();
            }
        }

        if (! $user) {
            return response()->json([
                'status' => false,
                'message' => 'Could not authenticate social user.',
            ], 500);
        }

        // 2. Issue multi-device token
        $deviceName = $request->input('device_name', 'Mobile Device (' . ($request->input('provider') ?: 'Social') . ')');
        $deviceId = $request->input('device_id');
        $token = $user->createDeviceToken($deviceName, $deviceId);

        $savedCardsCount = $user->savedCards()->count();

        return response()->json([
            'status' => true,
            'message' => 'Social login successful',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'is_premium' => $user->isPremiumActive(),
                'premium_plan' => $user->premium_plan,
                'premium_expires_at' => $user->premium_expires_at?->toIso8601String(),
                'save_limit' => $user->getSaveLimit(),
                'saved_cards_count' => $savedCardsCount,
                'remaining_capacity' => $user->getRemainingCardCapacity(),
            ],
        ], 200);
    }
}
