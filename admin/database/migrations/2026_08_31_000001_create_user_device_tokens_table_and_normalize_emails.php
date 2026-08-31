<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Create user_device_tokens table for secure multi-device sessions
        if (! Schema::hasTable('user_device_tokens')) {
            Schema::create('user_device_tokens', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
                $table->string('token', 80)->unique();
                $table->string('device_name')->nullable();
                $table->string('device_id')->nullable();
                $table->timestamp('last_used_at')->nullable();
                $table->timestamps();

                $table->index(['user_id', 'token']);
            });
        }

        // 2. Normalize all existing user emails (trim + lowercase)
        DB::statement('UPDATE users SET email = LOWER(TRIM(email))');

        // 3. Backfill existing active api_token into user_device_tokens for seamless backward-compatibility
        $existingTokens = DB::table('users')
            ->whereNotNull('api_token')
            ->where('api_token', '!=', '')
            ->get(['id', 'api_token', 'created_at', 'updated_at']);

        foreach ($existingTokens as $u) {
            $exists = DB::table('user_device_tokens')->where('token', $u->api_token)->exists();
            if (! $exists) {
                DB::table('user_device_tokens')->insert([
                    'user_id' => $u->id,
                    'token' => $u->api_token,
                    'device_name' => 'Legacy Session',
                    'last_used_at' => now(),
                    'created_at' => $u->created_at ?? now(),
                    'updated_at' => $u->updated_at ?? now(),
                ]);
            }
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_device_tokens');
    }
};
