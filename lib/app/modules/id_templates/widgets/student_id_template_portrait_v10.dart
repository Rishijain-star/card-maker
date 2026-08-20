import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_text_styles.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 10 — red/navy borders, square photo; front = form fields; back = optional terms.
abstract final class _PortraitV10Layout {
  static const Color accentRed = Color(0xFFD32F2F);

  static const double frontInstituteTop = 0.052;
  static const double frontInstituteHeight = 0.085;
  static const double frontInstituteSide = 0.12;

  static const double frontPhotoSizeRatio = 0.32;
  static const double frontPhotoTopRatio = 0.145;
  static const double frontPhotoBorderWidth = 6.0;
  static const double frontGapBelowPhoto = 34.0;
  static const double frontContentSide = 0.11;
  static const double frontContentBottomRatio = 0.11;
  static const double frontNameMinFontSize = 24;
  static const double frontBodyMinFontSize = 18;
  static const double frontLineGapMin = 9.0;
  static const double frontLineGapMax = 16.0;
  static const double frontLineGapCompactMin = 5.0;
  static const double frontLineGapCompactMax = 11.0;
  static const double frontLineGapRelaxedMin = 11.0;
  static const double frontLineGapRelaxedMax = 18.0;
  static const double frontLineGapSpread = 1.05;

  static const double backInstituteTop = 0.052;
  static const double backInstituteHeight = 0.085;
  static const double backInstituteSide = 0.12;

  static const double backTermsTop = 0.17;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.20;
  static const double backTermsMinFontSize = 16;
  static const double backBulletSize = 12.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV10 extends StatelessWidget {
  const StudentIdTemplatePortraitV10({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
    this.headerTextColor,
    this.backHeaderTextColor,
    this.isBackHeaderAtBottom = false,
    this.frontInstituteTopOverride,
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;
  final Color? headerTextColor;
  final Color? backHeaderTextColor;
  final bool isBackHeaderAtBottom;
  final double? frontInstituteTopOverride;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  List<String> _frontDetailLines() {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.rollNo);
    add(data.section);
    add(data.bloodGroup);
    add(data.mobileNumber);
    add(data.email);
    add(data.address);
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final photoSize = _w * _PortraitV10Layout.frontPhotoSizeRatio;
    final photoTop = _h * _PortraitV10Layout.frontPhotoTopRatio;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop =
        photoTop + photoSize + _PortraitV10Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? StudentIdTemplateAssets.frontBackgroundV10,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * (frontInstituteTopOverride ?? _PortraitV10Layout.frontInstituteTop),
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
              color: headerTextColor ?? Colors.white,
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoSize,
          height: photoSize,
          child: _PortraitV10SquarePhoto(
            photoPath: data.photoPath,
            size: photoSize,
            borderWidth: _PortraitV10Layout.frontPhotoBorderWidth,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV10Layout.frontContentSide,
          right: _w * _PortraitV10Layout.frontContentSide,
          bottom: _h * _PortraitV10Layout.frontContentBottomRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth,
                    ),
                    child: _PortraitV10FrontColumn(
                      studentName: data.studentName,
                      fatherName: data.fatherName,
                      className: data.className,
                      detailLines: _frontDetailLines(),
                      validFrom: '',
                      validTo: '',
                      nameStyle: IdCardTextStyles.personName(fontFamily),
                      nameMinFontSize: _PortraitV10Layout.frontNameMinFontSize,
                      fatherStyle: IdCardTextStyles.fatherName(fontFamily),
                      courseStyle: IdCardTextStyles.course(fontFamily),
                      bodyStyle: IdCardTextStyles.detail(fontFamily),
                      bodyMinFontSize: _PortraitV10Layout.frontBodyMinFontSize,
                      validityLabelStyle:
                          IdCardTextStyles.validityLabel(fontFamily),
                      validityValueStyle:
                          IdCardTextStyles.validityValue(fontFamily),
                      compactSpacing: data.useCompactFrontSpacing,
                      relaxedSpacing: data.useRelaxedFrontSpacing,
                      maxHeight: constraints.maxHeight,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.035,
            bottom: _h * 0.035,
            child: StudentPortraitSignatureCircle(
              size: _w * 0.125,
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
    final terms = data.backDetailLines;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          backBgAsset ?? StudentIdTemplateAssets.backBackgroundV10,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: isBackHeaderAtBottom ? null : _h * _PortraitV10Layout.backInstituteTop,
            bottom: isBackHeaderAtBottom ? _h * 0.020 : null,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
              color: backHeaderTextColor,
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV10Layout.backTermsTop,
            left: _w * _PortraitV10Layout.backTermsSide,
            right: _w * _PortraitV10Layout.backTermsSide,
            bottom: _h * (isBackHeaderAtBottom ? 0.11 : _PortraitV10Layout.backTermsBottom),
            child: _PortraitV10CircleBulletedTerms(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: _PortraitV10Layout.backTermsMinFontSize,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
            ),
          ),
      ],
    );
  }
}

class _PortraitV10SquarePhoto extends StatelessWidget {
  const _PortraitV10SquarePhoto({
    required this.photoPath,
    required this.size,
    required this.borderWidth,
  });

