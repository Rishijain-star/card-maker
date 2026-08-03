import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../widgets/lanyard_template_widget.dart';

/// Full Professional Lanyard Ribbon Mockup matching user reference image.
/// Displays Top Neck Fold, V-Slanted Neck Straps with Live Logo & Text,
/// Black Plastic Side-Release Buckle Clip, and Extension Strap with Steel Ring.
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
        height: 480,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. Top Neck Ribbon Fold Band
            Positioned(
              top: 15,
              child: Container(
                width: 175,
                height: 34,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: LanyardTemplateWidget(data: data, variant: variant),
              ),
            ),

            // 2. Left Slanted Hanging Strap
            Positioned(
              left: 68,
              top: 38,
              child: Transform.rotate(
                angle: 0.24,
                child: _MockupStrap(
                  data: data,
                  variant: variant,
                  textOnLanyard: textOnLanyard,
                  height: 290,
                ),
              ),
            ),

            // 3. Right Slanted Hanging Strap
            Positioned(
              right: 68,
              top: 38,
              child: Transform.rotate(
                angle: -0.24,
                child: _MockupStrap(
                  data: data,
                  variant: variant,
                  textOnLanyard: textOnLanyard,
                  height: 290,
                ),
              ),
            ),

            // 4. Black Plastic Side-Release Buckle Clip at Strap Junction
            const Positioned(
              top: 310,
              child: _BlackBuckleClipWidget(),
            ),

            // 5. Lower Extension Ribbon Strap Hanging Below Buckle
            Positioned(
              top: 358,
              child: Container(
                width: 36,
                height: 65,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LanyardTemplateWidget(data: data, variant: variant),
              ),
            ),

            // 6. Steel D-Ring / Keyring Hook at Very Bottom
            const Positioned(
              top: 422,
              child: _SteelDRingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockupStrap extends StatelessWidget {
  const _MockupStrap({
    required this.data,
    required this.variant,
    required this.textOnLanyard,
    required this.height,
  });

  final LanyardData data;
  final int variant;
  final String textOnLanyard;
  final double height;

  TextStyle _textStyle() {
    Color textColor;
    if (data.textColorHex != null) {
      textColor = Color(data.textColorHex!);
    } else {
      switch (variant) {
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
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 0.8,
        height: 1.0,
        shadows: const [
          Shadow(
            color: Colors.black54,
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
      width: 38,
      height: height,
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
          // Background Template Ribbon Pattern
          LanyardTemplateWidget(
            data: data,
            variant: variant,
          ),

          // Translucent Ribbon Weave Texture Shading
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.25),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Printed Logo & Live Form Text along Strap Length
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Circular Logo
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: variant == 12
                          ? const Color(0xFFEF4444)
                          : (variant == 6 || variant == 9
                              ? const Color(0xFFFFD700)
                              : Colors.white),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: isFile
                        ? Image.file(File(data.logoPath), fit: BoxFit.cover)
                        : (isAsset
                            ? Image.asset(data.logoPath, fit: BoxFit.cover)
                            : const Icon(Icons.verified_rounded, color: Color(0xFF0284C7), size: 15)),
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

class _BlackBuckleClipWidget extends StatelessWidget {
  const _BlackBuckleClipWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
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

    // Top Female Buckle Housing
    final topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, 22),
      const Radius.circular(6),
    );
    canvas.drawRRect(topRect, fillPaint);
    canvas.drawRRect(topRect, borderPaint);

    // Inner Buckle Release Slots
    final slotPaint = Paint()..color = const Color(0xFF020617);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, size.width - 16, 10),
        const Radius.circular(3),
      ),
      slotPaint,
    );

    // Bottom Male Buckle Lock
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
      width: 40,
      height: 28,
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

    // Steel D-Ring
    final dPath = Path()
      ..moveTo(6, 4)
      ..lineTo(size.width - 6, 4)
      ..lineTo(size.width - 6, 12)
      ..arcToPoint(
        Offset(6, 12),
        radius: const Radius.circular(14),
        clockwise: true,
      )
      ..close();

    canvas.drawPath(dPath, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
