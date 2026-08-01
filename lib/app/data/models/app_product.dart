import 'package:flutter/material.dart';

class AppProduct {
  const AppProduct({
    required this.id,
    required this.name,
    required this.slug,
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
    if (key.contains('ID') && key.contains('CARD')) {
      return service == 'Student ID Card' ||
          service == 'Employee ID Card' ||
          service == 'ID Card';
    }
    if (key.contains('LANYARD')) {
      return service == 'Lanyard';
    }
    return false;
  }

  factory AppProduct.fromJson(Map<String, dynamic> json) {
    final rawSizes = json['sizes'];
    final sizes = rawSizes is List
        ? rawSizes.map((dynamic e) => '$e').toList()
        : <String>[];

    return AppProduct(
      id: json['id'] as int? ?? 0,
      name: '${json['name'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      description: '${json['description'] ?? ''}',
      price: json['price'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      status: '${json['status'] ?? 'Active'}',
      sizes: sizes,
      supportsSizes: json['supports_sizes'] as bool? ?? sizes.isNotEmpty,
    );
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
