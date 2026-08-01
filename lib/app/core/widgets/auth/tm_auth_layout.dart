import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tripmates/tm_logo.dart';

/// Global horizontal rhythm, sheet insets, and vertical gaps for pre-dashboard
/// auth, signup, verification, and driver onboarding chrome.
///
/// Use [TmAuthBrandedLogo] instead of raw [TmLogo] on these surfaces so sizing
/// stays consistent and responsive.
abstract final class TmAuthLayout {
  static const double hPad = 22;
  static const double topPad = 14;
  static const double bodyBottomPad = 14;
  static const double bottomPad = 22;
  static const double scrollBottomPad = 12;
  static const double aboveBottomBar = 10;
  static const double sectionGap = 22;
  static const double tightGap = 16;
  static const double betweenPrimarySecondary = 14;

  /// Single scale factor for [TmLogo] across auth / verification.
  static const double logoScale = 1.4;

  /// Hero logo: visible, premium, not oversized (responsive to viewport).
  static double logoSizeFor({
    required double maxHeight,
    required double maxWidth,
    TmAuthLogoVariant variant = TmAuthLogoVariant.hero,
  }) {
    final h = maxHeight.isFinite ? maxHeight.clamp(380.0, 860.0) : 480.0;
    final w = maxWidth.isFinite ? maxWidth.clamp(300.0, 520.0) : 340.0;
    final byH = h * 0.22;
    final byW = w * 0.42;
    var s = math.min(byH, byW).clamp(148.0, 172.0);
    if (variant == TmAuthLogoVariant.compact) {
      s = (s * 0.52).clamp(82.0, 108.0);
    }
    return s;
  }

  /// Decorative icons (e.g. mail) sized from the same viewport as the logo.
  static double decorativeIconSize({
    required double maxHeight,
    required double maxWidth,
  }) {
    final logo = logoSizeFor(maxHeight: maxHeight, maxWidth: maxWidth);
    return (logo * 0.64).clamp(100.0, 124.0);
  }
}

enum TmAuthLogoVariant { hero, compact }

/// Responsive TripMates logo for auth flows — do not pass manual [TmLogo.size]
/// on these screens; use this widget (optionally [variant] compact).
class TmAuthBrandedLogo extends StatelessWidget {
  const TmAuthBrandedLogo({
    super.key,
    this.variant = TmAuthLogoVariant.hero,
    this.bottomGutter = 4,
  });

  final TmAuthLogoVariant variant;
  final double bottomGutter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final mq = MediaQuery.sizeOf(context);
        final h = c.maxHeight.isFinite && c.maxHeight < double.infinity
            ? c.maxHeight
            : mq.height * 0.44;
        final w = c.maxWidth.isFinite && c.maxWidth < double.infinity
            ? c.maxWidth
            : mq.width - 2 * TmAuthLayout.hPad;
        final size = TmAuthLayout.logoSizeFor(
          maxHeight: h,
          maxWidth: w,
          variant: variant,
        );
        return Padding(
          padding: EdgeInsets.only(bottom: bottomGutter),
          child: Center(
            child: TmLogo(size: size, scale: TmAuthLayout.logoScale),
          ),
        );
      },
    );
  }
}
