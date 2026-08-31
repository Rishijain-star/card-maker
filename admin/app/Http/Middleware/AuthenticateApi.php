<?php

namespace App\Http\Middleware;

use App\Models\User;
use App\Models\UserDeviceToken;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AuthenticateApi
{
    /**
     * Handle an incoming API request.
     * Enforces strict authentication per session/device token.
     * ZERO fallback to default/demo users.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $token = $request->bearerToken();

        if (! empty($token)) {
            // 1. Check multi-device token table
            $deviceToken = UserDeviceToken::with('user')->where('token', $token)->first();

            if ($deviceToken && $deviceToken->user) {
                // Update last used timestamp in background
                $deviceToken->updateQuietly(['last_used_at' => now()]);

                $request->setUserResolver(fn () => $deviceToken->user);
                $request->attributes->set('current_device_token', $deviceToken);

                return $next($request);
            }

            // 2. Backward compatibility: check legacy users.api_token
            $legacyUser = User::where('api_token', $token)->first();
            if ($legacyUser) {
                // Backfill into user_device_tokens so future requests use multi-device session
                UserDeviceToken::firstOrCreate(
                    ['token' => $token],
                    [
                        'user_id' => $legacyUser->id,
                        'device_name' => 'Mobile Device',
                        'last_used_at' => now(),
                    ]
                );

                $request->setUserResolver(fn () => $legacyUser);

                return $next($request);
            }
        }

        // Strict 401 Unauthorized — ZERO fallback to any other user
        return response()->json([
            'status' => false,
            'message' => 'Unauthenticated. Please log in to proceed.',
        ], 401);
    }
}
