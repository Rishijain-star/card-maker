import 'package:flutter/material.dart';

import '../design_system/lanyard_dimensions.dart';

class LanyardScaledPreview extends StatelessWidget {
  const LanyardScaledPreview({
    super.key,
    required this.child,
    this.maxWidth = 360,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final scale = maxWidth / LanyardDimensions.designWidth;
    final height = LanyardDimensions.designHeight * scale;

    return Center(
      child: SizedBox(
        width: maxWidth,
        height: height,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: LanyardDimensions.designWidth,
            height: LanyardDimensions.designHeight,
            child: child,
          ),
        ),
      ),
    );
  }
}
