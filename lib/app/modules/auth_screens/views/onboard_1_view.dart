import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/widgets/tripmates/tm_components.dart';
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

/// First onboarding step — verified rides story with safety Lottie (Lexend + Inter).
class Onboard1View extends StatelessWidget {
  const Onboard1View({super.key});

  static const int _pageCount = 3;
  static const int _activeIndex = 0;

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
            final hPad = 24.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
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
                            child: _Onboard1HeroCard(isDark: isDark),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Onboard1Headline(darkColor: darkHead),
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
                            color: TripMatesColors.green.withValues(alpha: 0.35),
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
                      'Travel confidently with verified drivers, trusted passengers, '
                      'and smarter shared journeys.',
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
                              : scheme.outline.withValues(alpha: isDark ? 0.32 : 0.38),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: i == _activeIndex
                              ? [
                                  BoxShadow(
                                    color: TripMatesColors.green.withValues(alpha: 0.28),
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
                  _Onboard1ContinueButton(
                    onPressed: () => Get.toNamed<void>(Routes.ONBOARD_2),
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

class _Onboard1HeroCard extends StatelessWidget {
  const _Onboard1HeroCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    /// No inner gradient / shadow / rounded clip — avoids a second “card” look.
    /// Transparent pixels show the same screen gradient behind this widget.
    final lottie = Lottie.asset(
      'assets/lottie/Car safety edit.json',
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

class _Onboard1Headline extends StatelessWidget {
  const _Onboard1Headline({required this.darkColor});

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
            text: 'Safe & ',
            style: base.copyWith(color: darkColor),
          ),
          TextSpan(
            text: 'Verified',
            style: base.copyWith(
              color: TripMatesColors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' Rides',
            style: base.copyWith(color: darkColor),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Onboard1ContinueButton extends StatelessWidget {
  const _Onboard1ContinueButton({required this.onPressed});

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
                      'Continue',
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

class OnboardFrame extends StatelessWidget {
  const OnboardFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.buttonText,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int active;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      TripMatesColors.green.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 72),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: TmGlossCard(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
                    child: Column(
                      children: [
                        Container(
                          width: 154,
                          height: 154,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(42),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TripMatesColors.white.withValues(alpha: 0.98),
                                TripMatesColors.chipSuccess,
                                TripMatesColors.white.withValues(alpha: 0.88),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                            boxShadow: TripMatesColors.glossyCardShadow,
                          ),
                          child: Icon(
                            icon,
                            size: 82,
                            color: TripMatesColors.green,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _PremiumOnboardTitle(title: title),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : TripMatesColors.text3,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: i == active ? 28 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: i == active
                            ? const LinearGradient(
                                colors: [
                                  TripMatesColors.greenLight,
                                  TripMatesColors.green,
                                ],
                              )
                            : null,
                        color: i == active
                            ? null
                            : scheme.outline.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  child: TmPrimaryButton(label: buttonText, onPressed: onTap),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumOnboardTitle extends StatelessWidget {
  const _PremiumOnboardTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final words = title.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }
    final lead = words.sublist(0, words.length - 1).join(' ');
    final last = words.last;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$lead ',
            style: GoogleFonts.poppins(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.05,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  TripMatesColors.greenLight,
                  TripMatesColors.green,
                ],
              ).createShader(bounds),
              child: Text(
                last,
                style: GoogleFonts.poppins(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
