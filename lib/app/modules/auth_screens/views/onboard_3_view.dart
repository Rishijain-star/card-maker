import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/const/app_colors.dart';
import '../../../routes/app_pages.dart';

const LinearGradient _kOnboardLightBgGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    TripMatesColors.sky,
    AppColors.backgroundLight,
    TripMatesColors.white,
  ],
  stops: [0.0, 0.35, 1.0],
);

/// Third onboarding — secured trips story with `Secured.json` Lottie.
class Onboard3View extends StatelessWidget {
  const Onboard3View({super.key});

  static const int _pageCount = 3;
  static const int _activeIndex = 2;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final darkHead =
        isDark ? AppColors.darkTextPrimary : TripMatesColors.text2;
    final subtitleColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textMuted;

    final scaffoldBg =
        isDark ? AppColors.darkBackground : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDark ? null : _kOnboardLightBgGradient,
          color: isDark ? scaffoldBg : null,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const hPad = 24.0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Flexible(
                      flex: 3,
                      child: LayoutBuilder(
                        builder: (context, heroConstraints) {
                          final maxW = heroConstraints.maxWidth;
                          final maxH = heroConstraints.maxHeight;
                          final side = math.min(maxW, maxH);
                          return Center(
                            child: SizedBox(
                              width: side,
                              height: side,
                              child: _Onboard3SecuredHero(isDark: isDark),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Onboard3Headline(darkColor: darkHead),
                    const SizedBox(height: 14),
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TripMatesColors.green,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  TripMatesColors.green.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        'Share trips securely, stay connected with loved '
                        'ones, and enjoy safer journeys with built-in safety '
                        'tools.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.62,
                          letterSpacing: 0.05,
                          color: subtitleColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pageCount,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: i == _activeIndex ? 32 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: i == _activeIndex
                                ? const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      TripMatesColors.greenLight,
                                      TripMatesColors.green,
                                    ],
                                  )
                                : null,
                            color: i == _activeIndex
                                ? null
                                : scheme.outline
                                    .withValues(alpha: isDark ? 0.32 : 0.38),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: i == _activeIndex
                                ? [
                                    BoxShadow(
                                      color: TripMatesColors.green
                                          .withValues(alpha: 0.28),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _Onboard3ContinueButton(
                      onPressed: () =>
                          Get.offAllNamed<void>(Routes.WELCOME),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Same hero treatment as onboarding 1 — gradient shows through transparent Lottie.
class _Onboard3SecuredHero extends StatelessWidget {
  const _Onboard3SecuredHero({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final lottie = Lottie.asset(
      'assets/lottie/Secured.json',
      fit: BoxFit.contain,
      alignment: Alignment.center,
      repeat: true,
      filterQuality: FilterQuality.high,
    );

    if (isDark) {
      return Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.darkSurface),
          lottie,
        ],
      );
    }

    return lottie;
  }
}

class _Onboard3Headline extends StatelessWidget {
  const _Onboard3Headline({required this.darkColor});

  final Color darkColor;

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.inter(
      fontSize: 29,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -0.45,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Travel Smarter & ',
            style: base.copyWith(color: darkColor),
          ),
          TextSpan(
            text: 'Safer',
            style: base.copyWith(
              color: TripMatesColors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Onboard3ContinueButton extends StatelessWidget {
  const _Onboard3ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const pillRadius = 28.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(pillRadius),
            boxShadow: [
              BoxShadow(
                color: TripMatesColors.green.withValues(alpha: 0.26),
                blurRadius: 28,
                spreadRadius: -4,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: TripMatesColors.blue.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: TripMatesColors.green,
            borderRadius: BorderRadius.circular(pillRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              splashColor: Colors.white.withValues(alpha: 0.14),
              highlightColor: Colors.white.withValues(alpha: 0.07),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: TripMatesColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: TripMatesColors.white.withValues(alpha: 0.96),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
