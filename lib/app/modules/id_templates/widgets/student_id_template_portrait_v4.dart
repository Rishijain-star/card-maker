import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Layout for 4th portrait PNG (1024×1536 → 638×1012).
/// Ref: diagonal header, hex photo on seam, centered name/body; back cyan bullets.
abstract final class _PortraitV4Layout {
  static const double frontInstituteTop = 0.042;
  static const double frontInstituteHeight = 0.10;
  static const double frontInstituteSide = 0.08;

  static const double frontPhotoWidthRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.262; // nudge down + gap from institute
  static const double frontPhotoBorderWidth = 7.0;
  static const double frontPhotoHeightFactor = 1.12;

  static const double frontFatherHeightRatio = 0.04;
  static const double frontCourseHeightRatio = 0.045;
  static const double frontGapBelowHex = 28.0;
  static const double frontNameHeightRatio = 0.048;
  static const double frontFatherGapBelowName = 6.0;
  static const double frontCourseGapBelowFather = 6.0;
  static const double frontBodyGapBelowCourse = 10.0;
  static const double frontContentSide = 0.10;

  static const double frontBodyLineGapBoost = 3.0;
  static const double frontBodyBottomRatio = 0.12;

  static const double frontSignatureSizeRatio = 0.11;
  static const double frontSignatureRightRatio = 0.06;
  static const double frontSignatureBottomRatio = 0.12;

  static const double backInstituteTop = 0.055;
  static const double backInstituteHeight = 0.11;
  static const double backInstituteLeft = 0.10;
  static const double backInstituteRight = 0.38;

  static const double backTermsTop = 0.30;
  static const double backTermsLeft = 0.10;
  static const double backTermsRight = 0.10;
  static const double backTermsBottom = 0.28;

  static const double backBulletSize = 14.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV4 extends StatelessWidget {
  const StudentIdTemplatePortraitV4({
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
    final photoW = _w * _PortraitV4Layout.frontPhotoWidthRatio;
    final photoH = photoW * _PortraitV4Layout.frontPhotoHeightFactor;
    final photoTop =
        _h * _PortraitV4Layout.frontPhotoCenterYRatio - photoH / 2;
    final photoLeft = (_w - photoW) / 2;
    final hexBottom = photoTop + photoH;
    final nameH = _h * _PortraitV4Layout.frontNameHeightRatio;
    final fatherH = _h * _PortraitV4Layout.frontFatherHeightRatio;
    final courseH = _h * _PortraitV4Layout.frontCourseHeightRatio;

    var y = hexBottom + _PortraitV4Layout.frontGapBelowHex;
    final nameTop = y;
    if (data.studentName.trim().isNotEmpty) {
      y += nameH + _PortraitV4Layout.frontFatherGapBelowName;
    }
    final fatherTop = y;
    if (data.fatherName.trim().isNotEmpty) {
      y += fatherH + _PortraitV4Layout.frontCourseGapBelowFather;
    }
    final courseTop = y;
    if (data.className.trim().isNotEmpty) {
      y += courseH + _PortraitV4Layout.frontBodyGapBelowCourse;
    }
    final bodyTop = y;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV4,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV4Layout.frontInstituteTop,
            height: _h * _PortraitV4Layout.frontInstituteHeight,
            left: _w * _PortraitV4Layout.frontInstituteSide,
            right: _w * _PortraitV4Layout.frontInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: 0.5,
                )),
              ),
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoW,
          height: photoH,
          child: StudentPortraitHexagonPhoto(
            photoPath: data.photoPath,
            width: photoW,
            borderColor: StudentPortraitTemplate4Colors.accentCyan,
            borderWidth: _PortraitV4Layout.frontPhotoBorderWidth,
            heightFactor: _PortraitV4Layout.frontPhotoHeightFactor,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: nameTop,
            height: nameH,
            left: _w * _PortraitV4Layout.frontContentSide,
            right: _w * _PortraitV4Layout.frontContentSide,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                data.studentName.trim().toUpperCase(),
                maxLines: 1,
                minFontSize: IdCardPortraitTypography.nameMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: IdCardPortraitTypography.nameFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                )),
              ),
            ),
          ),
        if (data.fatherName.trim().isNotEmpty)
          Positioned(
            top: fatherTop,
            height: fatherH,
            left: _w * _PortraitV4Layout.frontContentSide,
            right: _w * _PortraitV4Layout.frontContentSide,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                data.fatherName.trim().toUpperCase(),
                maxLines: 1,
                minFontSize: IdCardPortraitTypography.bodyMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: IdCardPortraitTypography.bodyFontSize,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                )),
              ),
            ),
          ),
        if (data.className.trim().isNotEmpty)
          Positioned(
            top: courseTop,
            height: courseH,
            left: _w * _PortraitV4Layout.frontContentSide,
            right: _w * _PortraitV4Layout.frontContentSide,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                data.className.trim().toUpperCase(),
                maxLines: 1,
                minFontSize: IdCardPortraitTypography.bodyMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: IdCardPortraitTypography.bodyFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                )),
              ),
            ),
          ),
        Positioned(
          top: bodyTop,
          left: _w * _PortraitV4Layout.frontContentSide,
          right: _w * _PortraitV4Layout.frontContentSide,
          bottom: _h * _PortraitV4Layout.frontBodyBottomRatio,
          child: _PortraitV4BodyList(
            lines: _frontDetailLines(),
            footerLine: data.frontValidityHorizontalLine,
            bodyStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w600,
              height: 1.28,
            )),
            bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
            footerStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: IdCardPortraitTypography.validityFontSize,
              fontWeight: FontWeight.w800,
              height: 1.2,
            )),
            footerMinFontSize: IdCardPortraitTypography.validityMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.035,
            bottom: _h * 0.035,
            child: StudentPortraitSignatureCircle(
              size: _w * 0.08,
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
          StudentIdTemplateAssets.backBackgroundV4,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV4Layout.backInstituteTop,
            height: _h * _PortraitV4Layout.backInstituteHeight,
            left: _w * _PortraitV4Layout.backInstituteLeft,
            right: _w * _PortraitV4Layout.backInstituteRight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.backHeaderFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                )),
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV4Layout.backTermsTop,
            left: _w * _PortraitV4Layout.backTermsLeft,
            right: _w * _PortraitV4Layout.backTermsRight,
            bottom: _h * _PortraitV4Layout.backTermsBottom,
            child: _PortraitV4BulletedTerms(
              lines: terms,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
              textStyle: _ts(const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: IdCardPortraitTypography.backBodyFontSize,
                fontWeight: FontWeight.w600,
                height: 1.35,
              )),
              minFontSize: IdCardPortraitTypography.backBodyMinFontSize,
            ),
          ),
      ],
    );
  }
}

