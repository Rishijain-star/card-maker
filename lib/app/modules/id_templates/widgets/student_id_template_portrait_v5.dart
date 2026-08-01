import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 5 — navy header, orange ring photo, centered body (1024×1536 → 638×1012).
abstract final class _PortraitV5Layout {
  static const Color accentOrange = Color(0xFFF58B12);

  static const double frontInstituteTop = 0.070;
  static const double frontInstituteHeight = 0.075;
  static const double frontInstituteSide = 0.06;

  static const double frontPhotoSizeRatio = 0.38;
  static const double frontPhotoCenterYRatio = 0.340;
  static const double frontPhotoBorderWidth = 6.5;
  static const double frontGapBelowPhoto = 22.0;
  static const double frontContentSide = 0.10;
  static const double frontContentBottomRatio = 0.09;

  static const double frontSignatureSizeRatio = 0.11;
  static const double frontSignatureRightRatio = 0.06;
  static const double frontSignatureBottomRatio = 0.10;

  static const double backInstituteTop = 0.048;
  static const double backInstituteHeight = 0.095;
  static const double backInstituteLeft = 0.10;
  static const double backInstituteRight = 0.36;

  static const double backTermsTop = 0.175;
  static const double backTermsLeft = 0.10;
  static const double backTermsRight = 0.10;
  static const double backTermsBottom = 0.24;

  static const double backBulletSize = 14.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV5 extends StatelessWidget {
  const StudentIdTemplatePortraitV5({
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
    final photoSize = _w * _PortraitV5Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _PortraitV5Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop =
        photoTop + photoSize + _PortraitV5Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV5,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV5Layout.frontInstituteTop,
            height: _h * _PortraitV5Layout.frontInstituteHeight,
            left: _w * _PortraitV5Layout.frontInstituteSide,
            right: _w * _PortraitV5Layout.frontInstituteSide,
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
            borderColor: _PortraitV5Layout.accentOrange,
            borderWidth: _PortraitV5Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV5Layout.frontContentSide,
          right: _w * _PortraitV5Layout.frontContentSide,
          bottom: _h * _PortraitV5Layout.frontContentBottomRatio,
          child: _PortraitV5FrontContent(
            studentName: data.studentName,
            fatherName: data.fatherName,
            className: data.className,
            detailLines: _frontDetailLines(),
            footerLine: data.frontValidityHorizontalLine,
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
              fontWeight: FontWeight.w500,
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
            right: _w * _PortraitV5Layout.frontSignatureRightRatio,
            bottom: _h * _PortraitV5Layout.frontSignatureBottomRatio,
            child: StudentPortraitSignatureCircle(
              size: _w * _PortraitV5Layout.frontSignatureSizeRatio,
              path: data.signaturePath,
              bytes: data.signatureBytes,
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
          StudentIdTemplateAssets.backBackgroundV5,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV5Layout.backInstituteTop,
            height: _h * _PortraitV5Layout.backInstituteHeight,
            left: _w * _PortraitV5Layout.backInstituteLeft,
            right: _w * _PortraitV5Layout.backInstituteRight,
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
            top: _h * _PortraitV5Layout.backTermsTop,
            left: _w * _PortraitV5Layout.backTermsLeft,
            right: _w * _PortraitV5Layout.backTermsRight,
            bottom: _h * _PortraitV5Layout.backTermsBottom,
            child: _PortraitV5BulletedTerms(
              lines: terms,
              bulletColor: _PortraitV5Layout.accentOrange,
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

/// Name + course + details in one column — gaps shrink to fit (no overflow).
class _PortraitV5FrontContent extends StatelessWidget {
  const _PortraitV5FrontContent({
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
    required this.footerStyle,
    required this.footerMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
    this.footerLine,
  });

  final String studentName;
  final String fatherName;
  final String className;
  final List<String> detailLines;
  final String? footerLine;
  final TextStyle nameStyle;
  final double nameMinFontSize;
  final TextStyle fatherStyle;
  final TextStyle courseStyle;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final TextStyle footerStyle;
  final double footerMinFontSize;
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

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty) {
      addBlock(
        AutoSizeText(
          footer,
          maxLines: 1,
          minFontSize: footerMinFontSize,
          textAlign: TextAlign.center,
          style: footerStyle,
        ),
        (footerStyle.fontSize ?? 17) * 1.2,
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
        final free = (constraints.maxHeight - estTotal).clamp(0.0, double.infinity);

        var gapMin = compactSpacing ? 5.0 : 10.0;
        var gapMax = compactSpacing ? 10.0 : 18.0;
        if (relaxedSpacing) {
          gapMin = 12.0;
          gapMax = 22.0;
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

        final column = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth,
            child: column,
          ),
        );
      },
    );
  }
}

class _PortraitV5BulletedTerms extends StatelessWidget {
  const _PortraitV5BulletedTerms({
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
            ? 18.0
            : relaxedSpacing
                ? 30.0
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
                    width: _PortraitV5Layout.backBulletSize,
                    height: _PortraitV5Layout.backBulletSize,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV5Layout.backBulletGap),
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
