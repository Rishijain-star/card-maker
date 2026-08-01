import 'package:flutter/material.dart';

import '../design_system/lanyard_dimensions.dart';

class LanyardScaledPreview extends StatelessWidget {
  const LanyardScaledPreview({
    super.key,
    required this.child,
    this.maxHeight = 320,
  });

  final Widget child;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final scale = maxHeight / LanyardDimensions.designHeight;
    final width = LanyardDimensions.designWidth * scale;

    return Center(
      child: SizedBox(
        width: width,
        height: maxHeight,
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
