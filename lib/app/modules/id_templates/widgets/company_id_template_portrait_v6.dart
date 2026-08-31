import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_text_styles.dart';
import '../design_system/id_card_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 6 — navy / orange geometric theme, rounded-rect photo.
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV6Layout {
  /// Decorative only (bullet dots) — never text.
  static const Color accentOrange = Color(0xFFF97316);

  static const double headerBrandTop = 0.04;
  static const double headerBrandHeight = 0.08;
  static const double headerBrandSide = 0.05;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;

  static const double frontPhotoWidthRatio = 0.40;
  static const double frontPhotoAspect = 1.18;
  static const double frontPhotoTopRatio = 0.17;
  static const double frontPhotoRadius = 14.0;
  static const double frontGapBelowPhoto = 18.0;
  static const double frontContentSide = 0.18;
  static const double frontContentBottomRatio = 0.10;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 18.0;

  static const double backBrandTop = 0.058;
  static const double backBrandHeight = 0.085;

  static const double backTermsTop = 0.155;
  static const double backTermsSide = 0.16;
  static const double backTermsBottom = 0.50;

  static const double backDatesTop = 0.46;
  static const double backDatesHeight = 0.09;
  static const double backDatesSide = 0.16;
}

class CompanyIdTemplatePortraitV6 extends StatelessWidget {
  const CompanyIdTemplatePortraitV6({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
  });

  final EmployeeData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;

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
    final photoW = _w * _CompanyV6Layout.frontPhotoWidthRatio;
    final photoH = photoW * _CompanyV6Layout.frontPhotoAspect;
    final photoTop = _h * _CompanyV6Layout.frontPhotoTopRatio;
    final photoLeft = (_w - photoW) / 2;
    final contentTop = photoTop + photoH + _CompanyV6Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV6,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV6Layout.headerBrandTop,
          height: _h * _CompanyV6Layout.headerBrandHeight,
          left: _w * _CompanyV6Layout.headerBrandSide,
          right: _w * _CompanyV6Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV6BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle:
                  IdCardTextStyles.instituteHeader(fontFamily, onBanner: false),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoW,
          height: photoH,
          child: _CompanyV6RoundedPhoto(
            photoPath: data.photoPath,
            width: photoW,
            height: photoH,
            radius: _CompanyV6Layout.frontPhotoRadius,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV6Layout.frontContentSide,
          right: _w * _CompanyV6Layout.frontContentSide,
          bottom: _h * _CompanyV6Layout.frontContentBottomRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: _CompanyV6FrontBody(
                      data: data,
                      nameStyle: IdCardTextStyles.personName(fontFamily),
                      titleStyle: IdCardTextStyles.position(fontFamily),
                      bodyStyle: IdCardTextStyles.detail(fontFamily),
                      bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
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
    final dates = <String>[];
    void addDate(String value) {
      final v = value.trim();
      if (v.isNotEmpty) dates.add(v);
    }

    addDate(data.joinDate);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV6,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV6Layout.backBrandTop,
          height: _h * _CompanyV6Layout.backBrandHeight,
          left: _w * 0.05,
          right: _w * 0.05,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV6BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle:
                  IdCardTextStyles.instituteHeader(fontFamily, onBanner: false),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV6Layout.backTermsTop,
            left: _w * _CompanyV6Layout.backTermsSide,
            right: _w * _CompanyV6Layout.backTermsSide,
            bottom: _h * _CompanyV6Layout.backTermsBottom,
            child: _CompanyV6CircleBullets(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 13,
            ),
          ),
        if (dates.isNotEmpty)
          Positioned(
            top: _h * _CompanyV6Layout.backDatesTop,
            left: _w * _CompanyV6Layout.backDatesSide,
            right: _w * _CompanyV6Layout.backDatesSide,
            height: _h * _CompanyV6Layout.backDatesHeight,
            child: _CompanyV6CenteredLines(
              lines: dates,
              style: IdCardTextStyles.backBody(fontFamily),
              minFontSize: 14,
            ),
          ),

      ],
    );
  }
}

