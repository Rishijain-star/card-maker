import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_text_styles.dart';
import '../design_system/id_card_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

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

  static const double validityMinFontSize = 13;

  /// Institute header — position in green band (student name unchanged).
  static const double instituteTopRatio = 0.048 + 0.02;

  /// Back — terms in the white area above the bottom strip.
  static const double backBodyTopRatio = 0.26;
  static const double backBodyBottomRatio = 0.152;

  static const double headerMinFontSize = 20;

  static const double nameFontSize = 40;
  static const double nameMinFontSize = 22;
  static const double bodyFontSize = 27;
  static const double bodyMinFontSize = 18;

  static const double backBodyMinFontSize = 18;
}

/// School portrait template — PNG background + dynamic form text.
class StudentIdTemplatePortrait extends StatelessWidget {
  const StudentIdTemplatePortrait({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
    this.isCenterAligned = false,
    this.photoSizeRatio,
    this.contentTopRatio,
    this.contentBottomRatio,
    this.frontInstituteTopOverride,
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;
  final bool isCenterAligned;
  final double? photoSizeRatio;
  final double? contentTopRatio;
  final double? contentBottomRatio;
  final double? frontInstituteTopOverride;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final photoSize = _w * (photoSizeRatio ?? _PortraitFrontLayout.photoSizeRatio);
    final topRatio = contentTopRatio ??
        (_PortraitFrontLayout.safeTopRatio +
            _PortraitFrontLayout.contentShiftDownRatio);
    final bottomRatio = contentBottomRatio ?? _PortraitFrontLayout.safeBottomRatio;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? StudentIdTemplateAssets.frontBackground,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * (frontInstituteTopOverride ?? _PortraitFrontLayout.instituteTopRatio),
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
            ),
          ),
        // Photo → name → details inside safe white band (avoids green art)
        Positioned(
          top: _h * topRatio,
          left: _w * _PortraitFrontLayout.safeLeftRatio,
          right: _w * _PortraitFrontLayout.safeRightRatio,
          bottom: _h * bottomRatio,
          child: _PortraitEvenContent(
            photoPath: data.photoPath,
            photoSize: photoSize,
            studentName: data.studentName,
            fatherName: data.fatherName,
            className: data.className,
            lines: data.frontDetailLines,
            fontFamily: fontFamily,
            footerLine: data.frontValidityHorizontalLine,
            footerStyle: IdCardTextStyles.footer(fontFamily),
            footerMinFontSize: _PortraitFrontLayout.validityMinFontSize,
            nameStyle: IdCardTextStyles.personName(fontFamily),
            bodyStyle: IdCardTextStyles.detail(fontFamily),
            nameMinFontSize: _PortraitFrontLayout.nameMinFontSize,
            bodyMinFontSize: _PortraitFrontLayout.bodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            isCenterAligned: isCenterAligned,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.05,
            bottom: _h * 0.045,
            child: _PortraitSignatureEllipse(
              width: _w * 0.25,
              height: _h * 0.065,
              path: data.signaturePath,
              bytes: data.signatureBytes,
              hasBorder: data.signatureHasBorder,
              borderColor: data.signatureBorderColor,
              borderWidth: data.signatureBorderWidth,
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
          backBgAsset ?? StudentIdTemplateAssets.backBackground,
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
            bodyStyle: IdCardTextStyles.terms(fontFamily),
            bodyMinFontSize: _PortraitFrontLayout.backBodyMinFontSize,
            maxLinesPerItem: 4,
            compactSpacing: data.useCompactFrontSpacing,
          ),
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            left: _w * 0.05,
            right: _w * 0.05,
            top: _h * (frontInstituteTopOverride ?? _PortraitFrontLayout.instituteTopRatio),
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
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
    this.fatherName = '',
    this.className = '',
    this.nameStyle,
    this.nameMinFontSize = 20,
    this.maxLinesPerItem = 2,
    this.compactSpacing = false,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
    this.isCenterAligned = false,
  });

  final bool compactSpacing;
  final bool isCenterAligned;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final String photoPath;
  final double photoSize;
  final String studentName;
  final String fatherName;
  final String className;
  final List<String> lines;
  final String fontFamily;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final TextStyle? nameStyle;
  final double nameMinFontSize;
  final int maxLinesPerItem;

  static String _cap(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '';
    return s
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final txtAlign = isCenterAligned ? TextAlign.center : TextAlign.left;
    final crossAlign = isCenterAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    if (photoSize > 0) {
      blocks.add(_PortraitPhoto(photoPath: photoPath, size: photoSize));
    }

    final name = _cap(studentName);
    if (name.isNotEmpty && nameStyle != null) {
      blocks.add(
        AutoSizeText(
          name,
          maxLines: 2,
          minFontSize: nameMinFontSize,
          textAlign: txtAlign,
          style: nameStyle,
        ),
      );
    }

    final father = _cap(fatherName);
    if (father.isNotEmpty && nameStyle != null) {
      blocks.add(
        AutoSizeText(
          father,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: txtAlign,
          style: nameStyle,
        ),
      );
    }

    final course = _cap(className);
    if (course.isNotEmpty && nameStyle != null) {
      blocks.add(
        AutoSizeText(
          course,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: txtAlign,
          style: nameStyle,
        ),
      );
    }

    for (final rawLine in lines) {
      final subLines = rawLine.split('\n');
      for (final line in subLines) {
        final v = line.trim();
        if (v.isEmpty) continue;
        blocks.add(
          AutoSizeText(
            _cap(v),
            maxLines: maxLinesPerItem,
            minFontSize: bodyMinFontSize,
            textAlign: txtAlign,
            style: bodyStyle,
          ),
        );
      }
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(
        AutoSizeText(
          footer,
          maxLines: 1,
          minFontSize: footerMinFontSize,
          textAlign: txtAlign,
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
            crossAxisAlignment: crossAlign,
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

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: crossAlign,
              mainAxisAlignment: MainAxisAlignment.start,
              children: children,
            ),
          ),
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

class _PortraitSignatureEllipse extends StatelessWidget {
  const _PortraitSignatureEllipse({
    required this.width,
    required this.height,
    required this.path,
    this.bytes,
    this.hasBorder = false,
    this.borderColor = const Color(0xFF0F172A),
    this.borderWidth = 1.0,
  });

  final double width;
  final double height;
  final String path;
  final Uint8List? bytes;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.elliptical(width / 2, height / 2)),
        border: Border.all(
          color: hasBorder ? borderColor : const Color(0xFFCBD5E1),
          width: hasBorder ? borderWidth : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(hasBorder ? borderWidth : 0),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(bytes!, fit: BoxFit.fill, width: width, height: height);
    }
    if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.fill, width: width, height: height);
      }
    }
    return const SizedBox.shrink();
  }
}
