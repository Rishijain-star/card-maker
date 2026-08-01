import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card(bool isDark) => [
    BoxShadow(
      color: isDark
          ? const Color.fromRGBO(0, 0, 0, 0.30)
          : const Color.fromRGBO(15, 23, 42, 0.06),
      blurRadius: isDark ? 22 : 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> button(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.12),
      blurRadius: isDark ? 24 : 18,
      offset: const Offset(0, 10),
    ),
  ];
}