class _CompanyV6BrandRow extends StatelessWidget {
  const _CompanyV6BrandRow({
    required this.companyName,
    required this.logoAsset,
    required this.nameStyle,
    required this.minNameSize,
  });

  final String companyName;
  final String logoAsset;
  final TextStyle nameStyle;
  final double minNameSize;

  @override
  Widget build(BuildContext context) {
    final name = companyName.trim();
    final logo = logoAsset.trim();
    final hasLogo = logo.isNotEmpty && !logo.contains('hexagon');

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasLogo) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              logo,
              width: _CompanyV6Layout.logoSize,
              height: _CompanyV6Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV6Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: AutoSizeText(
              IdCardTypography.formatInstituteName(name.toUpperCase()),
              maxLines: 2,
              minFontSize: 14,
              textAlign: TextAlign.center,
              style: nameStyle,
            ),
          ),
      ],
    );
  }
}

class _CompanyV6RoundedPhoto extends StatelessWidget {
  const _CompanyV6RoundedPhoto({
    required this.photoPath,
    required this.width,
    required this.height,
    required this.radius,
  });

  final String photoPath;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(
          Icons.person,
          size: width * 0.35,
          color: const Color(0xFF94A3B8),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(
        Icons.person,
        size: width * 0.35,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}

class _CompanyV6FrontBody extends StatelessWidget {
  const _CompanyV6FrontBody({
    required this.data,
    required this.nameStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.bodyMinFontSize,
  });

  final EmployeeData data;
  final TextStyle nameStyle;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    final name = data.employeeName.trim();
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 2,
          minFontSize: bodyMinFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 36) * 1.1,
      );
    }

    final title = data.position.trim();
    if (title.isNotEmpty) {
      add(
        AutoSizeText(
          title.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        (titleStyle.fontSize ?? 21) * 1.15,
      );
    }

    final detailLines = data.frontDetailLines;
    for (var i = 0; i < detailLines.length; i++) {
      final line = detailLines[i];
      final isEmail = line.contains('@');
      final isStudentProminentLine = data.isStudentData && i < 2;
      final lineStyle = isStudentProminentLine ? nameStyle : bodyStyle;
      final lineMinFont =
          isStudentProminentLine ? (bodyMinFontSize + 4) : bodyMinFontSize;

      add(
        AutoSizeText(
          line,
          maxLines: isEmail ? 2 : 1,
          minFontSize: lineMinFont,
          textAlign: TextAlign.center,
          style: lineStyle,
        ),
        (lineStyle.fontSize ?? 22) *
            (isEmail ? 1.45 : (isStudentProminentLine ? 1.08 : 1.22)),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final estTotal = estimates.fold(0.0, (a, b) => a + b);
        final free =
            (constraints.maxHeight - estTotal).clamp(0.0, double.infinity);
        final gap = (free / gapCount).clamp(
          _CompanyV6Layout.frontLineGapMin,
          _CompanyV6Layout.frontLineGapMax,
        );

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
      },
    );
  }
}

class _CompanyV6CircleBullets extends StatelessWidget {
  const _CompanyV6CircleBullets({
    required this.lines,
    required this.textStyle,
    required this.minFontSize,
  });

  final List<String> lines;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: _CompanyV6Layout.accentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  lines[i],
                  maxLines: 5,
                  minFontSize: minFontSize,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CompanyV6CenteredLines extends StatelessWidget {
  const _CompanyV6CenteredLines({
    required this.lines,
    required this.style,
    required this.minFontSize,
  });

  final List<String> lines;
  final TextStyle style;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const SizedBox(height: 6),
          AutoSizeText(
            lines[i],
            maxLines: 1,
            minFontSize: minFontSize,
            textAlign: TextAlign.center,
            style: style,
          ),
        ],
      ],
    );
  }
}
