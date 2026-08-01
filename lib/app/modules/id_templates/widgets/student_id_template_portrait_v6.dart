import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 6 — wave navy/blue PNG, white ring photo, centered body (1024×1536 → 638×1012).
abstract final class _PortraitV6Layout {
  static const Color accentBlue = Color(0xFF1E9AD6);

  static const double frontInstituteTop = 0.065;
  static const double frontInstituteHeight = 0.075;
  static const double frontInstituteSide = 0.06;

  static const double frontPhotoSizeRatio = 0.37;
  static const double frontPhotoCenterYRatio = 0.320;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 24.0;
  static const double frontContentSide = 0.10;
  static const double frontContentBottomRatio = 0.16;

  static const double frontSignatureSizeRatio = 0.10;
  static const double frontSignatureRightRatio = 0.06;
  static const double frontSignatureBottomRatio = 0.17;

  static const double backInstituteTop = 0.19;
  static const double backInstituteHeight = 0.09;
  static const double backInstituteLeft = 0.12;
  static const double backInstituteRight = 0.28;

  static const double backTermsTop = 0.285;
  static const double backTermsLeft = 0.12;
  static const double backTermsRight = 0.10;
  static const double backTermsBottom = 0.20;

  static const double backBulletSize = 14.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV6 extends StatelessWidget {
  const StudentIdTemplatePortraitV6({
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
    final photoSize = _w * _PortraitV6Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _PortraitV6Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop =
        photoTop + photoSize + _PortraitV6Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV6,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV6Layout.frontInstituteTop,
            height: _h * _PortraitV6Layout.frontInstituteHeight,
            left: _w * _PortraitV6Layout.frontInstituteSide,
            right: _w * _PortraitV6Layout.frontInstituteSide,
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
            borderWidth: _PortraitV6Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV6Layout.frontContentSide,
          right: _w * _PortraitV6Layout.frontContentSide,
          bottom: _h * _PortraitV6Layout.frontContentBottomRatio,
          child: _PortraitV6FrontContent(
            studentName: data.studentName,
            fatherName: data.fatherName,
            className: data.className,
            detailLines: _frontDetailLines(),
            nameStyle: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
            )),
            nameMinFontSize: IdCardPortraitTypography.nameMinFontSize,
            fatherStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            )),
            courseStyle: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w800,
              height: 1.15,
            )),
            bodyStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w600,
              height: 1.26,
            )),
            bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
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
          StudentIdTemplateAssets.backBackgroundV6,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV6Layout.backInstituteTop,
            height: _h * _PortraitV6Layout.backInstituteHeight,
            left: _w * _PortraitV6Layout.backInstituteLeft,
            right: _w * _PortraitV6Layout.backInstituteRight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: IdCardPortraitTypography.backHeaderFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                )),
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV6Layout.backTermsTop,
            left: _w * _PortraitV6Layout.backTermsLeft,
            right: _w * _PortraitV6Layout.backTermsRight,
            bottom: _h * _PortraitV6Layout.backTermsBottom,
            child: _PortraitV6BulletedTerms(
              lines: terms,
              bulletColor: _PortraitV6Layout.accentBlue,
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

class _PortraitV6FrontContent extends StatelessWidget {
  const _PortraitV6FrontContent({
    required this.studentName,
    required this.fatherName,
    required this.className,
    required this.detailLines,
    required this.nameStyle,
    required this.nameMinFontSize,
    required this.fatherStyle,
    required this.courseStyle,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final String studentName;
  final String fatherName;
  final String className;
  final List<String> detailLines;
  final TextStyle nameStyle;
  final double nameMinFontSize;
  final TextStyle fatherStyle;
  final TextStyle courseStyle;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final estimates = <double>[];

    void addBlock(Widget w, double estH) {
      blocks.add(w);
      estimates.add(estH);
    }

    final name = studentName.trim();
    if (name.isNotEmpty) {
      addBlock(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 40) * 1.08,
      );
    }

    final father = fatherName.trim();
    if (father.isNotEmpty) {
      addBlock(
        AutoSizeText(
          father.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: fatherStyle,
        ),
        (fatherStyle.fontSize ?? 27) * 1.2,
      );
    }

    final course = className.trim();
    if (course.isNotEmpty) {
      addBlock(
        AutoSizeText(
          course.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: courseStyle,
        ),
        (courseStyle.fontSize ?? 27) * 1.15,
      );
    }

    for (final line in detailLines) {
      addBlock(
        AutoSizeText(
          line,
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 27) * 1.26,
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gapCount = blocks.length - 1;
        if (gapCount <= 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: blocks,
          );
        }

        final estTotal = estimates.fold(0.0, (a, b) => a + b);
        final free =
            (constraints.maxHeight - estTotal).clamp(0.0, double.infinity);

        var gapMin = compactSpacing ? 5.0 : 10.0;
        var gapMax = compactSpacing ? 10.0 : 17.0;
        if (relaxedSpacing) {
          gapMin = 12.0;
          gapMax = 21.0;
        }

        var gap = (free / gapCount).clamp(gapMin, gapMax);
        if (estTotal + gap * gapCount > constraints.maxHeight) {
          gap = ((constraints.maxHeight - estTotal) / gapCount)
              .clamp(3.0, gapMax);
        }

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
      },
    );
  }
}

class _PortraitV6BulletedTerms extends StatelessWidget {
  const _PortraitV6BulletedTerms({
    required this.lines,
    required this.textStyle,
    required this.minFontSize,
    required this.bulletColor,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final List<String> lines;
  final TextStyle textStyle;
  final double minFontSize;
  final Color bulletColor;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gapMin = compactSpacing
            ? 12.0
            : relaxedSpacing
                ? 20.0
                : IdCardPortraitTypography.backGapMin;
        final gapMax = compactSpacing
            ? 17.0
            : relaxedSpacing
                ? 28.0
                : IdCardPortraitTypography.backGapMax;

        final est = lines.length * (textStyle.fontSize ?? 27) * 1.38;
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
                    width: _PortraitV6Layout.backBulletSize,
                    height: _PortraitV6Layout.backBulletSize,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV6Layout.backBulletGap),
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
