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
        if (Schema::hasTable('saved_cards') && ! Schema::hasColumn('saved_cards', 'form_data')) {
            Schema::table('saved_cards', function (Blueprint $table) {
                $table->longText('form_data')->nullable()->after('saved_at_ms');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasTable('saved_cards') && Schema::hasColumn('saved_cards', 'form_data')) {
            Schema::table('saved_cards', function (Blueprint $table) {
                $table->dropColumn('form_data');
            });
        }
    }
};
