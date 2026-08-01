import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../design_system/lanyard_dimensions.dart';

/// Programmatic lanyard strap — 4 layout variants, form data only.
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
    final accent = Color(data.accentColorHex);
    final darker = Color.lerp(accent, Colors.black, 0.28) ?? accent;

    return SizedBox(
      width: LanyardDimensions.designWidth,
      height: LanyardDimensions.designHeight,
      child: Column(
        children: [
          _Clip(accent: accent),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [accent, darker],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _StrapBody(data: data, variant: variant),
            ),
          ),
        ],
      ),
    );
  }
}

class _Clip extends StatelessWidget {
  const _Clip({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color(0xFF64748B)),
            ),
          ),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class _StrapBody extends StatelessWidget {
  const _StrapBody({required this.data, required this.variant});

  final LanyardData data;
  final int variant;

  TextStyle _textStyle({
    required double size,
    required FontWeight weight,
    Color color = Colors.white,
  }) {
    return IdCardTypography.apply(
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.15,
      ),
      data.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (variant == 1)
          Positioned(
            left: 12,
            right: 12,
            top: 48,
            bottom: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (variant == 2)
          Positioned.fill(
            child: CustomPaint(painter: _StripePainter()),
          ),
        if (variant == 3)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
          child: Column(
            children: [
              if (data.logoPath.isNotEmpty && File(data.logoPath).existsSync())
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: FileImage(File(data.logoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (variant != 2)
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.image_outlined, color: Colors.white.withValues(alpha: 0.7), size: 20),
                ),
              if (data.organization.isNotEmpty)
                Text(
                  data.organization.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(size: 8, weight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9)),
                ),
              if (data.organization.isNotEmpty && data.name.isNotEmpty)
                const SizedBox(height: 8),
              if (data.name.isNotEmpty)
                Text(
                  data.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(size: 13, weight: FontWeight.w800),
                ),
              if (data.subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  data.subtitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(size: 9, weight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.92)),
                ),
              ],
              const Spacer(),
              Container(
                width: double.infinity,
                height: 3,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 8;
    for (var i = -size.height; i < size.width + size.height; i += 18) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
