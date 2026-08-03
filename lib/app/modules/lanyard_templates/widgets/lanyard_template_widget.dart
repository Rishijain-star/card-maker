import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../design_system/lanyard_dimensions.dart';

/// Full-width Horizontal Lanyard Ribbon Strip featuring asset images & custom procedural designs,
/// circular logo filling, repeating form text, and subtle section background artwork.
class LanyardTemplateWidget extends StatelessWidget {
  const LanyardTemplateWidget({
    super.key,
    required this.data,
    required this.variant,
  });

  final LanyardData data;
  final int variant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LanyardDimensions.designWidth,
      height: LanyardDimensions.designHeight,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: Asset Image (variants 0-5) or Procedural Custom Artwork (variants 6-15)
            if (variant >= 6)
              CustomPaint(
                painter: _RibbonStripePainter(
                  variant: variant,
                  repeatCount: data.repeatCount,
                ),
              )
            else
              Image.asset(
                _assetForVariant(variant),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),

            // Horizontal repeating Logo + Lanyard Text translated by custom position offset
            Transform.translate(
              offset: Offset(data.offsetX, data.offsetY),
              child: _HorizontalRibbonContent(
                data: data,
                variant: variant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _assetForVariant(int variant) {
    switch (variant) {
      case 1:
        return 'assets/lanyard/blue+red.png';
      case 2:
        return 'assets/lanyard/green.png';
      case 3:
        return 'assets/lanyard/green+black.png';
      case 4:
        return 'assets/lanyard/red.png';
      case 5:
        return 'assets/lanyard/white+blue.png';
      default:
        return 'assets/lanyard/blue.png';
    }
  }
}

class _RibbonStripePainter extends CustomPainter {
  const _RibbonStripePainter({
    required this.variant,
    this.repeatCount = 3,
  });

  final int variant;
  final int repeatCount;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final count = repeatCount.clamp(2, 6);
    final slotWidth = size.width / count;

    if (variant == 6) {
      // 1. Gold & Dark Premium Ribbon with Diamond Lattice Artwork
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF0B0F19), Color(0xFF1E293B), Color(0xFF0F172A)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final artPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final slotCenter = slotLeft + slotWidth / 2;

        final artPath = Path();
        for (double r = 10; r <= 32; r += 8) {
          artPath
            ..moveTo(slotCenter, size.height / 2 - r)
            ..lineTo(slotCenter + r * 2.2, size.height / 2)
            ..lineTo(slotCenter, size.height / 2 + r)
            ..lineTo(slotCenter - r * 2.2, size.height / 2)
            ..close();
        }
        canvas.drawPath(artPath, artPaint);
      }

      final goldPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;

      final goldDarkPaint = Paint()
        ..color = const Color(0xFFB8860B).withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      const stripeWidth = 10.0;
      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;

        final path1 = Path()
          ..moveTo(x - 8, 0)
          ..lineTo(x - 8 + stripeWidth, 0)
          ..lineTo(x - 8 + stripeWidth - size.height * 0.4, size.height)
          ..lineTo(x - 8 - size.height * 0.4, size.height)
          ..close();
        canvas.drawPath(path1, goldPaint);

        final path2 = Path()
          ..moveTo(x + 6, 0)
          ..lineTo(x + 6 + stripeWidth * 0.7, 0)
          ..lineTo(x + 6 + stripeWidth * 0.7 - size.height * 0.4, size.height)
          ..lineTo(x + 6 - size.height * 0.4, size.height)
          ..close();
        canvas.drawPath(path2, goldDarkPaint);
      }
    } else if (variant == 7 || variant == 8) {
      // 2. Cyber Wave / Royal Purple Wave Artwork
      final bgGradient = variant == 8
          ? const LinearGradient(
              colors: [Color(0xFF3B0764), Color(0xFF6D28D9), Color(0xFF1E1B4B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
          : const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF00E5FF), Color(0xFF0369A1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            );

      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final wavePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;

        final wavePath = Path();
        for (double dy = -8; dy <= size.height + 8; dy += 10) {
          wavePath.moveTo(slotLeft, dy);
          wavePath.cubicTo(
            slotLeft + slotWidth * 0.25,
            dy + 6,
            slotLeft + slotWidth * 0.75,
            dy - 6,
            slotLeft + slotWidth,
            dy,
          );
        }
        canvas.drawPath(wavePath, wavePaint);
      }

      final whitePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;

      final darkPaint = Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      const stripeWidth = 10.0;
      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;

        final path1 = Path()
          ..moveTo(x - 6, 0)
          ..lineTo(x - 6 + stripeWidth, 0)
          ..lineTo(x - 6 + stripeWidth - size.height * 0.4, size.height)
          ..lineTo(x - 6 - size.height * 0.4, size.height)
          ..close();
        canvas.drawPath(path1, whitePaint);

        final path2 = Path()
          ..moveTo(x + 8, 0)
          ..lineTo(x + 8 + stripeWidth * 0.7, 0)
          ..lineTo(x + 8 + stripeWidth * 0.7 - size.height * 0.4, size.height)
          ..lineTo(x + 8 - size.height * 0.4, size.height)
          ..close();
        canvas.drawPath(path2, darkPaint);
      }
    } else if (variant == 9) {
      // 3. Luxury Black Gold Velvet
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF090A0F), Color(0xFF171923), Color(0xFF0D0E15)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final artPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final slotCenter = slotLeft + slotWidth / 2;

        final artPath = Path();
        for (double r = 8; r <= 36; r += 7) {
          artPath.addOval(Rect.fromCircle(center: Offset(slotCenter, size.height / 2), radius: r));
        }
        canvas.drawPath(artPath, artPaint);
      }

      final goldPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;

      const stripeWidth = 12.0;
      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;
        final path1 = Path()
          ..moveTo(x - 8, 0)
          ..lineTo(x - 8 + stripeWidth, 0)
          ..lineTo(x - 8 + stripeWidth - size.height * 0.45, size.height)
          ..lineTo(x - 8 - size.height * 0.45, size.height)
          ..close();
        canvas.drawPath(path1, goldPaint);
      }
    } else if (variant == 10) {
      // 4. Emerald & Platinum Executive
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF022C22)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final artPaint = Paint()
        ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final wavePath = Path();
        for (double dy = -10; dy <= size.height + 10; dy += 8) {
          wavePath.moveTo(slotLeft, dy);
          wavePath.quadraticBezierTo(slotLeft + slotWidth / 2, dy + 8, slotLeft + slotWidth, dy);
        }
        canvas.drawPath(wavePath, artPaint);
      }

      final silverPaint = Paint()
        ..color = const Color(0xFFF8FAFC).withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;

      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;
        final path1 = Path()
          ..moveTo(x - 6, 0)
          ..lineTo(x + 4, 0)
          ..lineTo(x + 4 - size.height * 0.45, size.height)
          ..lineTo(x - 6 - size.height * 0.45, size.height)
          ..close();
        canvas.drawPath(path1, silverPaint);
      }
    } else if (variant == 11) {
      // 5. Rose Gold & Ruby Luxury
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF881337), Color(0xFFBE123C), Color(0xFF4C0519)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final artPaint = Paint()
        ..color = const Color(0xFFFDA4AF).withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final slotCenter = slotLeft + slotWidth / 2;
        final artPath = Path()
          ..moveTo(slotCenter - 40, size.height / 2)
          ..lineTo(slotCenter, size.height / 2 - 14)
          ..lineTo(slotCenter + 40, size.height / 2)
          ..lineTo(slotCenter, size.height / 2 + 14)
          ..close();
        canvas.drawPath(artPath, artPaint);
      }

      final roseGoldPaint = Paint()
        ..color = const Color(0xFFFECDD3).withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;

      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;
        final path1 = Path()
          ..moveTo(x - 6, 0)
          ..lineTo(x + 5, 0)
          ..lineTo(x + 5 - size.height * 0.45, size.height)
          ..lineTo(x - 6 - size.height * 0.45, size.height)
          ..close();
        canvas.drawPath(path1, roseGoldPaint);
      }
    } else if (variant == 12) {
      // 6. Yellow & Fire Geometric Sport Lanyard
      final yellowPaint = Paint()..color = const Color(0xFFFACC15);
      canvas.drawRect(rect, yellowPaint);

      final dotPaint = Paint()..color = Colors.black.withValues(alpha: 0.09);
      for (double dx = 6; dx < size.width; dx += 14) {
        for (double dy = 6; dy < size.height; dy += 10) {
          canvas.drawCircle(Offset(dx, dy), 1.8, dotPaint);
        }
      }

      final orangePaint = Paint()
        ..color = const Color(0xFFF97316)
        ..style = PaintingStyle.fill;
      final redPaint = Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.fill;
      final navyPaint = Paint()
        ..color = const Color(0xFF1E3A8A)
        ..style = PaintingStyle.fill;

      for (int i = 1; i < count; i++) {
        final x = i * slotWidth;

        final pathOrange = Path()
          ..moveTo(x - 24, 0)
          ..lineTo(x + 12, 0)
          ..lineTo(x - 4, size.height)
          ..lineTo(x - 40, size.height)
          ..close();
        canvas.drawPath(pathOrange, orangePaint);

        final pathRed = Path()
          ..moveTo(x - 10, 0)
          ..lineTo(x + 6, 0)
          ..lineTo(x - 10, size.height)
          ..lineTo(x - 26, size.height)
          ..close();
        canvas.drawPath(pathRed, redPaint);

        final pathNavy = Path()
          ..moveTo(x + 12, 0)
          ..lineTo(x + 22, 0)
          ..lineTo(x + 6, size.height)
          ..lineTo(x - 4, size.height)
          ..close();
        canvas.drawPath(pathNavy, navyPaint);
      }
    } else if (variant == 13) {
      // 7. Coral & Magenta Curved Diamond Lattice Artwork
      final bgGradient = const LinearGradient(
        colors: [
          Color(0xFFBE123C),
          Color(0xFFE11D48),
          Color(0xFFF43F5E),
          Color(0xFFFB923C),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));

      final latticePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2;

      final innerGlowPaint = Paint()
        ..color = const Color(0xFFFFE4E6).withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;

      const spacing = 70.0;
      final centerY = size.height / 2;

      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final path = Path()
          ..moveTo(x, centerY - 26)
          ..quadraticBezierTo(x + 18, centerY - 6, x + 35, centerY)
          ..quadraticBezierTo(x + 18, centerY + 6, x, centerY + 26)
          ..quadraticBezierTo(x - 18, centerY + 6, x - 35, centerY)
          ..quadraticBezierTo(x - 18, centerY - 6, x, centerY - 26)
          ..close();

        canvas.drawPath(path, innerGlowPaint);
        canvas.drawPath(path, latticePaint);

        final archPath = Path()
          ..moveTo(x - 35, 0)
          ..quadraticBezierTo(x, centerY * 0.7, x + 35, 0)
          ..moveTo(x - 35, size.height)
          ..quadraticBezierTo(x, size.height - centerY * 0.7, x + 35, size.height);

        canvas.drawPath(archPath, latticePaint..strokeWidth = 1.6);
      }
    } else if (variant == 14) {
      // 8. Red & Black Slash Divider Sport Lanyard (Exact User Reference Image Artwork)
      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final halfWidth = slotWidth / 2;

        // 1. Black Block Section with subtle carbon dot grid texture
        final blackRect = Rect.fromLTWH(slotLeft, 0, halfWidth, size.height);
        canvas.drawRect(blackRect, Paint()..color = const Color(0xFF090A0F));

        final carbonDotPaint = Paint()..color = Colors.white.withValues(alpha: 0.05);
        for (double dx = slotLeft + 4; dx < slotLeft + halfWidth - 10; dx += 10) {
          for (double dy = 4; dy < size.height; dy += 8) {
            canvas.drawCircle(Offset(dx, dy), 1.2, carbonDotPaint);
          }
        }

        // 2. Red Block Section
        final redRect = Rect.fromLTWH(slotLeft + halfWidth, 0, halfWidth, size.height);
        canvas.drawRect(redRect, Paint()..color = const Color(0xFFDC2626));

        // 3. Exact Artwork Slashes & Sharp Whisker Spikes near Black Area (as per Reference Screenshot)
        final edgeX = slotLeft + halfWidth;
        final slashOffset = size.height * 0.50;

        final redPaint = Paint()..color = const Color(0xFFEF4444);
        final darkRedPaint = Paint()..color = const Color(0xFF991B1B);

        // A. Main Bold Red Slash Band
        final mainSlash = Path()
          ..moveTo(edgeX - 18, 0)
          ..lineTo(edgeX - 5, 0)
          ..lineTo(edgeX - 5 - slashOffset, size.height)
          ..lineTo(edgeX - 18 - slashOffset, size.height)
          ..close();
        canvas.drawPath(mainSlash, redPaint);

        // B. Sharp Secondary Whisker Spike 1 (Long razor spike near main slash)
        final spike1 = Path()
          ..moveTo(edgeX - 28, size.height)
          ..lineTo(edgeX - 22, size.height)
          ..lineTo(edgeX - 14, size.height * 0.25)
          ..close();
        canvas.drawPath(spike1, redPaint);

        // C. Sharp Secondary Whisker Spike 2 (Shorter razor spike)
        final spike2 = Path()
          ..moveTo(edgeX - 38, size.height)
          ..lineTo(edgeX - 33, size.height)
          ..lineTo(edgeX - 27, size.height * 0.55)
          ..close();
        canvas.drawPath(spike2, darkRedPaint);

        // D. Top Edge Downward Red Counter-Spike (pointed down at top right of black area)
        final topSpike = Path()
          ..moveTo(edgeX - 34, 0)
          ..lineTo(edgeX - 26, 0)
          ..lineTo(edgeX - 22, size.height * 0.40)
          ..close();
        canvas.drawPath(topSpike, redPaint);

        // E. Accent Red Slash inside Red area
        final innerSlash = Path()
          ..moveTo(edgeX + 14, 0)
          ..lineTo(edgeX + 22, 0)
          ..lineTo(edgeX + 22 - slashOffset, size.height)
          ..lineTo(edgeX + 14 - slashOffset, size.height)
          ..close();
        canvas.drawPath(innerSlash, darkRedPaint);
      }

      final borderPaint = Paint()..color = const Color(0xFF090A0F);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2), borderPaint);
      canvas.drawRect(Rect.fromLTWH(0, size.height - 2, size.width, 2), borderPaint);
    } else if (variant == 15) {
      // 9. Navy & Pink Wide Block Lanyard
      for (int i = 0; i < count; i++) {
        final slotLeft = i * slotWidth;
        final pinkWidth = slotWidth * 0.26;
        final navyWidth = slotWidth * 0.74;

        final pinkRect = Rect.fromLTWH(slotLeft, 0, pinkWidth, size.height);
        final pinkGradient = const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFF43F5E), Color(0xFFBE123C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        canvas.drawRect(pinkRect, Paint()..shader = pinkGradient.createShader(pinkRect));

        canvas.drawRect(
          Rect.fromLTWH(slotLeft + pinkWidth - 3, 0, 3, size.height),
          Paint()..color = const Color(0xFFFDA4AF),
        );

        final navyRect = Rect.fromLTWH(slotLeft + pinkWidth, 0, navyWidth, size.height);
        final navyGradient = const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF0F172A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        canvas.drawRect(navyRect, Paint()..shader = navyGradient.createShader(navyRect));
      }

      final borderPaint = Paint()..color = const Color(0xFF0F172A);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 1.5), borderPaint);
      canvas.drawRect(Rect.fromLTWH(0, size.height - 1.5, size.width, 1.5), borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RibbonStripePainter oldDelegate) =>
      oldDelegate.variant != variant || oldDelegate.repeatCount != repeatCount;
}

