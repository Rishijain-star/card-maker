import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_text_styles.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 15 — deer / grass landscape card; front only; main form fields only.
abstract final class _LandscapeV15Layout {
  static const double headerTop = 0.035;
  static const double headerLeft = 0.21;
  static const double headerRight = 0.28;
  static const double headerHeight = 0.22;

  static const double photoTop = 0.10;
  static const double photoRight = 0.05;
  static const double photoWidth = 0.22;
  static const double photoHeight = 0.45;
  static const double photoRadius = 6.0;
  static const double photoBorderWidth = 2.5;

  static const double nameTop = 0.57;
  static const double nameRight = 0.03;
  static const double nameWidth = 0.26;

  static const double detailsTop = 0.26;
  static const double detailsLeft = 0.28;
  static const double detailsRight = 0.30;
  static const double detailsBottom = 0.10;
}

class StudentIdTemplateLandscapeV15 extends StatelessWidget {
  const StudentIdTemplateLandscapeV15({
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

  static String _cap(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '';
    return s
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
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
    // Optional terms removed completely for Template 15 (Single-sided card)
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV15,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV15Layout.headerTop,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
              color: Colors.black,
            ),
          ),
        Positioned(
          top: _h * _LandscapeV15Layout.photoTop,
          right: _w * _LandscapeV15Layout.photoRight,
          width: _w * _LandscapeV15Layout.photoWidth,
          height: _h * _LandscapeV15Layout.photoHeight,
          child: _LandscapeV15RectPhoto(
            photoPath: data.photoPath,
            borderWidth: _LandscapeV15Layout.photoBorderWidth,
            radius: _LandscapeV15Layout.photoRadius,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV15Layout.nameTop,
            right: _w * _LandscapeV15Layout.nameRight,
            width: _w * _LandscapeV15Layout.nameWidth,
            child: AutoSizeText(
              _cap(data.studentName),
              maxLines: 2,
              minFontSize: IdCardPortraitTypography.nameMinFontSize,
              textAlign: TextAlign.center,
              style: IdCardTextStyles.personName(fontFamily),
            ),
          ),
        Positioned(
          top: _h * _LandscapeV15Layout.detailsTop,
          left: _w * _LandscapeV15Layout.detailsLeft,
          right: _w * _LandscapeV15Layout.detailsRight,
          bottom: _h * _LandscapeV15Layout.detailsBottom,
          child: _LandscapeV15FrontContent(
            fatherName: data.fatherName,
            className: data.className,
            detailLines: detailLines,
            fatherStyle: IdCardTextStyles.fatherName(fontFamily),
            courseStyle: IdCardTextStyles.course(fontFamily),
            bodyStyle: IdCardTextStyles.detail(fontFamily),
            nameMinFontSize: IdCardPortraitTypography.nameMinFontSize,
            bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.04,
            bottom: _h * 0.03,
            child: StudentPortraitSignatureCircle(
              size: _h * 0.22,
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

class _LandscapeV15Header extends StatelessWidget {
  const _LandscapeV15Header({
    required this.instituteName,
    required this.instituteStyle,
    required this.instituteMaxLines,
    required this.minFontSize,
  });

  final String instituteName;
  final TextStyle instituteStyle;
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
        style: instituteStyle,
      ),
    );
  }
}

class _LandscapeV15RectPhoto extends StatelessWidget {
  const _LandscapeV15RectPhoto({
    required this.photoPath,
    required this.borderWidth,
    required this.radius,
  });

  final String photoPath;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final path = photoPath.trim();
    if (path.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFE0E0E0),
        child: Center(
          child: Icon(Icons.person, color: Color(0xFF9E9E9E), size: 48),
        ),
      );
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return const ColoredBox(
      color: Color(0xFFE0E0E0),
      child: Center(
        child: Icon(Icons.person, color: Color(0xFF9E9E9E), size: 48),
      ),
    );
  }
}

class _LandscapeV15FrontContent extends StatelessWidget {
  const _LandscapeV15FrontContent({
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
          textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 32) * 1.25,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final estTotal = estimates.fold(0.0, (a, b) => a + b);
        final free = (constraints.maxHeight - estTotal).clamp(0.0, double.infinity);

        var gapMin = compactSpacing ? 3.0 : 6.0;
        var gapMax = compactSpacing ? 8.0 : 14.0;
        if (relaxedSpacing) {
          gapMin = 8.0;
          gapMax = 18.0;
        }

        var gap = (free / gapCount).clamp(gapMin, gapMax);
        if (estTotal + gap * gapCount > constraints.maxHeight) {
          gap = ((constraints.maxHeight - estTotal) / gapCount).clamp(2.0, gapMax);
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
