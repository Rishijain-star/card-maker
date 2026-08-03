import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../widgets/lanyard_template_widget.dart';

/// Photorealistic Curved Lanyard Ribbon Neck Mockup.
/// Paints a continuous curved bezier ribbon strap where live form text & logos
/// bend and follow the exact curvature of the ribbon around the neck.
class LanyardNeckMockupWidget extends StatelessWidget {
  const LanyardNeckMockupWidget({
    super.key,
    required this.data,
    required this.variant,
  });

  final LanyardData data;
  final int variant;

  @override
  Widget build(BuildContext context) {
    final textOnLanyard =
        data.organization.isNotEmpty ? data.organization : 'ID-SHAYDI';

    return Center(
      child: Container(
        width: 320,
        height: 420,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Photorealistic Curved Ribbon Canvas (Text & Logo Bend Along Curve)
            SizedBox(
              width: 320,
              height: 340,
              child: CustomPaint(
                painter: _CurvedNeckLanyardPainter(
                  data: data,
                  variant: variant,
                  textOnLanyard: textOnLanyard,
                ),
              ),
            ),

            // Black Plastic Buckle Clip (Positioned at bottom junction of curved ribbon)
            const Positioned(
              top: 275,
              child: _BlackBuckleClipWidget(),
            ),

            // Lower Extension Ribbon Strap
            Positioned(
              top: 318,
              child: Container(
                width: 34,
                height: 46,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: LanyardTemplateWidget(data: data, variant: variant),
              ),
            ),

            // Steel D-Ring Keyring Hook
            const Positioned(
              top: 362,
              child: _SteelDRingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvedNeckLanyardPainter extends CustomPainter {
  _CurvedNeckLanyardPainter({
    required this.data,
    required this.variant,
    required this.textOnLanyard,
  });

  final LanyardData data;
  final int variant;
  final String textOnLanyard;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Smooth Curved Bezier Path for Left Strap
    final leftPath = Path()
      ..moveTo(size.width * 0.32, 28)
      ..cubicTo(
        size.width * 0.16, size.height * 0.32,
        size.width * 0.24, size.height * 0.68,
        size.width * 0.47, size.height * 0.84,
      );

    // 2. Smooth Curved Bezier Path for Right Strap
    final rightPath = Path()
      ..moveTo(size.width * 0.68, 28)
      ..cubicTo(
        size.width * 0.84, size.height * 0.32,
        size.width * 0.76, size.height * 0.68,
        size.width * 0.53, size.height * 0.84,
      );

    // 3. Smooth Top Neck Curve Arc
    final topNeckPath = Path()
      ..moveTo(size.width * 0.32, 28)
      ..cubicTo(
        size.width * 0.38, 12,
        size.width * 0.62, 12,
        size.width * 0.68, 28,
      );

    // Ribbon Base Paint (Width 36px)
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 39.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.black.withValues(alpha: 0.25);

    // Draw Shadow First
    canvas.drawPath(topNeckPath, shadowPaint);
    canvas.drawPath(leftPath, shadowPaint);
    canvas.drawPath(rightPath, shadowPaint);

    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35.0
      ..strokeCap = StrokeCap.round
      ..shader = _getVariantShader(variant, rect);

    // Draw Smooth Curved Ribbon Fabric Body
    canvas.drawPath(topNeckPath, ribbonPaint);
    canvas.drawPath(leftPath, ribbonPaint);
    canvas.drawPath(rightPath, ribbonPaint);

    // Draw Subtle White Edge Stitching Lines
    final stitchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.35);

    canvas.drawPath(topNeckPath, stitchPaint);
    canvas.drawPath(leftPath, stitchPaint);
    canvas.drawPath(rightPath, stitchPaint);

    // 4. Render Letter-by-Letter Bending Text & Logo along Curve
    _drawCurvedContent(canvas, leftPath, isLeft: true);
    _drawCurvedContent(canvas, rightPath, isLeft: false);
  }

  Shader _getVariantShader(int variant, Rect rect) {
    switch (variant) {
      case 12: // Yellow Fire Sport
        return const LinearGradient(
          colors: [Color(0xFFFACC15), Color(0xFFF97316), Color(0xFFEF4444)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      case 6: // Gold & Diamond
      case 9: // Black Gold Velvet
        return const LinearGradient(
          colors: [Color(0xFF090A0F), Color(0xFF1E293B), Color(0xFF0D0E15)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      case 10: // Emerald Platinum
        return const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF022C22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      case 11: // Rose Gold Ruby
        return const LinearGradient(
          colors: [Color(0xFF881337), Color(0xFFBE123C), Color(0xFF4C0519)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      case 7: // Cyber Wave
        return const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF00E5FF), Color(0xFF0369A1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      case 8: // Royal Purple
        return const LinearGradient(
          colors: [Color(0xFF3B0764), Color(0xFF6D28D9), Color(0xFF1E1B4B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
      default:
        return const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect);
    }
  }

  Color _getTextColor(int variant, int? customHex) {
    if (customHex != null) return Color(customHex);
    switch (variant) {
      case 12:
        return const Color(0xFF0F172A);
      case 6:
      case 9:
        return const Color(0xFFFFD700);
      case 10:
        return const Color(0xFFF8FAFC);
      case 11:
        return const Color(0xFFFECDD3);
      default:
        return Colors.white;
    }
  }

  Color _getBorderColor(int variant) {
    switch (variant) {
      case 12:
        return const Color(0xFFEF4444);
      case 6:
      case 9:
        return const Color(0xFFFFD700);
      case 10:
        return const Color(0xFFF8FAFC);
      case 11:
        return const Color(0xFFFECDD3);
      default:
        return Colors.white;
    }
  }

  void _drawCurvedContent(Canvas canvas, Path path, {required bool isLeft}) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final pathLength = metric.length;

    final textToDraw = textOnLanyard.toUpperCase();

    final textStyle = IdCardTypography.apply(
      TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: _getTextColor(variant, data.textColorHex),
        letterSpacing: 0.8,
        shadows: const [
          Shadow(color: Colors.black87, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      data.fontFamily,
    );

    // 1. Draw Circular Logo along Curve (at 22% distance)
    final logoDist = pathLength * 0.22;
    final logoTangent = metric.getTangentForOffset(logoDist);
    if (logoTangent != null) {
      canvas.save();
      canvas.translate(logoTangent.position.dx, logoTangent.position.dy);

      final isFile = data.logoPath.isNotEmpty && File(data.logoPath).existsSync();

      // White Logo Circle
      final logoRingPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset.zero, 11, logoRingPaint);

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = _getBorderColor(variant);
      canvas.drawCircle(Offset.zero, 11, borderPaint);

      if (!isFile) {
        final iconPainter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(Icons.verified_rounded.codePoint),
            style: TextStyle(
              fontSize: 13,
              fontFamily: Icons.verified_rounded.fontFamily,
              color: const Color(0xFF0284C7),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        iconPainter.layout();
        iconPainter.paint(canvas, Offset(-iconPainter.width / 2, -iconPainter.height / 2));
      }

      canvas.restore();
    }

    // 2. Draw Bending Characters along PathMetric (from 38% to 85% distance)
    final startDist = pathLength * 0.38;
    final endDist = pathLength * 0.85;
    final availableDist = endDist - startDist;

    final letterSpacing = availableDist / (textToDraw.length + 1);
    double currentDist = startDist;

    for (int i = 0; i < textToDraw.length; i++) {
      final char = textToDraw[i];
      currentDist += letterSpacing;
      if (currentDist > pathLength) break;

      final tangent = metric.getTangentForOffset(currentDist);
      if (tangent == null) continue;

      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);

      // Rotate text to align with curve tangent direction
      final angle = tangent.angle + (isLeft ? 1.57 : -1.57);
      canvas.rotate(angle);

      final tp = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedNeckLanyardPainter oldDelegate) =>
      oldDelegate.variant != variant ||
      oldDelegate.textOnLanyard != textOnLanyard ||
      oldDelegate.data.textColorHex != data.textColorHex ||
      oldDelegate.data.fontFamily != data.fontFamily;
}

class _BlackBuckleClipWidget extends StatelessWidget {
  const _BlackBuckleClipWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 48,
      child: CustomPaint(
        painter: _BlackBucklePainter(),
      ),
    );
  }
}

class _BlackBucklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF334155), Color(0xFF0F172A), Color(0xFF1E293B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, 22),
      const Radius.circular(6),
    );
    canvas.drawRRect(topRect, fillPaint);
    canvas.drawRRect(topRect, borderPaint);

    final slotPaint = Paint()..color = const Color(0xFF020617);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, size.width - 16, 10),
        const Radius.circular(3),
      ),
      slotPaint,
    );

    final bottomRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 24, size.width - 8, 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(bottomRect, fillPaint);
    canvas.drawRRect(bottomRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SteelDRingWidget extends StatelessWidget {
  const _SteelDRingWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 26,
      child: CustomPaint(
        painter: _SteelDRingPainter(),
      ),
    );
  }
}

class _SteelDRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE2E8F0), Color(0xFF64748B), Color(0xFFFFFFFF), Color(0xFF334155)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final dPath = Path()
      ..moveTo(5, 3)
      ..lineTo(size.width - 5, 3)
      ..lineTo(size.width - 5, 10)
      ..arcToPoint(
        Offset(5, 10),
        radius: const Radius.circular(13),
        clockwise: true,
      )
      ..close();

    canvas.drawPath(dPath, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