class _CircularLogoWidget extends StatelessWidget {
  const _CircularLogoWidget({
    required this.logoPath,
    this.variant = 0,
    this.size = 32.0,
  });

  final String logoPath;
  final int variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isFile = logoPath.isNotEmpty && File(logoPath).existsSync();
    final isAsset = logoPath.isNotEmpty &&
        (logoPath.startsWith('assets/') || logoPath.startsWith('imagesss/'));

    final borderColor = variant == 15
        ? const Color(0xFF38BDF8)
        : (variant == 14
            ? const Color(0xFFDC2626)
            : (variant == 13
                ? const Color(0xFFFFE4E6)
                : (variant == 12
                    ? const Color(0xFFEF4444)
                    : (variant == 6 || variant == 9
                        ? const Color(0xFFFFD700)
                        : (variant == 10
                            ? const Color(0xFFF8FAFC)
                            : (variant == 11
                                ? const Color(0xFFFECDD3)
                                : (variant == 7 || variant == 8
                                    ? const Color(0xFF00E5FF)
                                    : (variant == 1
                                        ? const Color(0xFF00E5FF)
                                        : (variant == 3 ? const Color(0xFFFFD700) : Colors.white)))))))));

    Widget content;
    if (isFile) {
      content = Image.file(
        File(logoPath),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (isAsset) {
      content = Image.asset(
        logoPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else {
      content = Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Icon(
          Icons.verified_rounded,
          color: variant == 15
              ? const Color(0xFF0284C7)
              : (variant == 14
                  ? const Color(0xFFDC2626)
                  : (variant == 13
                      ? const Color(0xFFE11D48)
                      : (variant == 12
                          ? const Color(0xFFEF4444)
                          : (variant == 6 || variant == 9
                              ? const Color(0xFFD97706)
                              : (variant == 10
                                  ? const Color(0xFF047857)
                                  : (variant == 11
                                      ? const Color(0xFFBE123C)
                                      : (variant == 8 ? const Color(0xFF7C3AED) : const Color(0xFF0284C7)))))))),
          size: size * 0.55,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(child: content),
    );
  }
}

class _HorizontalRibbonContent extends StatelessWidget {
  const _HorizontalRibbonContent({
    required this.data,
    required this.variant,
  });

  final LanyardData data;
  final int variant;

  TextStyle _textStyle() {
    Color textColor;
    if (data.textColorHex != null) {
      textColor = Color(data.textColorHex!);
    } else {
      switch (variant) {
        case 15:
        case 14:
        case 13:
          textColor = Colors.white;
          break;
        case 12:
          textColor = const Color(0xFF0F172A);
          break;
        case 6:
        case 9:
          textColor = const Color(0xFFFFD700);
          break;
        case 10:
          textColor = const Color(0xFFF8FAFC);
          break;
        case 11:
          textColor = const Color(0xFFFECDD3);
          break;
        case 7:
        case 8:
          textColor = Colors.white;
          break;
        case 5:
          textColor = const Color(0xFF0F172A);
          break;
        case 3:
          textColor = const Color(0xFFFFD700);
          break;
        default:
          textColor = Colors.white;
          break;
      }
    }

    return IdCardTypography.apply(
      TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 0.8,
        height: 1.0,
        shadows: const [
          Shadow(
            color: Colors.black87,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      data.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textOnLanyard =
        data.organization.isNotEmpty ? data.organization : 'ID-SHAYDI';

    final textStyle = _textStyle();

    final count = data.repeatCount.clamp(2, 6);

    if (variant == 15) {
      final slotWidth = LanyardDimensions.designWidth / count;
      return Row(
        children: List.generate(
          count,
          (index) => SizedBox(
            width: slotWidth,
            child: Row(
              children: [
                SizedBox(width: slotWidth * 0.28),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircularLogoWidget(
                        logoPath: data.logoPath,
                        variant: variant,
                        size: count > 3 ? 26 : 30,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          textOnLanyard.toUpperCase(),
                          style: textStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: count > 3 ? 16 : 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircularLogoWidget(
                logoPath: data.logoPath,
                variant: variant,
                size: count > 3 ? 28 : 32,
              ),
              const SizedBox(width: 6),
              Text(
                textOnLanyard.toUpperCase(),
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