  final String photoPath;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: _PortraitV10Layout.accentRed,
          width: borderWidth,
        ),
      ),
      child: ClipRect(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (photoPath.trim().isEmpty) {
      return const ColoredBox(
        color: Color(0xFFE2E8F0),
        child: Center(
          child: Icon(Icons.person, size: 72, color: Color(0xFF94A3B8)),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover, width: size, height: size);
    }
    return const ColoredBox(
      color: Color(0xFFE2E8F0),
      child: Center(
        child: Icon(Icons.person, size: 72, color: Color(0xFF94A3B8)),
      ),
    );
  }
}

class _PortraitV10FrontColumn extends StatelessWidget {
  const _PortraitV10FrontColumn({
    required this.studentName,
    required this.fatherName,
    required this.className,
    required this.detailLines,
    required this.validFrom,
    required this.validTo,
    required this.nameStyle,
    required this.nameMinFontSize,
    required this.fatherStyle,
    required this.courseStyle,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    required this.validityLabelStyle,
    required this.validityValueStyle,
    required this.compactSpacing,
    required this.relaxedSpacing,
    required this.maxHeight,
  });

  final String studentName;
  final String fatherName;
  final String className;
  final List<String> detailLines;
  final String validFrom;
  final String validTo;
  final TextStyle nameStyle;
  final double nameMinFontSize;
  final TextStyle fatherStyle;
  final TextStyle courseStyle;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final TextStyle validityLabelStyle;
  final TextStyle validityValueStyle;
  final bool compactSpacing;
  final bool relaxedSpacing;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    String capWords(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final name = capWords(studentName);
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 42) * 1.08,
      );
    }

    final father = capWords(fatherName);
    if (father.isNotEmpty) {
      add(
        AutoSizeText(
          father,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.center,
          style: fatherStyle,
        ),
        (fatherStyle.fontSize ?? 42) * 1.08,
      );
    }

    final course = capWords(className);
    if (course.isNotEmpty) {
      add(
        AutoSizeText(
          course,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.center,
          style: courseStyle,
        ),
        (courseStyle.fontSize ?? 42) * 1.08,
      );
    }

    for (final line in detailLines) {
      add(
        AutoSizeText(
          capWords(line),
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 32) * 1.25,
      );
    }

    if (validFrom.isNotEmpty) {
      add(
        _PortraitV10ValidityRow(
          label: 'VALID FROM',
          value: validFrom,
          labelStyle: validityLabelStyle,
          valueStyle: validityValueStyle,
        ),
        17,
      );
    }
    if (validTo.isNotEmpty) {
      add(
        _PortraitV10ValidityRow(
          label: 'VALID TILL',
          value: validTo,
          labelStyle: validityLabelStyle,
          valueStyle: validityValueStyle,
        ),
        17,
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    final gapCount = blocks.length - 1;
    if (gapCount <= 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: blocks,
      );
    }

    var gapMin = compactSpacing
        ? _PortraitV10Layout.frontLineGapCompactMin
        : _PortraitV10Layout.frontLineGapMin;
    var gapMax = compactSpacing
        ? _PortraitV10Layout.frontLineGapCompactMax
        : _PortraitV10Layout.frontLineGapMax;
    if (relaxedSpacing) {
      gapMin = _PortraitV10Layout.frontLineGapRelaxedMin;
      gapMax = _PortraitV10Layout.frontLineGapRelaxedMax;
    }

    final estTotal = estimates.fold(0.0, (a, b) => a + b);
    if (estTotal > maxHeight * 0.82) {
      gapMin = 4;
      gapMax = 9;
    }
    final free = (maxHeight - estTotal).clamp(0.0, double.infinity);
    var gap = ((free / gapCount) * _PortraitV10Layout.frontLineGapSpread)
        .clamp(gapMin, gapMax);
    if (estTotal + gap * gapCount > maxHeight) {
      gap = ((maxHeight - estTotal) / gapCount).clamp(2.0, gapMax);
    }

    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      if (i > 0) children.add(SizedBox(height: gap));
      children.add(blocks[i]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class _PortraitV10ValidityRow extends StatelessWidget {
  const _PortraitV10ValidityRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(width: 12),
        Flexible(
          child: AutoSizeText(
            value,
            maxLines: 1,
            minFontSize: 11,
            textAlign: TextAlign.center,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}

class _PortraitV10CircleBulletedTerms extends StatelessWidget {
  const _PortraitV10CircleBulletedTerms({
    required this.lines,
    required this.textStyle,
    required this.minFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final List<String> lines;
  final TextStyle textStyle;
  final double minFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gapMin = compactSpacing
            ? 10.0
            : relaxedSpacing
                ? 18.0
                : 12.0;
        final gapMax = compactSpacing
            ? 16.0
            : relaxedSpacing
                ? 24.0
                : 18.0;

        final est = lines.length * (textStyle.fontSize ?? 20) * 1.38;
        final free =
            (constraints.maxHeight - est).clamp(0.0, double.infinity);
        final gap = lines.length <= 1
            ? 0.0
            : (free / (lines.length - 1)).clamp(gapMin, gapMax);

        final rows = <Widget>[];
        for (var i = 0; i < lines.length; i++) {
          if (i > 0) rows.add(SizedBox(height: gap));
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: _PortraitV10Layout.backBulletSize,
                    height: _PortraitV10Layout.backBulletSize,
                    decoration: const BoxDecoration(
                      color: _PortraitV10Layout.accentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV10Layout.backBulletGap),
                Expanded(
                  child: AutoSizeText(
                    lines[i],
                    maxLines: 4,
                    minFontSize: minFontSize,
                    textAlign: TextAlign.left,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
