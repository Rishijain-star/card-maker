import 'package:flutter/material.dart';

import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_portrait_dimensions.dart';

/// Scales a fixed-size ID card widget to fill the parent.
class IdCardScaledPreview extends StatelessWidget {
  const IdCardScaledPreview({
    super.key,
    required this.designWidth,
    required this.designHeight,
    required this.child,
    this.fit = BoxFit.contain,
  });

  final double designWidth;
  final double designHeight;
  final Widget child;
  final BoxFit fit;

  factory IdCardScaledPreview.landscapeCard({
    Key? key,
    required Widget child,
    BoxFit fit = BoxFit.contain,
  }) {
    return IdCardScaledPreview(
      key: key,
      designWidth: IdCardDimensions.width,
      designHeight: IdCardDimensions.height,
      fit: fit,
      child: child,
    );
  }

  factory IdCardScaledPreview.portraitCard({
    Key? key,
    required Widget child,
    BoxFit fit = BoxFit.contain,
  }) {
    return IdCardScaledPreview(
      key: key,
      designWidth: IdCardPortraitDimensions.width,
      designHeight: IdCardPortraitDimensions.height,
      fit: fit,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxW = constraints.maxWidth;
        var maxH = constraints.maxHeight;

        if (!maxW.isFinite || maxW <= 0) maxW = designWidth;
        if (!maxH.isFinite || maxH <= 0) {
          maxH = maxW * (designHeight / designWidth);
        }

        return SizedBox(
          width: maxW,
          height: maxH,
          child: FittedBox(
            fit: fit,
            alignment: Alignment.center,
            child: SizedBox(
              width: designWidth,
              height: designHeight,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Portrait row height — front | back 50/50.
double templatePickerRowHeight(BuildContext context) {
  final screenW = MediaQuery.sizeOf(context).width;
  const horizontalPad = 24.0;
  const gap = 5.0;
  final halfW = (screenW - horizontalPad - gap) / 2;
  return halfW * (IdCardPortraitDimensions.height / IdCardPortraitDimensions.width);
}
