import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 16 — elephant landscape card; front only; main form fields only.
abstract final class _LandscapeV16Layout {
  static const Color schoolBlue = Color(0xFF0F2B5B);
  static const Color textGreen = Color(0xFF15803D);
  static const Color photoBorderRed = Color(0xFFE53935);

  static const double headerTop = 0.035;
  static const double headerLeft = 0.05;
  static const double headerRight = 0.05;
  static const double headerHeight = 0.20;

  static const double nameTop = 0.25;
  static const double nameLeft = 0.34;
  static const double nameRight = 0.26;

  static const double detailsTop = 0.36;
  static const double detailsLeft = 0.34;
  static const double detailsRight = 0.26;
  static const double detailsBottom = 0.08;

  static const double photoTop = 0.24;
  static const double photoRight = 0.05;
  static const double photoSize = 0.38;
  static const double photoBorderWidth = 3.0;

  static const double signatureRight = 0.05;
  static const double signatureBottom = 0.04;
  static const double signatureSizeRatio = 0.24;
}

class StudentIdTemplateLandscapeV16 extends StatelessWidget {
  const StudentIdTemplateLandscapeV16({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardDimensions.width;
  static const double _h = IdCardDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);
  TextStyle _tsPrimary(TextStyle base) =>
      studentPortraitPrimaryTextStyle(base, fontFamily);

  static String _cap(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '';
    return s
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static int _instituteMaxLines(String name) {
    if (name.contains('\n')) {
      final lines = name.split('\n').where((s) => s.trim().isNotEmpty).length;
      return lines.clamp(2, 4);
    }
    return 2;
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
    if (side == StudentIdCardSide.back) {
      return const SizedBox(width: _w, height: _h);
    }
    return SizedBox(
      width: _w,
      height: _h,
      child: _buildFront(),
    );
  }

  Widget _buildFront() {
    final detailLines = _frontDetailLines();
    final photoDiameter = _h * _LandscapeV16Layout.photoSize;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV16,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV16Layout.headerTop,
            left: _w * _LandscapeV16Layout.headerLeft,
            right: _w * _LandscapeV16Layout.headerRight,
            height: _h * _LandscapeV16Layout.headerHeight,
            child: _LandscapeV16Header(
              instituteName: data.instituteName.trim(),
              schoolStyle: _ts(const TextStyle(
                color: _LandscapeV16Layout.schoolBlue,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                height: 1.02,
              )),
              instituteMaxLines: _instituteMaxLines(data.instituteName),
              minFontSize: 14,
            ),
          ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV16Layout.nameTop,
            left: _w * _LandscapeV16Layout.nameLeft,
            right: _w * _LandscapeV16Layout.nameRight,
            child: AutoSizeText(
              _cap(data.studentName),
              maxLines: 2,
              minFontSize: IdCardPortraitTypography.nameMinFontSize,
              textAlign: TextAlign.left,
              style: _tsPrimary(const TextStyle(
                color: _LandscapeV16Layout.textGreen,
                fontSize: IdCardPortraitTypography.nameFontSize,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: 0.35,
              )),
            ),
          ),
        Positioned(
          top: _h * _LandscapeV16Layout.detailsTop,
          left: _w * _LandscapeV16Layout.detailsLeft,
          right: _w * _LandscapeV16Layout.detailsRight,
          bottom: _h * _LandscapeV16Layout.detailsBottom,
          child: _LandscapeV16FrontContent(
            fatherName: data.fatherName,
            className: data.className,
            detailLines: detailLines,
            fatherStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            courseStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            bodyStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            nameMinFontSize: IdCardPortraitTypography.nameMinFontSize,
            bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),
        Positioned(
          top: _h * _LandscapeV16Layout.photoTop,
          right: _w * _LandscapeV16Layout.photoRight,
          child: StudentPortraitPhoto(
            photoPath: data.photoPath,
            size: photoDiameter,
            borderColor: _LandscapeV16Layout.photoBorderRed,
            borderWidth: _LandscapeV16Layout.photoBorderWidth,
            padding: 2,
            showShadow: false,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * _LandscapeV16Layout.signatureRight,
            bottom: _h * _LandscapeV16Layout.signatureBottom,
            child: StudentPortraitSignatureCircle(
              size: _h * _LandscapeV16Layout.signatureSizeRatio,
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
}

class _LandscapeV16Header extends StatelessWidget {
  const _LandscapeV16Header({
    required this.instituteName,
    required this.schoolStyle,
    required this.instituteMaxLines,
    required this.minFontSize,
  });

  final String instituteName;
  final TextStyle schoolStyle;
  final int instituteMaxLines;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    if (instituteName.isEmpty) return const SizedBox.shrink();

    return Center(
      child: AutoSizeText(
        formatInstituteName(instituteName.toUpperCase()),
        maxLines: instituteMaxLines,
        minFontSize: minFontSize,
        textAlign: TextAlign.center,
        style: schoolStyle,
      ),
    );
  }
}

class _LandscapeV16FrontContent extends StatelessWidget {
  const _LandscapeV16FrontContent({
    required this.fatherName,
    required this.className,
    required this.detailLines,
    required this.fatherStyle,
    required this.courseStyle,
    required this.bodyStyle,
    required this.nameMinFontSize,
    required this.bodyMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final String fatherName;
  final String className;
  final List<String> detailLines;
  final TextStyle fatherStyle;
  final TextStyle courseStyle;
  final TextStyle bodyStyle;
  final double nameMinFontSize;
  final double bodyMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

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
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    final father = _cap(fatherName);
    if (father.isNotEmpty) {
      add(
        AutoSizeText(
          father,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.left,
          style: fatherStyle,
        ),
        (fatherStyle.fontSize ?? 42) * 1.08,
      );
    }

    final course = _cap(className);
    if (course.isNotEmpty) {
      add(
        AutoSizeText(
          course,
          maxLines: 1,
          minFontSize: nameMinFontSize,
          textAlign: TextAlign.left,
          style: courseStyle,
        ),
        (courseStyle.fontSize ?? 42) * 1.08,
      );
    }

    for (final line in detailLines) {
      add(
        AutoSizeText(
          _cap(line),
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.left,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 32) * 1.25,
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    final gapCount = blocks.length - 1;
    if (gapCount <= 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final estTotal = estimates.fold(0.0, (a, b) => a + b);
        final free =
            (constraints.maxHeight - estTotal).clamp(0.0, double.infinity);

        var gapMin = compactSpacing ? 3.0 : 5.0;
        var gapMax = compactSpacing ? 8.0 : 12.0;
        if (relaxedSpacing) {
          gapMin = 7.0;
          gapMax = 16.0;
        }

        var gap = (free / gapCount).clamp(gapMin, gapMax);
        if (estTotal + gap * gapCount > constraints.maxHeight) {
          gap =
              ((constraints.maxHeight - estTotal) / gapCount).clamp(2.0, gapMax);
        }

        final children = <Widget>[];
        for (var i = 0; i < blocks.length; i++) {
          if (i > 0) children.add(SizedBox(height: gap));
          children.add(blocks[i]);
        }

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
