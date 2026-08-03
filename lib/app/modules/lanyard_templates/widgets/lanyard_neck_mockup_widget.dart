import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../widgets/lanyard_template_widget.dart';

/// Pure U-Shaped Lanyard Ribbon Neck Hang Preview.
/// Displays how the actual ribbon loops around the neck in a U-shape,
/// joining at a silver ring/clip at the bottom, without any card.
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
        height: 380,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Top U-Shape Neck Arc Ribbon connecting left and right straps
            Positioned(
              top: 10,
              child: SizedBox(
                width: 220,
                height: 90,
                child: CustomPaint(
                  painter: _UNeckArcPainter(
                    variant: variant,
                  ),
                ),
              ),
            ),

            // Left Lanyard Ribbon Strap (Hanging from neck down to bottom clip)
            Positioned(
              left: 55,
              top: 45,
              child: Transform.rotate(
                angle: 0.30,
                child: _RibbonSegmentStrap(
                  data: data,
                  variant: variant,
                  textOnLanyard: textOnLanyard,
                  index: 0,
                ),
              ),
            ),

            // Right Lanyard Ribbon Strap (Hanging from neck down to bottom clip)
            Positioned(
              right: 55,
              top: 45,
              child: Transform.rotate(
                angle: -0.30,
                child: _RibbonSegmentStrap(
                  data: data,
                  variant: variant,
                  textOnLanyard: textOnLanyard,
                  index: 1,
                ),
              ),
            ),

            // Bottom Center Silver Metallic Ring & Clip joining the U-shape
            const Positioned(
              bottom: 15,
              child: _SilverLanyardRingClip(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RibbonSegmentStrap extends StatelessWidget {
  const _RibbonSegmentStrap({
    required this.data,
    required this.variant,
    required this.textOnLanyard,
    required this.index,
  });

  final LanyardData data;
  final int variant;
  final String textOnLanyard;
  final int index;

  TextStyle _textStyle() {
    Color textColor;
    if (data.textColorHex != null) {
      textColor = Color(data.textColorHex!);
    } else {
      switch (variant) {
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
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 0.6,
        height: 1.0,
        shadows: const [
          Shadow(
            color: Colors.black87,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      data.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle();
    final isFile = data.logoPath.isNotEmpty && File(data.logoPath).existsSync();
    final isAsset = data.logoPath.isNotEmpty &&
        (data.logoPath.startsWith('assets/') || data.logoPath.startsWith('imagesss/'));

    return Container(
      width: 44,
      height: 270,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Render Ribbon Background Pattern
          LanyardTemplateWidget(
            data: data,
            variant: variant,
          ),

          // Translucent Ribbon Fabric Texture Overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.22),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Vertical Column displaying [Logo] [Text] along the U-Strap
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Circular Logo
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: variant == 6 || variant == 9
                          ? const Color(0xFFFFD700)
                          : Colors.white,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: isFile
                        ? Image.file(File(data.logoPath), fit: BoxFit.cover)
                        : (isAsset
                            ? Image.asset(data.logoPath, fit: BoxFit.cover)
                            : const Icon(Icons.verified_rounded, color: Color(0xFF0284C7), size: 16)),
                  ),
                ),

                // Vertical Printed Text
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    textOnLanyard.toUpperCase(),
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UNeckArcPainter extends CustomPainter {
  const _UNeckArcPainter({required this.variant});

  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(10, 80)
      ..cubicTo(40, 10, 180, 10, 210, 80);

    final paint = Paint()
      ..color = variant == 6 || variant == 9
          ? const Color(0xFF1E1B4B)
          : (variant == 10
              ? const Color(0xFF022C22)
              : (variant == 11 ? const Color(0xFF4C0519) : const Color(0xFF0F172A)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    // Inner Arc Metallic Stripe
    final stripePaint = Paint()
      ..color = variant == 6 || variant == 9
          ? const Color(0xFFFFD700).withValues(alpha: 0.8)
          : Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(path, stripePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SilverLanyardRingClip extends StatelessWidget {
  const _SilverLanyardRingClip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: CustomPaint(
        painter: _SilverRingPainter(),
      ),
    );
  }
}

class _SilverRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 16);

    // Metallic Outer Ring
    final ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE2E8F0), Color(0xFF64748B), Color(0xFFFFFFFF), Color(0xFF475569)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(center, 13, ringPaint);

    // Metallic Carabiner Hook Clip
    final clipPath = Path()
      ..moveTo(size.width / 2 - 8, 26)
      ..lineTo(size.width / 2 + 8, 26)
      ..lineTo(size.width / 2 + 6, 44)
      ..lineTo(size.width / 2 - 6, 44)
      ..close();

    final clipFill = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF1F5F9), Color(0xFF94A3B8), Color(0xFF475569)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);

    canvas.drawPath(clipPath, clipFill);
    canvas.drawPath(clipPath, ringPaint..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
