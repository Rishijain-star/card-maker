import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 9 — front: main fields + validity; back: optional terms + institute.
abstract final class _PortraitV9Layout {
  static const Color textDark = Color(0xFF37474F);
  static const Color bulletRed = Color(0xFFD32F2F);

  static const double frontInstituteTop = 0.038;
  static const double frontInstituteHeight = 0.09;
  static const double frontInstituteSide = 0.08;

  static const double frontPhotoSizeRatio = 0.39;
  static const double frontPhotoCenterYRatio = 0.318;
  static const double frontPhotoBorderWidth = 4.5;
  static const double frontGapBelowPhoto = 12.0;
  static const double frontContentMinTopRatio = 0.478;
  static const double frontContentSide = 0.09;
  static const double frontContentBottomRatio = 0.08;
  static const double frontNameFontSize = 44;
  static const double frontNameMinFontSize = 26;
  static const double frontBodyFontSize = 30;
  static const double frontBodyMinFontSize = 20;
  static const double frontLineGapMin = 16.0;
  static const double frontLineGapMax = 38.0;
  static const double frontLineGapCompactMin = 10.0;
  static const double frontLineGapCompactMax = 24.0;
  static const double frontLineGapRelaxedMin = 20.0;
  static const double frontLineGapRelaxedMax = 48.0;
  static const double frontLineGapSpread = 1.05;

  static const double backWhiteTop = 0.055;
  static const double backWhiteSide = 0.10;
  static const double backWhiteBottom = 0.48;
  static const double backTermsFontSize = 26;
  static const double backTermsMinFontSize = 18;
  static const double backBulletSize = 10.0;
  static const double backBulletGap = 12.0;

  static const double backInstituteBottom = 0.065;
  static const double backInstituteHeight = 0.09;
  static const double backInstituteSide = 0.08;
}

class StudentIdTemplatePortraitV9 extends StatelessWidget {
  const StudentIdTemplatePortraitV9({
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

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);
  TextStyle _tsPrimary(TextStyle base) => studentPortraitPrimaryTextStyle(base, fontFamily);

  static int _instituteMaxLines(String name) {
    if (name.contains('\n')) {
      final lines = name.split('\n').where((s) => s.trim().isNotEmpty).length;
      return lines.clamp(2, 4);
    }
    return 2;
  }

  /// Main form fields on front (optional terms stay on back).
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
    final photoSize = _w * _PortraitV9Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _PortraitV9Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final afterPhoto =
        photoTop + photoSize + _PortraitV9Layout.frontGapBelowPhoto;
    final whiteStart = _h * _PortraitV9Layout.frontContentMinTopRatio;
    final contentTop = afterPhoto > whiteStart ? afterPhoto : whiteStart;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV9,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV9Layout.frontInstituteTop,
            height: _h * _PortraitV9Layout.frontInstituteHeight,
            left: _w * _PortraitV9Layout.frontInstituteSide,
            right: _w * _PortraitV9Layout.frontInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: 0.4,
                )),
              ),
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoSize,
          height: photoSize,
          child: StudentPortraitPhoto(
            photoPath: data.photoPath,
            size: photoSize,
            borderColor: Colors.white,
            borderWidth: _PortraitV9Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV9Layout.frontContentSide,
          right: _w * _PortraitV9Layout.frontContentSide,
          bottom: _h * _PortraitV9Layout.frontContentBottomRatio,
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
                    child: _PortraitV9FrontColumn(
                      studentName: data.studentName,
                      fatherName: data.fatherName,
                      className: data.className,
                      detailLines: _frontDetailLines(),
                      validFrom: '',
                      validTo: '',
                      nameStyle: _tsPrimary(const TextStyle(
                        color: _PortraitV9Layout.textDark,
                        fontSize: _PortraitV9Layout.frontNameFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.05,
                      )),
                      nameMinFontSize: _PortraitV9Layout.frontNameMinFontSize,
                      fatherStyle: _tsPrimary(const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.05,
                        letterSpacing: 0.5,
                      )),
                      courseStyle: _tsPrimary(const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.05,
                        letterSpacing: 0.5,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: IdCardPortraitTypography.bodyFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.05,
                        letterSpacing: 0.5,
                      )),
                      bodyMinFontSize: _PortraitV9Layout.frontBodyMinFontSize,
                      validityLabelStyle: _ts(const TextStyle(
                        color: _PortraitV9Layout.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      )),
                      validityValueStyle: _ts(const TextStyle(
                        color: _PortraitV9Layout.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )),
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
          StudentIdTemplateAssets.backBackgroundV9,
          fit: BoxFit.fill,
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV9Layout.backWhiteTop,
            left: _w * _PortraitV9Layout.backWhiteSide,
            right: _w * _PortraitV9Layout.backWhiteSide,
            bottom: _h * _PortraitV9Layout.backWhiteBottom,
            child: _PortraitV9SquareBulletedTerms(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _PortraitV9Layout.textDark,
                fontSize: _PortraitV9Layout.backTermsFontSize,
                fontWeight: FontWeight.w400,
                height: 1.34,
              )),
              minFontSize: _PortraitV9Layout.backTermsMinFontSize,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
            ),
          ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            left: _w * _PortraitV9Layout.backInstituteSide,
            right: _w * _PortraitV9Layout.backInstituteSide,
            bottom: _h * _PortraitV9Layout.backInstituteBottom,
            height: _h * _PortraitV9Layout.backInstituteHeight,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.backHeaderFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                  letterSpacing: 0.35,
                )),
              ),
            ),
          ),
      ],
    );
  }

}

class _PortraitV9FrontColumn extends StatelessWidget {
  const _PortraitV9FrontColumn({
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
        _PortraitV9ValidityRow(
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
        _PortraitV9ValidityRow(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: blocks,
      );
    }

    var gapMin = compactSpacing
        ? _PortraitV9Layout.frontLineGapCompactMin
        : _PortraitV9Layout.frontLineGapMin;
    var gapMax = compactSpacing
        ? _PortraitV9Layout.frontLineGapCompactMax
        : _PortraitV9Layout.frontLineGapMax;
    if (relaxedSpacing) {
      gapMin = _PortraitV9Layout.frontLineGapRelaxedMin;
      gapMax = _PortraitV9Layout.frontLineGapRelaxedMax;
    }

    final estTotal = estimates.fold(0.0, (a, b) => a + b);
    final free = (maxHeight - estTotal).clamp(0.0, double.infinity);
    var gap = ((free / gapCount) * _PortraitV9Layout.frontLineGapSpread)
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

class _PortraitV9ValidityRow extends StatelessWidget {
  const _PortraitV9ValidityRow({
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

class _PortraitV9SquareBulletedTerms extends StatelessWidget {
  const _PortraitV9SquareBulletedTerms({
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
                    width: _PortraitV9Layout.backBulletSize,
                    height: _PortraitV9Layout.backBulletSize,
                    color: _PortraitV9Layout.bulletRed,
                  ),
                ),
                SizedBox(width: _PortraitV9Layout.backBulletGap),
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
