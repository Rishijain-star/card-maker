import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../widgets/lanyard_template_widget.dart';

/// 100% Visually Identical & RenderFlex Overflow-Free Lanyard Neck Mockup Preview.
/// Uses FittedBox scaling so LanyardTemplateWidget fits into straps cleanly without any terminal errors.
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
    return Center(
      child: Container(
        width: 320,
        height: 440,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // 1. Top Neck Ribbon Fold Band (Scaled with FittedBox to prevent overflow)
            Positioned(
              top: 10,
              child: Container(
                width: 165,
                height: 38,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.20),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: LanyardTemplateWidget(data: data, variant: variant),
                ),
              ),
            ),

            // 2. Left Slanted Hanging Strap (FittedBox scaled 100% identical template)
            Positioned(
              left: 56,
              top: 10,
              child: Transform.rotate(
                angle: 0.21,
                alignment: Alignment.topRight,
                child: _MockupStrapSegment(
                  data: data,
                  variant: variant,
                  height: 275,
                ),
              ),
            ),

            // 3. Right Slanted Hanging Strap (FittedBox scaled 100% identical template)
            Positioned(
              right: 56,
              top: 10,
              child: Transform.rotate(
                angle: -0.21,
                alignment: Alignment.topLeft,
                child: _MockupStrapSegment(
                  data: data,
                  variant: variant,
                  height: 275,
                ),
              ),
            ),

            // 4. Black Plastic Side-Release Buckle Clip
            const Positioned(
              top: 270,
              child: _BlackBuckleClipWidget(),
            ),

            // 5. Lower Extension Ribbon Strap
            Positioned(
              top: 314,
              child: Container(
                width: 36,
                height: 52,
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
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: LanyardTemplateWidget(data: data, variant: variant),
                ),
              ),
            ),

            // 6. Steel D-Ring Keyring Hook
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

class _MockupStrapSegment extends StatelessWidget {
  const _MockupStrapSegment({
    required this.data,
    required this.variant,
    required this.height,
  });

  final LanyardData data;
  final int variant;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // FittedBox scales LanyardTemplateWidget cleanly into strap without layout errors
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.antiAlias,
            child: RotatedBox(
              quarterTurns: 1,
              child: LanyardTemplateWidget(
                data: data,
                variant: variant,
              ),
            ),
          ),

          // Translucent Ribbon Fabric Shading Overlay
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
