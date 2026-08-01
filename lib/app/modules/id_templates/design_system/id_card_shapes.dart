import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'id_card_theme.dart';

/// Layered circles used across all student ID templates.
class IdCardCircleLayer extends StatelessWidget {
  const IdCardCircleLayer({
    super.key,
    required this.theme,
    this.topRight = true,
  });

  final IdCardTheme theme;
  final bool topRight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topRight ? -48 : null,
      bottom: topRight ? null : -56,
      right: topRight ? -36 : null,
      left: topRight ? null : -40,
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _ring(180, theme.accentLight.withValues(alpha: 0.45)),
            Positioned(
              top: 24,
              left: 18,
              child: _ring(120, theme.accent.withValues(alpha: 0.22)),
            ),
            Positioned(
              top: 52,
              left: 44,
              child: _ring(64, theme.primary.withValues(alpha: 0.12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ring(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// Smooth wave header / footer for card templates.
class IdCardWaveClipper extends CustomClipper<Path> {
  IdCardWaveClipper({this.inverted = false, this.waveHeight = 0.22});

  final bool inverted;
  final double waveHeight;

  @override
  Path getClip(Size size) {
    final path = Path();
    final h = size.height * waveHeight;
    if (inverted) {
      path.moveTo(0, h);
      path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, h * 0.35);
      path.quadraticBezierTo(size.width * 0.78, h * 0.7, size.width, h * 0.15);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - h);
      path.quadraticBezierTo(
        size.width * 0.22,
        size.height,
        size.width * 0.5,
        size.height - h * 0.55,
      );
      path.quadraticBezierTo(
        size.width * 0.82,
        size.height - h * 1.15,
        size.width,
        size.height - h * 0.2,
      );
      path.lineTo(size.width, 0);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant IdCardWaveClipper oldClipper) =>
      oldClipper.inverted != inverted || oldClipper.waveHeight != waveHeight;
}

class IdCardWaveHeader extends StatelessWidget {
  const IdCardWaveHeader({
    super.key,
    required this.theme,
    required this.height,
    this.child,
  });

  final IdCardTheme theme;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: IdCardWaveClipper(waveHeight: 0.28),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.primary, theme.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryDark.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Decorative arc at card bottom.
class IdCardBottomAccent extends StatelessWidget {
  const IdCardBottomAccent({super.key, required this.theme});

  final IdCardTheme theme;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 56),
      painter: _BottomArcPainter(theme.accent.withValues(alpha: 0.18)),
    );
  }
}

class _BottomArcPainter extends CustomPainter {
  _BottomArcPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.15,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomArcPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Signature image only — no box/background, bottom-right on card.
class IdCardSignatureImage extends StatelessWidget {
  const IdCardSignatureImage({
    super.key,
    required this.signaturePath,
    this.signatureBytes,
    this.width = 200,
    this.height = 88,
  });

  final String signaturePath;
  final Uint8List? signatureBytes;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final image = _buildImage();
    if (image == null) return const SizedBox.shrink();
    return SizedBox(
      width: width,
      height: height,
      child: image,
    );
  }

  Widget? _buildImage() {
    if (signatureBytes != null && signatureBytes!.isNotEmpty) {
      return Image.memory(
        signatureBytes!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      );
    }
    if (signaturePath.trim().isNotEmpty) {
      final file = File(signaturePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        );
      }
    }
    return null;
  }
}

/// Circular photo frame with layered rings.
class IdCardPhotoFrame extends StatelessWidget {
  const IdCardPhotoFrame({
    super.key,
    required this.theme,
    required this.photoPath,
    required this.diameter,
  });

  final IdCardTheme theme;
  final String photoPath;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final inner = diameter * 0.82;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.ringOuter, width: 3),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryDark.withValues(alpha: 0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
          Container(
            width: diameter - 10,
            height: diameter - 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.ringInner, width: 5),
            ),
          ),
          ClipOval(
            child: SizedBox(
              width: inner,
              height: inner,
              child: _buildPhoto(inner),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto(double size) {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: theme.ringInner,
        child: Icon(Icons.person_rounded, size: size * 0.45, color: theme.accent),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: theme.ringInner,
      child: Icon(Icons.person_rounded, size: size * 0.45, color: theme.accent),
    );
  }
}
