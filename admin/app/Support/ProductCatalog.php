<?php

namespace App\Support;

use App\Models\Product;
use Illuminate\Support\Str;

final class ProductCatalog
{
    /** @return list<string> */
    public static function sizesForName(string $name): array
    {
        $key = Str::upper(trim($name));

        if (self::nameMatches($key, ['ID CARD', 'IDCARD', 'ID-CARD'])) {
            return ['12 mm', '14 mm', '16 mm'];
        }

        if (self::nameMatches($key, ['LANYARD', 'LANYARDS'])) {
            return ['12 mm', '16 mm', '20 mm'];
        }

        if (self::nameMatches($key, ['BADGE', 'BADGES'])) {
            return ['44 mm', '52 mm'];
        }

        if (self::nameMatches($key, ['BELT', 'BELTS'])) {
            return ['30 inch', '32 inch', '34 inch', '36 inch', '39 inch'];
        }

        return [];
    }

    public static function slugFromName(string $name): string
    {
        return Str::slug(Str::upper(trim($name)));
    }

    public static function supportsSizes(string $name): bool
    {
        return self::sizesForName($name) !== [];
    }

    public static function applyCatalogMeta(Product $product): void
    {
        $product->slug = self::slugFromName($product->name);
        $product->sizes = self::sizesForName($product->name);
    }

    /** @param list<string> $needles */
    private static function nameMatches(string $haystack, array $needles): bool
    {
        foreach ($needles as $needle) {
            if (str_contains($haystack, $needle)) {
                return true;
            }
        }

        return false;
    }
}
