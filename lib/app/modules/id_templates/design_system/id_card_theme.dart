import 'package:flutter/material.dart';

/// Reusable color identity for ID templates. Layout stays the same; only colors change.
class IdCardTheme {
  const IdCardTheme({
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.accentLight,
    required this.surface,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.detailLabel,
    required this.ringOuter,
    required this.ringInner,
  });

  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color accentLight;
  final Color surface;
  final Color onPrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color detailLabel;
  final Color ringOuter;
  final Color ringInner;

  /// Template 01 — Blue
  static const IdCardTheme template01Blue = IdCardTheme(
    primary: Color(0xFF1D4ED8),
    primaryDark: Color(0xFF1E3A8A),
    accent: Color(0xFF3B82F6),
    accentLight: Color(0xFF93C5FD),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    detailLabel: Color(0xFF64748B),
    ringOuter: Color(0xFF2563EB),
    ringInner: Color(0xFFDBEAFE),
  );

  /// Template 02 — Green (same layout, different palette)
  static const IdCardTheme template02Green = IdCardTheme(
    primary: Color(0xFF047857),
    primaryDark: Color(0xFF064E3B),
    accent: Color(0xFF10B981),
    accentLight: Color(0xFF6EE7B7),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    detailLabel: Color(0xFF64748B),
    ringOuter: Color(0xFF059669),
    ringInner: Color(0xFFD1FAE5),
  );

  /// Template 03 — Purple
  static const IdCardTheme template03Purple = IdCardTheme(
    primary: Color(0xFF6D28D9),
    primaryDark: Color(0xFF4C1D95),
    accent: Color(0xFF8B5CF6),
    accentLight: Color(0xFFC4B5FD),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    detailLabel: Color(0xFF64748B),
    ringOuter: Color(0xFF7C3AED),
    ringInner: Color(0xFFEDE9FE),
  );

  /// Template 04 — Orange
  static const IdCardTheme template04Orange = IdCardTheme(
    primary: Color(0xFFC2410C),
    primaryDark: Color(0xFF7C2D12),
    accent: Color(0xFFF97316),
    accentLight: Color(0xFFFDBA74),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    detailLabel: Color(0xFF64748B),
    ringOuter: Color(0xFFEA580C),
    ringInner: Color(0xFFFFEDD5),
  );

  static const List<IdCardTheme> studentVariants = <IdCardTheme>[
    template01Blue,
    template02Green,
    template03Purple,
    template04Orange,
  ];

  static IdCardTheme forStudentTemplateIndex(int globalTemplateIndex) {
    final variant = globalTemplateIndex % studentVariants.length;
    return studentVariants[variant];
  }
}
