import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/welcome_wave_clipper.dart';

const Color kAuthFormBlue = Color(0xFF1E88E5);
const Color kAuthHeaderBlue = Color(0xFF1E88E5);
const Color kAuthHeaderBlueDark = Color(0xFF1565C0);
const Color kAuthBrandBlue = Color(0xFF2E66E7);
const Color kAuthHint = Color(0xFF64748B);
const Color kAuthUnderline = Color(0xFFB3D4F5);
const Color kAuthScreenBg = Color(0xFFEFF4FA);

const String kAuthBadgeAsset = 'imagesss/graduate_icoin_-removebg-preview.png';

/// Login / register shell matching home & welcome (gradient header + wave panel).
class AuthScreenShell extends StatelessWidget {
  const AuthScreenShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.scrollable = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardBottom > 0;
    final headerHeight = isKeyboardOpen ? (size.height * 0.20) : (size.height * 0.36);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        height: headerHeight,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [kAuthHeaderBlue, kAuthHeaderBlueDark],
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              left: -30,
                              child: _DecorCircle(size: 90, opacity: 0.14),
                            ),
                            Positioned(
                              top: 40,
                              right: -24,
                              child: _DecorCircle(size: 64, opacity: 0.12),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!isKeyboardOpen) ...[
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.12),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          kAuthBadgeAsset,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      const AuthBrandBanner(),
                                      const SizedBox(height: 10),
                                    ] else ...[
                                      const SizedBox(height: 16),
                                    ],
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: isKeyboardOpen ? 18 : 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (!isKeyboardOpen) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        subtitle,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withValues(alpha: 0.88),
                                          fontSize: 13,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              top: -20,
                              child: ClipPath(
                                clipper: WelcomeWaveClipper(),
                                child: const ColoredBox(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 12),
                              child: child,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthBrandBanner extends StatelessWidget {
  const AuthBrandBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthRainbowLine(width: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'ID-SHAYDI',
              style: GoogleFonts.poppins(
                color: kAuthBrandBlue,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const AuthRainbowLine(width: 36),
        ],
      ),
    );
  }
}

class AuthRainbowLine extends StatelessWidget {
  const AuthRainbowLine({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEF4444),
              Color(0xFFF97316),
              Color(0xFFEAB308),
              Color(0xFF22C55E),
              Color(0xFF3B82F6),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthSectionHeader extends StatelessWidget {
  const AuthSectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Expanded(child: AuthRainbowLine()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: kAuthFormBlue,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const Expanded(child: AuthRainbowLine()),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
