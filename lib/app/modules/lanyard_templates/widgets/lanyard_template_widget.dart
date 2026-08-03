import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../design_system/lanyard_dimensions.dart';

/// Full-width Horizontal Lanyard Ribbon Strip featuring asset images & custom procedural designs,
/// circular logo filling, and repeating form text placed across safe areas.
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
            // Background: Asset Image (variants 0-5) or Procedural Custom Painter (variants 6-7)
            if (variant >= 6)
              CustomPaint(
                painter: _RibbonStripePainter(variant: variant),
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
  const _RibbonStripePainter({required this.variant});

  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    if (variant == 6) {
      // Gold & Dark Premium Ribbon Gradient
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF0B0F19), Color(0xFF1E293B), Color(0xFF0F172A)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      final bgPaint = Paint()..shader = bgGradient.createShader(rect);
      canvas.drawRect(rect, bgPaint);

      // Gold diagonal accent stripes
      final stripePaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      final goldDarkPaint = Paint()
        ..color = const Color(0xFFB8860B).withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;

      const stripeWidth = 14.0;
      const spacing = 220.0;

      for (double x = -size.height; x < size.width + size.height; x += spacing) {
        final path1 = Path()
          ..moveTo(x, 0)
          ..lineTo(x + stripeWidth, 0)
          ..lineTo(x + stripeWidth - size.height * 0.5, size.height)
          ..lineTo(x - size.height * 0.5, size.height)
          ..close();
        canvas.drawPath(path1, stripePaint);

        final path2 = Path()
          ..moveTo(x + stripeWidth + 6, 0)
          ..lineTo(x + stripeWidth * 2 + 6, 0)
          ..lineTo(x + stripeWidth * 2 + 6 - size.height * 0.5, size.height)
          ..lineTo(x + stripeWidth + 6 - size.height * 0.5, size.height)
          ..close();
        canvas.drawPath(path2, goldDarkPaint);
      }
    } else if (variant == 7) {
      // Cyber Cyan Mesh Ribbon Gradient
      final bgGradient = const LinearGradient(
        colors: [Color(0xFF0284C7), Color(0xFF00E5FF), Color(0xFF0369A1)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      final bgPaint = Paint()..shader = bgGradient.createShader(rect);
      canvas.drawRect(rect, bgPaint);

      // White/Black diagonal cyber stripes
      final whiteStripe = Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;

      final darkStripe = Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.75)
        ..style = PaintingStyle.fill;

      const spacing = 180.0;
      for (double x = -size.height; x < size.width + size.height; x += spacing) {
        final path1 = Path()
          ..moveTo(x, 0)
          ..lineTo(x + 12, 0)
          ..lineTo(x + 12 - size.height * 0.6, size.height)
          ..lineTo(x - size.height * 0.6, size.height)
          ..close();
        canvas.drawPath(path1, whiteStripe);

        final path2 = Path()
          ..moveTo(x + 16, 0)
          ..lineTo(x + 28, 0)
          ..lineTo(x + 28 - size.height * 0.6, size.height)
          ..lineTo(x + 16 - size.height * 0.6, size.height)
          ..close();
        canvas.drawPath(path2, darkStripe);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RibbonStripePainter oldDelegate) =>
      oldDelegate.variant != variant;
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

    final borderColor = variant == 6
        ? const Color(0xFFFFD700)
        : (variant == 7
            ? const Color(0xFF00E5FF)
            : (variant == 1
                ? const Color(0xFF00E5FF)
                : (variant == 3 ? const Color(0xFFFFD700) : Colors.white)));

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
          color: variant == 6
              ? const Color(0xFFD97706)
              : (variant == 7 ? const Color(0xFF0284C7) : const Color(0xFF0284C7)),
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
        case 6:
          textColor = const Color(0xFFFFD700);
          break;
        case 7:
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
