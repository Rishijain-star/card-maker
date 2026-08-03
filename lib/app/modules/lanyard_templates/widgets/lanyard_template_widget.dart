import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/lanyard_data.dart';
import '../../id_templates/design_system/id_card_typography.dart';
import '../design_system/lanyard_dimensions.dart';

/// Lanyard strap featuring assets/lanyard/blue.png background image,
/// circular logo filling, and form text overlay in the sky blue (aasmani) area.
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

    return SizedBox(
      width: LanyardDimensions.designWidth,
      height: LanyardDimensions.designHeight,
      child: Column(
        children: [
          _MetalClip(accent: accent),
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Blue lanyard ribbon background image
                  Image.asset(
                    'assets/lanyard/blue.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),

                  // Overlay Lanyard Form Details (Logo in Circle + Text in aasmani area)
                  _StrapContentOverlay(data: data, variant: variant),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetalClip extends StatelessWidget {
  const _MetalClip({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Column(
        children: [
          // Steel Ring
          Container(
            width: 38,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF64748B), width: 1.5),
            ),
          ),
          // Metallic Clamp Hook
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularLogoWidget extends StatelessWidget {
  const _CircularLogoWidget({
    required this.logoPath,
    this.size = 38.0,
  });

  final String logoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasFile = logoPath.isNotEmpty && File(logoPath).existsSync();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF0284C7), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: hasFile
            ? Image.file(
                File(logoPath),
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF0284C7),
                  size: 20,
                ),
              ),
      ),
    );
  }
}

class _StrapContentOverlay extends StatelessWidget {
  const _StrapContentOverlay({
    required this.data,
    required this.variant,
  });

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
        shadows: const [
          Shadow(
            color: Colors.black54,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      data.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    final org = data.organization.isNotEmpty ? data.organization : 'ID-SHAYDI';
    final name = data.name.isNotEmpty ? data.name : 'STAFF MEMBER';
    final role = data.subtitle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Circle Logo filled neatly
          _CircularLogoWidget(
            logoPath: data.logoPath,
            size: variant == 3 ? 44.0 : 38.0,
          ),

          const SizedBox(height: 12),

          // Lanyard Form Text in the aasmani (sky blue) section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  org.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(
                    size: 9,
                    weight: FontWeight.w700,
                    color: const Color(0xFF00E5FF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(
                    size: 11,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (role.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    role.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _textStyle(
                      size: 8,
                      weight: FontWeight.w600,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Repeating Logo + Text Section lower down the ribbon
          if (variant == 0 || variant == 2) ...[
            _CircularLogoWidget(
              logoPath: data.logoPath,
              size: 28.0,
            ),
            const SizedBox(height: 4),
            Text(
              org.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _textStyle(
                size: 8,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
