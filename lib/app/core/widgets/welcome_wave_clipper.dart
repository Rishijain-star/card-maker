import 'package:flutter/material.dart';

/// Curved top edge for the white bottom panel (matches onboarding mockup).
class WelcomeWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const dipY = 36.0;
    const crestY = 6.0;

    final path = Path()
      ..moveTo(0, dipY)
      ..quadraticBezierTo(size.width * 0.5, crestY, size.width, dipY)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
