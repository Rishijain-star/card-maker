import 'dart:io';

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STUDENT PROFILE PHOTO — 3 STANDARDIZED WIDGETS
//
// These are the ONLY photo shape widgets used across ALL 40 Student ID Card
// templates. Each widget has ONE fixed size — never template-specific.
//
// Usage:
//   StudentPhotoCircle(photoPath: data.photoPath)
//   StudentPhotoSquare(photoPath: data.photoPath)
//   StudentPhotoHexagon(photoPath: data.photoPath)
// ─────────────────────────────────────────────────────────────────────────────

// ── Size constants (based on card canvas 638 × 1012px) ──────────────────────
abstract final class StudentPhotoSizes {
  /// Circle — diameter. 42% of card width → 268px.
  static const double circleDiameter = 268.0;

  /// Square — width × height. Portrait-oriented (taller than wide).
  /// Width: 38% of 638 → 243px. Height: 48% of 638 → 306px.
  static const double squareWidth = 243.0;
  static const double squareHeight = 306.0;

  /// Hexagon — width. Height auto = width × 1.15 (pointy-top).
  static const double hexagonWidth = 255.0;
  static const double hexagonHeightFactor = 1.15;

  /// Border width used on all three shapes.
  static const double borderWidth = 4.0;

  /// Default border colour (white — visible on any template background).
  static const Color defaultBorderColor = Color(0xFFFFFFFF);
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. CIRCLE PHOTO WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Standardized circular profile photo for ALL 40 Student ID Card templates.
/// Diameter: [StudentPhotoSizes.circleDiameter] (fixed — never changes per template).
class StudentPhotoCircle extends StatelessWidget {
  const StudentPhotoCircle({
    super.key,
    required this.photoPath,
    this.borderColor = StudentPhotoSizes.defaultBorderColor,
    this.borderWidth = StudentPhotoSizes.borderWidth,
  });

  final String photoPath;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    const double d = StudentPhotoSizes.circleDiameter;
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(child: _buildImage(d, d)),
    );
  }

  Widget _buildImage(double w, double h) => _PhotoContent(
        photoPath: photoPath,
        width: w,
        height: h,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. SQUARE (PORTRAIT) PHOTO WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Standardized portrait-rectangle profile photo for ALL 40 Student ID Card templates.
/// Size: [StudentPhotoSizes.squareWidth] × [StudentPhotoSizes.squareHeight] (fixed).
/// Slightly taller than wide — gives balanced look for student portraits.
class StudentPhotoSquare extends StatelessWidget {
  const StudentPhotoSquare({
    super.key,
    required this.photoPath,
    this.borderColor = StudentPhotoSizes.defaultBorderColor,
    this.borderWidth = StudentPhotoSizes.borderWidth,
    this.borderRadius = 10.0,
  });

  final String photoPath;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    const double w = StudentPhotoSizes.squareWidth;
    const double h = StudentPhotoSizes.squareHeight;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: _PhotoContent(
          photoPath: photoPath,
          width: w,
          height: h,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. HEXAGON PHOTO WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Standardized hexagonal profile photo for ALL 40 Student ID Card templates.
/// Width: [StudentPhotoSizes.hexagonWidth], height auto via [StudentPhotoSizes.hexagonHeightFactor].
class StudentPhotoHexagon extends StatelessWidget {
  const StudentPhotoHexagon({
    super.key,
    required this.photoPath,
    this.borderColor = StudentPhotoSizes.defaultBorderColor,
    this.borderWidth = StudentPhotoSizes.borderWidth,
  });

  final String photoPath;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    const double w = StudentPhotoSizes.hexagonWidth;
    final double h = w * StudentPhotoSizes.hexagonHeightFactor;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Clipped photo inside hexagon
          ClipPath(
            clipper: _HexagonClipper(inset: borderWidth),
            child: _PhotoContent(photoPath: photoPath, width: w, height: h),
          ),
          // Hexagon border stroke on top
          CustomPaint(
            painter: _HexagonBorderPainter(
              color: borderColor,
              strokeWidth: borderWidth,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED INTERNALS
// ─────────────────────────────────────────────────────────────────────────────

/// Renders photo from file path, or a placeholder person icon if empty/missing.
class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.photoPath,
    required this.width,
    required this.height,
  });

  final String photoPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (photoPath.trim().isNotEmpty) {
      final file = File(photoPath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    }
    // Placeholder — person icon on light background
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: width * 0.50,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

// ── Hexagon geometry helpers ─────────────────────────────────────────────────

/// Pointy-top hexagon path (same geometry used across circle/hex widgets).
Path _hexagonPath(Size size, {double inset = 0}) {
  final w = size.width - inset * 2;
  final h = size.height - inset * 2;
  final ox = inset;
  final oy = inset;
  return Path()
    ..moveTo(ox + w / 2, oy)
    ..lineTo(ox + w, oy + h * 0.25)
    ..lineTo(ox + w, oy + h * 0.75)
    ..lineTo(ox + w / 2, oy + h)
    ..lineTo(ox, oy + h * 0.75)
    ..lineTo(ox, oy + h * 0.25)
    ..close();
}

class _HexagonClipper extends CustomClipper<Path> {
  const _HexagonClipper({this.inset = 0});
  final double inset;

  @override
  Path getClip(Size size) => _hexagonPath(size, inset: inset);

  @override
  bool shouldReclip(covariant _HexagonClipper old) => old.inset != inset;
}

class _HexagonBorderPainter extends CustomPainter {
  const _HexagonBorderPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _hexagonPath(size, inset: strokeWidth / 2),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _HexagonBorderPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
