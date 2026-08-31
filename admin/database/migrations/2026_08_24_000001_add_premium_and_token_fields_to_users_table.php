<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            if (! Schema::hasColumn('users', 'api_token')) {
                $table->string('api_token', 80)->nullable()->unique()->after('password');
            }
            if (! Schema::hasColumn('users', 'is_premium')) {
                $table->boolean('is_premium')->default(false)->after('api_token');
            }
            if (! Schema::hasColumn('users', 'premium_plan')) {
                $table->string('premium_plan', 50)->nullable()->after('is_premium');
            }
            if (! Schema::hasColumn('users', 'premium_activated_at')) {
                $table->timestamp('premium_activated_at')->nullable()->after('premium_plan');
            }
            if (! Schema::hasColumn('users', 'premium_expires_at')) {
                $table->timestamp('premium_expires_at')->nullable()->after('premium_activated_at');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $columnsToDrop = [];
            foreach (['api_token', 'is_premium', 'premium_plan', 'premium_activated_at', 'premium_expires_at'] as $column) {
                if (Schema::hasColumn('users', $column)) {
                    $columnsToDrop[] = $column;
                }
            }
            if (! empty($columnsToDrop)) {
                $table->dropColumn($columnsToDrop);
            }
        });
    }
};
