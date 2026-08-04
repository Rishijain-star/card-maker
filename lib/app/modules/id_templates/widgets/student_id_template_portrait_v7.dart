import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 7 — navy/orange diagonal PNG, white hex, orange header text (1024×1536 → 638×1012).
abstract final class _PortraitV7Layout {
  static const Color accentOrange = Color(0xFFF58B12);

  static const double frontInstituteTop = 0.048;
  static const double frontInstituteHeight = 0.095;
  static const double frontInstituteSide = 0.08;

  static const double frontPhotoWidthRatio = 0.33;
  static const double frontPhotoCenterYRatio = 0.305;
  static const double frontPhotoBorderWidth = 5.0;
  static const double frontPhotoHeightFactor = 1.12;
  static const double frontGapBelowHex = 26.0;
  static const double frontContentSide = 0.10;
  static const double frontContentBottomRatio = 0.15;

  static const double backInstituteTop = 0.065;
  static const double backInstituteHeight = 0.10;
  static const double backInstituteSide = 0.10;

  /// Terms sit fully in white (below orange diagonal on PNG).
  static const double backTermsTop = 0.46;
  static const double backTermsLeft = 0.22;
  static const double backTermsRight = 0.30;
  static const double backTermsBottom = 0.24;
  static const double backTermsFontSize = 23;
  static const double backTermsMinFontSize = 14;

  static const double backValidityBottom = 0.13;
  static const double backValidityLeft = 0.20;
  static const double backValidityHeight = 0.10;

  static const double backBulletSize = 14.0;
  static const double backBulletGap = 12.0;
}

class StudentIdTemplatePortraitV7 extends StatelessWidget {
  const StudentIdTemplatePortraitV7({
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
    final photoW = _w * _PortraitV7Layout.frontPhotoWidthRatio;
    final photoH = photoW * _PortraitV7Layout.frontPhotoHeightFactor;
    final photoTop =
        _h * _PortraitV7Layout.frontPhotoCenterYRatio - photoH / 2;
    final photoLeft = (_w - photoW) / 2;
    final contentTop = photoTop + photoH + _PortraitV7Layout.frontGapBelowHex;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV7,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV7Layout.frontInstituteTop,
            height: _h * _PortraitV7Layout.frontInstituteHeight,
            left: _w * _PortraitV7Layout.frontInstituteSide,
            right: _w * _PortraitV7Layout.frontInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _PortraitV7Layout.accentOrange,
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
            borderColor: Colors.white,
            borderWidth: _PortraitV7Layout.frontPhotoBorderWidth,
            heightFactor: _PortraitV7Layout.frontPhotoHeightFactor,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV7Layout.frontContentSide,
          right: _w * _PortraitV7Layout.frontContentSide,
          bottom: _h * _PortraitV7Layout.frontContentBottomRatio,
          child: _PortraitV7FrontContent(
            studentName: data.studentName,
            fatherName: data.fatherName,
            className: data.className,
            detailLines: _frontDetailLines(),
            nameStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.05,
            )),
            nameMinFontSize: IdCardPortraitTypography.nameMinFontSize,
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
    final from = data.validFrom.trim();
    final to = data.validTo.trim();
    final hasValidity = from.isNotEmpty || to.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.backBackgroundV7,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV7Layout.backInstituteTop,
            height: _h * _PortraitV7Layout.backInstituteHeight,
            left: _w * _PortraitV7Layout.backInstituteSide,
            right: _w * _PortraitV7Layout.backInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _PortraitV7Layout.accentOrange,
                  fontSize: IdCardPortraitTypography.backHeaderFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: 0.4,
                  shadows: [
                    Shadow(
                      color: Color(0x66000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                )),
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV7Layout.backTermsTop,
            left: _w * _PortraitV7Layout.backTermsLeft,
            right: _w * _PortraitV7Layout.backTermsRight,
            bottom: _h * _PortraitV7Layout.backTermsBottom,
            child: _PortraitV7BulletedTerms(
              lines: terms,
              bulletColor: _PortraitV7Layout.accentOrange,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
              textStyle: _ts(const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: _PortraitV7Layout.backTermsFontSize,
                fontWeight: FontWeight.w700,
                height: 1.32,
                letterSpacing: 0.35,
              )),
              minFontSize: _PortraitV7Layout.backTermsMinFontSize,
            ),
          ),
        if (hasValidity)
          Positioned(
            left: _w * _PortraitV7Layout.backValidityLeft,
            bottom: _h * _PortraitV7Layout.backValidityBottom,
            height: _h * _PortraitV7Layout.backValidityHeight,
            right: _w * _PortraitV7Layout.backTermsRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (from.isNotEmpty) _backValidityRow('VALID FROM', from),
                if (from.isNotEmpty && to.isNotEmpty) const SizedBox(height: 10),
                if (to.isNotEmpty) _backValidityRow('VALID TILL', to),
              ],
            ),
          ),
      ],
    );
  }

  Widget _backValidityRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: _ts(const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          )),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: AutoSizeText(
            value,
            maxLines: 1,
            minFontSize: 13,
            style: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
          ),
        ),
      ],
    );
  }
}

class _PortraitV7FrontContent extends StatelessWidget {
  const _PortraitV7FrontContent({
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
      addBlock(
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
      addBlock(
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
      addBlock(
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
      addBlock(
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

class _PortraitV7BulletedTerms extends StatelessWidget {
  const _PortraitV7BulletedTerms({
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
                    width: _PortraitV7Layout.backBulletSize,
                    height: _PortraitV7Layout.backBulletSize,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: _PortraitV7Layout.backBulletGap),
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
