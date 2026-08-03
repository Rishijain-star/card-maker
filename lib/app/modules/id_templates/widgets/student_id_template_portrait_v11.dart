import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 11 — teal organic PNG; front = form fields; back = optional terms.
abstract final class _PortraitV11Layout {
  static const Color textDark = Color(0xFF1E293B);
  static const Color accentTeal = Color(0xFF0D6E6E);

  static const double frontInstituteTop = 0.048;
  static const double frontInstituteHeight = 0.095;
  static const double frontInstituteLeft = 0.07;
  static const double frontInstituteRight = 0.42;

  static const double frontPhotoSizeRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.258;
  static const double frontPhotoBorderWidth = 3.5;
  static const double frontGapBelowPhoto = 14.0;
  static const double frontContentMinTopRatio = 0.395;
  static const double frontContentSide = 0.10;
  static const double frontContentBottomRatio = 0.13;
  static const double frontNameFontSize = 44;
  static const double frontNameMinFontSize = 24;
  static const double frontBodyFontSize = 28;
  static const double frontBodyMinFontSize = 18;
  static const double frontLineGapMin = 9.0;
  static const double frontLineGapMax = 16.0;
  static const double frontLineGapCompactMin = 5.0;
  static const double frontLineGapCompactMax = 11.0;
  static const double frontLineGapRelaxedMin = 11.0;
  static const double frontLineGapRelaxedMax = 18.0;
  static const double frontLineGapSpread = 1.05;

  static const double backInstituteTop = 0.048;
  static const double backInstituteHeight = 0.095;
  static const double backInstituteLeft = 0.07;
  static const double backInstituteRight = 0.42;

  /// Terms sit in central white (below top teal blob on PNG).
  static const double backTermsTop = 0.27;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.17;
  static const double backTermsFontSize = 26;
  static const double backTermsMinFontSize = 16;
  static const double backBulletSize = 12.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV11 extends StatelessWidget {
  const StudentIdTemplatePortraitV11({
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

  static int _instituteMaxLines(String name) {
    if (name.contains('\n')) {
      final lines = name.split('\n').where((s) => s.trim().isNotEmpty).length;
      return lines.clamp(2, 4);
    }
    return 1;
  }

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
    final photoSize = _w * _PortraitV11Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _PortraitV11Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final afterPhoto =
        photoTop + photoSize + _PortraitV11Layout.frontGapBelowPhoto;
    final whiteStart = _h * _PortraitV11Layout.frontContentMinTopRatio;
    final contentTop = afterPhoto > whiteStart ? afterPhoto : whiteStart;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV11,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV11Layout.frontInstituteTop,
            height: _h * _PortraitV11Layout.frontInstituteHeight,
            left: _w * _PortraitV11Layout.frontInstituteLeft,
            right: _w * _PortraitV11Layout.frontInstituteRight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: 0.3,
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
            borderWidth: _PortraitV11Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV11Layout.frontContentSide,
          right: _w * _PortraitV11Layout.frontContentSide,
          bottom: _h * _PortraitV11Layout.frontContentBottomRatio,
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
                    child: _PortraitV11FrontColumn(
                      studentName: data.studentName,
                      fatherName: data.fatherName,
                      className: data.className,
                      detailLines: _frontDetailLines(),
                      validFrom: '',
                      validTo: '',
                      nameStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: _PortraitV11Layout.frontNameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: 0.45,
                      )),
                      nameMinFontSize: _PortraitV11Layout.frontNameMinFontSize,
                      fatherStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: _PortraitV11Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        letterSpacing: 0.35,
                      )),
                      courseStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: _PortraitV11Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: 0.35,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: _PortraitV11Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                        letterSpacing: 0.35,
                      )),
                      bodyMinFontSize: _PortraitV11Layout.frontBodyMinFontSize,
                      validityLabelStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.35,
                      )),
                      validityValueStyle: _ts(const TextStyle(
                        color: _PortraitV11Layout.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.35,
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
          StudentIdTemplateAssets.backBackgroundV11,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV11Layout.backInstituteTop,
            height: _h * _PortraitV11Layout.backInstituteHeight,
            left: _w * _PortraitV11Layout.backInstituteLeft,
            right: _w * _PortraitV11Layout.backInstituteRight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: 0.35,
                )),
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV11Layout.backTermsTop,
            left: _w * _PortraitV11Layout.backTermsSide,
            right: _w * _PortraitV11Layout.backTermsSide,
            bottom: _h * _PortraitV11Layout.backTermsBottom,
            child: _PortraitV11TealBulletedTerms(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _PortraitV11Layout.textDark,
                fontSize: _PortraitV11Layout.backTermsFontSize,
                fontWeight: FontWeight.w700,
                height: 1.34,
                letterSpacing: 0.35,
              )),
              minFontSize: _PortraitV11Layout.backTermsMinFontSize,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
            ),
          ),
      ],
    );
  }
}

class _PortraitV11FrontColumn extends StatelessWidget {
  const _PortraitV11FrontColumn({
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

    final name = studentName.trim();
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 36) * 1.08,
      );
    }

    final father = fatherName.trim();
    if (father.isNotEmpty) {
      add(
        AutoSizeText(
          father.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: fatherStyle,
        ),
        (fatherStyle.fontSize ?? 22) * 1.2,
      );
    }

    final course = className.trim();
    if (course.isNotEmpty) {
      add(
        AutoSizeText(
          course.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: courseStyle,
        ),
        (courseStyle.fontSize ?? 22) * 1.15,
      );
    }

    for (final line in detailLines) {
      add(
        AutoSizeText(
          line,
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 22) * 1.24,
      );
    }

    if (validFrom.isNotEmpty) {
      add(
        _PortraitV11ValidityRow(
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
        _PortraitV11ValidityRow(
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
        ? _PortraitV11Layout.frontLineGapCompactMin
        : _PortraitV11Layout.frontLineGapMin;
    var gapMax = compactSpacing
        ? _PortraitV11Layout.frontLineGapCompactMax
        : _PortraitV11Layout.frontLineGapMax;
    if (relaxedSpacing) {
      gapMin = _PortraitV11Layout.frontLineGapRelaxedMin;
      gapMax = _PortraitV11Layout.frontLineGapRelaxedMax;
    }

    final estTotal = estimates.fold(0.0, (a, b) => a + b);
    if (estTotal > maxHeight * 0.82) {
      gapMin = 4;
      gapMax = 9;
    }
    final free = (maxHeight - estTotal).clamp(0.0, double.infinity);
    var gap = ((free / gapCount) * _PortraitV11Layout.frontLineGapSpread)
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

class _PortraitV11ValidityRow extends StatelessWidget {
  const _PortraitV11ValidityRow({
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

class _PortraitV11TealBulletedTerms extends StatelessWidget {
  const _PortraitV11TealBulletedTerms({
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
                    width: _PortraitV11Layout.backBulletSize,
                    height: _PortraitV11Layout.backBulletSize,
                    decoration: const BoxDecoration(
                      color: _PortraitV11Layout.accentTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV11Layout.backBulletGap),
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
