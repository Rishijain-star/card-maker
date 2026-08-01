import 'package:flutter/material.dart';

import 'tm_auth_layout.dart';

export 'tm_auth_layout.dart';

/// TripMates brand tokens for pre-dashboard auth / verification (matches passenger shell).
abstract final class TmAuthTokens {
  static const Color primaryGreen = Color(0xFF16803C);
  static const Color softGreen = Color(0xFFEAF7EF);
  static const Color screenBg = Color(0xFFF6FAF7);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const String heroAsset = 'assets/4276414.jpg';
}

/// Layered hero + floating sheet: illustration stays visible at the top; the white
/// panel overlaps it and carries all content. Soft shadow only (no heavy Material elevation).
///
/// [body] fills the sheet — typically a [Column] with a header and an [Expanded] child.
class TmAuthHeroShell extends StatelessWidget {
  const TmAuthHeroShell({
    super.key,
    required this.body,
    this.bottom,
    /// Fraction of safe viewport height where the **sheet** starts (lower = more overlap).
    this.sheetTopFraction = 0.17,
    /// Extra height painted for the hero so it remains visible **behind** the sheet edge.
    this.heroExtendUnderSheet = 56,
    this.heroAssetPath = TmAuthTokens.heroAsset,
    this.cardColor,
  });

  final Widget body;
  final Widget? bottom;
  final double sheetTopFraction;
  final double heroExtendUnderSheet;
  final String heroAssetPath;
  final Color? cardColor;

  static List<BoxShadow> get _cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 28,
          offset: const Offset(0, 12),
          spreadRadius: -8,
        ),
        BoxShadow(
          color: TmAuthTokens.primaryGreen.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 6),
          spreadRadius: -6,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardFill = cardColor ??
        (isDark
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Colors.white);
    final screenFill =
        isDark ? Theme.of(context).colorScheme.surface : TmAuthTokens.screenBg;

    return Scaffold(
      backgroundColor: screenFill,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final sheetTop = (h * sheetTopFraction).clamp(56.0, 140.0);
            final heroPaintH = sheetTop + heroExtendUnderSheet;
            const horizontalPad = 13.0;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: heroPaintH,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          heroAssetPath,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.42),
                          errorBuilder: (context, error, stackTrace) => ColoredBox(
                            color: TmAuthTokens.softGreen,
                            child: Center(
                              child: Icon(
                                Icons.eco_rounded,
                                size: 52,
                                color: TmAuthTokens.primaryGreen.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                TmAuthTokens.softGreen.withValues(alpha: isDark ? 0.1 : 0.2),
                                screenFill.withValues(alpha: 0.0),
                                screenFill.withValues(alpha: 0.55),
                                screenFill.withValues(alpha: 0.92),
                              ],
                              stops: const [0.0, 0.35, 0.72, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: horizontalPad,
                  right: horizontalPad,
                  top: sheetTop,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                      boxShadow: _cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: body),
                          if (bottom != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                TmAuthLayout.hPad,
                                0,
                                TmAuthLayout.hPad,
                                TmAuthLayout.bottomPad,
                              ),
                              child: bottom!,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
