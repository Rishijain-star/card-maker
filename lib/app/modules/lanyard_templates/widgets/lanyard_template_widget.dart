import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../design_system/lanyard_dimensions.dart';

/// Full-width Horizontal Lanyard Ribbon Strip featuring assets/lanyard/blue.png background image,
/// circular logo filling, and repeating form text placed across the bright sky blue safe areas.
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
    return SizedBox(
      width: LanyardDimensions.designWidth,
      height: LanyardDimensions.designHeight,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ribbon background image based on variant
            Image.asset(
              _assetForVariant(variant),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),

            // Horizontal repeating Logo + Lanyard Text in cyan safe areas
            _HorizontalRibbonContent(
              data: data,
              variant: variant,
            ),
          ],
        ),
      ),
    );
  }

  String _assetForVariant(int variant) {
    switch (variant) {
      case 1:
        return 'assets/lanyard/blue+red.png';
      case 2:
        return 'assets/lanyard/green.png';
      case 3:
        return 'assets/lanyard/green+black.png';
      case 4:
        return 'assets/lanyard/red.png';
      case 5:
        return 'assets/lanyard/white+blue.png';
      default:
        return 'assets/lanyard/blue.png';
    }
  }
}

class _CircularLogoWidget extends StatelessWidget {
  const _CircularLogoWidget({
    required this.logoPath,
    this.variant = 0,
    this.size = 32.0,
  });

  final String logoPath;
  final int variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isFile = logoPath.isNotEmpty && File(logoPath).existsSync();
    final isAsset = logoPath.isNotEmpty &&
        (logoPath.startsWith('assets/') || logoPath.startsWith('imagesss/'));

    final borderColor = variant == 1
        ? const Color(0xFF00E5FF)
        : (variant == 3 ? const Color(0xFFFFD700) : Colors.white);

    Widget content;
    if (isFile) {
      content = Image.file(
        File(logoPath),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (isAsset) {
      content = Image.asset(
        logoPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else {
      content = Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Icon(
          Icons.verified_rounded,
          color: variant == 3
              ? const Color(0xFFD97706)
              : const Color(0xFF0284C7),
          size: size * 0.55,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(child: content),
    );
  }
}

class _HorizontalRibbonContent extends StatelessWidget {
  const _HorizontalRibbonContent({
    required this.data,
    required this.variant,
  });

  final LanyardData data;
  final int variant;

  TextStyle _textStyle() {
    Color textColor;
    switch (variant) {
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

    return IdCardTypography.apply(
      TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 0.8,
        height: 1.0,
        shadows: const [
          Shadow(
            color: Colors.black87,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      data.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textOnLanyard =
        data.organization.isNotEmpty ? data.organization : 'ID-SHAYDI';

    final textStyle = _textStyle();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Unit 1
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircularLogoWidget(
                logoPath: data.logoPath,
                variant: variant,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                textOnLanyard.toUpperCase(),
                style: textStyle,
              ),
            ],
          ),

          // Unit 2
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircularLogoWidget(
                logoPath: data.logoPath,
                variant: variant,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                textOnLanyard.toUpperCase(),
                style: textStyle,
              ),
            ],
          ),

          // Unit 3
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircularLogoWidget(
                logoPath: data.logoPath,
                variant: variant,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                textOnLanyard.toUpperCase(),
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
