import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_typography.dart';
import 'student_id_card_side.dart';

/// Layout tuned only for this portrait PNG (638×1012) — not shared globally.
abstract final class _PortraitFrontLayout {
  /// Inset from green/blue corner art — keep text in central white only.
  static const double safeLeftRatio = 0.14;
  static const double safeRightRatio = 0.18;
  static const double safeTopRatio = 0.178;
  static const double safeBottomRatio = 0.14;

  /// Nudge photo, name, details, dates, address down — header unchanged.
  static const double contentShiftDownRatio = 0.02;

  static const double photoSizeRatio = 0.26;

  /// Front — small circular signature, bottom-right white area.
  static const double frontSignatureSizeRatio = 0.145;
  static const double frontSignatureRightRatio = 0.08;
  static const double frontSignatureBottomRatio = 0.128;

  static const double addressTopRatio = 0.902;
  static const double addressLeftRatio = 0.26;
  static const double addressRightRatio = 0.18;

  static const double validityFontSize = 17;
  static const double validityMinFontSize = 13;

  /// Institute header — position in green band (student name unchanged).
  static const double instituteTopRatio = 0.048 + 0.02;
  static const double instituteLeftRatio = 0.15;

  /// Back — institute in bottom-left gray strip; terms in white above it.
  static const double backFooterStripTopRatio = 0.878;
  static const double backFooterStripLeftRatio = 0.1;
  static const double backFooterStripRightRatio = 0.38;
  static const double backBodyTopRatio = 0.26;
  static const double backBodyBottomRatio = 0.152;

  static const double headerFontSize = 44;
  static const double headerMinFontSize = 20;

  static const double nameFontSize = 40;
  static const double nameMinFontSize = 22;
  static const double bodyFontSize = 27;
  static const double bodyMinFontSize = 18;
  static const double addressFontSize = 20;
  static const double addressMinFontSize = 15;

  static const double backHeaderFontSize = 28;
  static const double backBodyFontSize = 27;
  static const double backBodyMinFontSize = 18;
}

