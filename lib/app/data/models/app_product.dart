import 'package:flutter/material.dart';

class AppProduct {
  const AppProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.status,
    required this.sizes,
    required this.supportsSizes,
  });

  final int id;
  final String name;
  final String slug;
  final String category;
  final String description;
  final int price;
  final String? imageUrl;
  final String status;
  final List<String> sizes;
  final bool supportsSizes;

  String get title => name;
  int get unitPrice => price;

  Color get accent => _accentForSlug(slug, name);

  IconData get icon => _iconForSlug(slug, name);

  bool matchesSavedDesignService(String service) {
    final key = name.toUpperCase();
    final catKey = category.toUpperCase();
    final s = service.toUpperCase();
    if (key.contains('ID') ||
        key.contains('CARD') ||
        catKey.contains('CARD') ||
        catKey == 'ID CARD') {
      return s.contains('CARD') ||
          s.contains('STUDENT') ||
          s.contains('EMPLOYEE');
    }
    if (key.contains('LANYARD') ||
        key.contains('DORI') ||
        catKey.contains('LANYARD')) {
      return s.contains('LANYARD');
    }
    return false;
  }

  factory AppProduct.fromJson(Map<String, dynamic> json) {
    final rawSizes = json['sizes'];
    final sizes = rawSizes is List
        ? rawSizes.map((dynamic e) => '$e').toList()
        : <String>[];

    String? img = json['image_url'] as String?;
    if (img != null && img.trim().isNotEmpty) {
      img = img.trim();
      if (img.contains('admin.idshaydi.in/uploads/')) {
        img = img.replaceAll('admin.idshaydi.in/uploads/', 'admin.idshaydi.in/public/uploads/');
      }
    } else {
      img = null;
    }

    final nameStr = '${json['name'] ?? ''}';
    final rawCat = json['category']?.toString().trim();
    final categoryStr = (rawCat != null && rawCat.isNotEmpty)
        ? rawCat
        : _inferCategory(nameStr);

    return AppProduct(
      id: json['id'] as int? ?? 0,
      name: nameStr,
      slug: '${json['slug'] ?? ''}',
      category: categoryStr,
      description: '${json['description'] ?? ''}',
      price: json['price'] as int? ?? 0,
      imageUrl: img,
      status: '${json['status'] ?? 'Active'}',
      sizes: sizes,
      supportsSizes: json['supports_sizes'] as bool? ?? sizes.isNotEmpty,
    );
  }

  static String _inferCategory(String name) {
    final key = name.toUpperCase();
    if (key.contains('ID') && key.contains('CARD')) return 'ID Card';
    if (key.contains('LANYARD') ||
        key.contains('DORI') ||
        key.contains('RIBBON')) {
      return 'Lanyard';
    }
    if (key.contains('BADGE')) return 'Badge';
    if (key.contains('BELT')) return 'Belt';
    if (key.contains('HOLDER') || key.contains('CASE')) return 'Card Holder';
    return 'General';
  }

  static Color _accentForSlug(String slug, String name) {
    final key = slug.isNotEmpty ? slug : name.toLowerCase();
    if (key.contains('id') && key.contains('card')) {
      return const Color(0xFF3B82F6);
    }
    if (key.contains('lanyard')) return const Color(0xFF8B5CF6);
    if (key.contains('badge')) return const Color(0xFFF59E0B);
    if (key.contains('belt')) return const Color(0xFF22C55E);
    return const Color(0xFF6366F1);
  }

  static IconData _iconForSlug(String slug, String name) {
    final key = slug.isNotEmpty ? slug : name.toLowerCase();
    if (key.contains('id') && key.contains('card')) {
      return Icons.badge_outlined;
    }
    if (key.contains('lanyard')) return Icons.card_membership_outlined;
    if (key.contains('badge')) return Icons.military_tech_outlined;
    if (key.contains('belt')) return Icons.straighten_rounded;
    return Icons.inventory_2_outlined;
  }
}
