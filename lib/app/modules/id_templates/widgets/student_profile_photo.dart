import 'dart:io';
import 'package:flutter/material.dart';

/// 3 Standardized Profile Photo Widgets for Student ID Cards
/// Shape: Circle, Square (Portrait), Hexagon
/// Sizing is completely standardized and uniform across all 40 templates.

// ── Circle Photo ─────────────────────────────────────────────────────────

class StudentCirclePhoto extends StatelessWidget {
  const StudentCirclePhoto({
    super.key,
    required this.photoPath,
    required this.cardWidth,
  });

  final String photoPath;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    // Fixed standardized size: 35% of card width
    final size = cardWidth * 0.35;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildImageContent(photoPath, size, size),
      ),
    );
  }
}

// ── Square (Portrait) Photo ──────────────────────────────────────────────

class StudentSquarePhoto extends StatelessWidget {
  const StudentSquarePhoto({
    super.key,
    required this.photoPath,
    required this.cardWidth,
  });

  final String photoPath;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    // Fixed standardized size: width is slightly less, height is slightly more
    // Example: Width 32% of card, Height 40% of card (Portrait Square/Rectangle)
    final width = cardWidth * 0.32;
    final height = cardWidth * 0.35;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // Slight rounding for professional look
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: _buildImageContent(photoPath, width, height),
      ),
    );
  }
}

// ── Hexagon Photo ────────────────────────────────────────────────────────

class StudentHexagonPhoto extends StatelessWidget {
  const StudentHexagonPhoto({
    super.key,
    required this.photoPath,
    required this.cardWidth,
  });

  final String photoPath;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    // Fixed standardized size
    final width = cardWidth * 0.36;
    final height = width * 1.12; // Pointy hexagon is slightly taller than wide

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image Content clipped to Hexagon
          ClipPath(
            clipper: const _HexagonClipper(),
            child: _buildImageContent(photoPath, width, height),
          ),
          // Hexagon Border
          CustomPaint(
            painter: _HexagonBorderPainter(
              color: Colors.white,
              strokeWidth: 3.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Common Helpers ───────────────────────────────────────────────────────

Widget _buildImageContent(String path, double w, double h) {
  if (path.trim().isEmpty) {
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Center(
        child: Icon(Icons.person, size: w * 0.45, color: const Color(0xFF94A3B8)),
      ),
    );
  }
  final file = File(path);
  if (file.existsSync()) {
    return Image.file(file, fit: BoxFit.cover, width: w, height: h);
  }
  return ColoredBox(
    color: const Color(0xFFE2E8F0),
    child: Center(
      child: Icon(Icons.person, size: w * 0.45, color: const Color(0xFF94A3B8)),
    ),
  );
}

// ── Hexagon Geometry ─────────────────────────────────────────────────────

class _HexagonClipper extends CustomClipper<Path> {
  const _HexagonClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h * 0.25)
      ..lineTo(w, h * 0.75)
      ..lineTo(w / 2, h)
      ..lineTo(0, h * 0.75)
      ..lineTo(0, h * 0.25)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Inset the path so the thick stroke isn't cropped by the bounding box
    final inset = strokeWidth / 2;
    final w = size.width - strokeWidth;
    final h = size.height - strokeWidth;
    final ox = inset;
    final oy = inset;

    final path = Path()
      ..moveTo(ox + w / 2, oy)
      ..lineTo(ox + w, oy + h * 0.25)
      ..lineTo(ox + w, oy + h * 0.75)
      ..lineTo(ox + w / 2, oy + h)
      ..lineTo(ox, oy + h * 0.75)
      ..lineTo(ox, oy + h * 0.25)
      ..close();

    // Add slight shadow for hexagon border
    canvas.drawShadow(path, Colors.black, 4.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HexagonBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