class _PortraitV4BodyList extends StatelessWidget {
  const _PortraitV4BodyList({
    required this.lines,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
  });

  final List<String> lines;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    for (final line in lines) {
      blocks.add(AutoSizeText(
        line,
        maxLines: 2,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.center,
        style: bodyStyle,
      ));
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(AutoSizeText(
        footer,
        maxLines: 1,
        minFontSize: footerMinFontSize,
        textAlign: TextAlign.center,
        style: footerStyle,
      ));
    }

    if (blocks.isEmpty) return const SizedBox.shrink();
    if (blocks.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: blocks,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final gapCount = blocks.length - 1;
      final boost = _PortraitV4Layout.frontBodyLineGapBoost;
      final eGapMin = (compactSpacing
              ? 6.0
              : relaxedSpacing
                  ? IdCardPortraitTypography.frontGapRelaxedMin
                  : IdCardPortraitTypography.frontGapMin) +
          boost;
      final eGapMax = (compactSpacing
              ? 12.0
              : relaxedSpacing
                  ? IdCardPortraitTypography.frontGapRelaxedMax
                  : IdCardPortraitTypography.frontGapMax) +
          boost;
      final spread = compactSpacing
          ? 0.78
          : relaxedSpacing
              ? IdCardPortraitTypography.frontGapRelaxedSpread
              : IdCardPortraitTypography.frontGapSpread;

      final bodySize =
          bodyStyle.fontSize ?? IdCardPortraitTypography.bodyFontSize;
      final estContent = blocks.length * bodySize * 1.28;
      final free =
          (constraints.maxHeight - estContent).clamp(0.0, double.infinity);
      final gap = ((free / gapCount) * spread).clamp(eGapMin, eGapMax);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      );
    });
  }
}

class _PortraitV4BulletedTerms extends StatelessWidget {
  const _PortraitV4BulletedTerms({
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
                ? 22.0
                : IdCardPortraitTypography.backGapMin;
        final gapMax = compactSpacing
            ? 16.0
            : relaxedSpacing
                ? 32.0
                : IdCardPortraitTypography.backGapMax;

        final est = lines.length * (textStyle.fontSize ?? 27) * 1.4;
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
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: _PortraitV4Layout.backBulletSize,
                    height: _PortraitV4Layout.backBulletSize,
                    decoration: const BoxDecoration(
                      color: StudentPortraitTemplate4Colors.accentCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV4Layout.backBulletGap),
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