/// School portrait template — PNG background + dynamic form text.
class StudentIdTemplatePortrait extends StatelessWidget {
  const StudentIdTemplatePortrait({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  TextStyle _ts(TextStyle base) => IdCardTypography.apply(base, fontFamily);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final bodyLines = data.frontBodyLines;
    final photoSize = _w * _PortraitFrontLayout.photoSizeRatio;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackground,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitFrontLayout.instituteTopRatio,
            left: _w * _PortraitFrontLayout.instituteLeftRatio,
            right: _w * 0.05,
            child: AutoSizeText(
              data.instituteName.trim().toUpperCase(),
              maxLines: 2,
              minFontSize: _PortraitFrontLayout.headerMinFontSize,
              textAlign: TextAlign.left,
              style: _ts(
                const TextStyle(
                  color: Colors.white,
                  fontSize: _PortraitFrontLayout.headerFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        // Photo → name → details inside safe white band (avoids green art)
        Positioned(
          top: _h *
              (_PortraitFrontLayout.safeTopRatio +
                  _PortraitFrontLayout.contentShiftDownRatio),
          left: _w * _PortraitFrontLayout.safeLeftRatio,
          right: _w * _PortraitFrontLayout.safeRightRatio,
          bottom: _h * _PortraitFrontLayout.safeBottomRatio,
          child: _PortraitEvenContent(
            photoPath: data.photoPath,
            photoSize: photoSize,
            studentName: data.studentName,
            lines: bodyLines,
            fontFamily: fontFamily,
            footerLine: data.frontValidityHorizontalLine,
            footerStyle: _ts(
              const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: _PortraitFrontLayout.validityFontSize,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            footerMinFontSize: _PortraitFrontLayout.validityMinFontSize,
            nameStyle: _ts(
              const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: _PortraitFrontLayout.nameFontSize,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                height: 1.08,
                letterSpacing: 0.5,
              ),
            ),
            bodyStyle: _ts(
              const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: _PortraitFrontLayout.bodyFontSize,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                height: 1.35,
              ),
            ),
            nameMinFontSize: _PortraitFrontLayout.nameMinFontSize,
            bodyMinFontSize: _PortraitFrontLayout.bodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * _PortraitFrontLayout.frontSignatureRightRatio,
            bottom: _h * _PortraitFrontLayout.frontSignatureBottomRatio,
            child: _PortraitSignatureCircle(
              size: _w * _PortraitFrontLayout.frontSignatureSizeRatio,
              path: data.signaturePath,
              bytes: data.signatureBytes,
            ),
          ),
      ],
    );
  }

  Widget _buildBack() {
    final lines = data.backDetailLines;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.backBackground,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _PortraitFrontLayout.backBodyTopRatio,
          left: _w * 0.12,
          right: _w * 0.12,
          bottom: _h * _PortraitFrontLayout.backBodyBottomRatio,
          child: _PortraitEvenContent(
            lines: lines,
            fontFamily: fontFamily,
            bodyStyle: _ts(
              const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: _PortraitFrontLayout.backBodyFontSize,
                fontWeight: FontWeight.w600,
                height: 1.28,
              ),
            ),
            bodyMinFontSize: _PortraitFrontLayout.backBodyMinFontSize,
            maxLinesPerItem: 4,
            compactSpacing: data.useCompactFrontSpacing,
          ),
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            left: _w * _PortraitFrontLayout.backFooterStripLeftRatio,
            right: _w * _PortraitFrontLayout.backFooterStripRightRatio,
            top: _h * _PortraitFrontLayout.backFooterStripTopRatio,
            bottom: _h * 0.012,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: _PortraitFrontLayout.addressMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(
                  const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: _PortraitFrontLayout.backHeaderFontSize,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Photo + name + lines with equal vertical gaps across the white body.
class _PortraitEvenContent extends StatelessWidget {
  const _PortraitEvenContent({
    required this.lines,
    required this.fontFamily,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.photoPath = '',
    this.photoSize = 0,
    this.studentName = '',
    this.nameStyle,
    this.nameMinFontSize = 20,
    this.maxLinesPerItem = 2,
    this.compactSpacing = false,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
  });

  final bool compactSpacing;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final String photoPath;
  final double photoSize;
  final String studentName;
  final List<String> lines;
  final String fontFamily;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final TextStyle? nameStyle;
  final double nameMinFontSize;
  final int maxLinesPerItem;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];

    if (photoSize > 0) {
      blocks.add(_PortraitPhoto(photoPath: photoPath, size: photoSize));
    }

    final name = studentName.trim();
    if (name.isNotEmpty && nameStyle != null) {
      blocks.add(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 2,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.left,
          style: nameStyle,
        ),
      );
    }

    for (final line in lines) {
      blocks.add(
        AutoSizeText(
          line,
          maxLines: maxLinesPerItem,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.left,
          style: bodyStyle,
        ),
      );
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(
        AutoSizeText(
          footer,
          maxLines: 1,
          minFontSize: footerMinFontSize,
          textAlign: TextAlign.left,
          style: footerStyle,
        ),
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gapCount = blocks.length - 1;
        if (gapCount <= 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: blocks,
          );
        }

        // All form fields filled → tighter gaps; 3+ empty → normal spacing.
        final minGap = compactSpacing ? 9.0 : 15.0;
        final maxGap = compactSpacing ? 14.0 : 25.0;
        final spreadFactor = compactSpacing ? 0.82 : 0.96;
        final footerCount =
            (footerLine?.trim().isNotEmpty ?? false) && footerStyle != null ? 1 : 0;
        final estContent = _estimateHeight(
          photoSize: photoSize,
          hasName: name.isNotEmpty,
          lineCount: lines.length + footerCount,
          nameSize: nameStyle?.fontSize ?? _PortraitFrontLayout.nameFontSize,
          bodySize: bodyStyle.fontSize ?? _PortraitFrontLayout.bodyFontSize,
        );
        final free = (constraints.maxHeight - estContent).clamp(0.0, double.infinity);
        var gap = (free / gapCount) * spreadFactor;
        gap = gap.clamp(minGap, maxGap);

        final children = <Widget>[];
        for (var i = 0; i < blocks.length; i++) {
          if (i > 0) children.add(SizedBox(height: gap));
          children.add(blocks[i]);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  static double _estimateHeight({
    required double photoSize,
    required bool hasName,
    required int lineCount,
    required double nameSize,
    required double bodySize,
  }) {
    var h = 0.0;
    if (photoSize > 0) h += photoSize;
    if (hasName) h += nameSize * 1.15;
    h += lineCount * bodySize * 1.3;
    return h;
  }
}

class _PortraitPhoto extends StatelessWidget {
  const _PortraitPhoto({required this.photoPath, required this.size});

  final String photoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF22C55E), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: ClipOval(child: _buildImage(size)),
    );
  }

  Widget _buildImage(double diameter) {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(Icons.person, size: diameter * 0.45, color: Color(0xFF94A3B8)),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(Icons.person, size: diameter * 0.45, color: Color(0xFF94A3B8)),
    );
  }
}

class _PortraitSignatureCircle extends StatelessWidget {
  const _PortraitSignatureCircle({
    required this.size,
    required this.path,
    this.bytes,
  });

  final double size;
  final String path;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(bytes!, fit: BoxFit.contain, width: size, height: size);
    }
    if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.contain, width: size, height: size);
      }
    }
    return const SizedBox.shrink();
  }
}
