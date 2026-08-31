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

/// Company template 3 — blue wave theme (ref: 3rd company front/back PNGs).
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV3Layout {
  /// Decorative only (bullet squares) — never text.
  static const Color accentBlue = Color(0xFF0B55A4);

  static const double headerBrandTop = 0.048;
  static const double headerBrandHeight = 0.085;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;

  static const double frontPhotoSizeRatio = 0.46;
  static const double frontPhotoCenterYRatio = 0.292;
  static const double frontPhotoBorderWidth = 6.0;
  static const double frontGapBelowPhoto = 26.0;
  static const double frontContentMinTopRatio = 0.515;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.12;
  static const double frontLineGapMin = 7.0;
  static const double frontLineGapMax = 13.0;

  static const double backTermsTop = 0.10;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.58;

  static const double backDatesTop = 0.44;
  static const double backDatesHeight = 0.10;
  static const double backDatesSide = 0.12;

  static const double backFooterSide = 0.10;
}

class CompanyIdTemplatePortraitV3 extends StatelessWidget {
  const CompanyIdTemplatePortraitV3({
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
    final photoSize = _w * _CompanyV3Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV3Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV3Layout.frontGapBelowPhoto,
      _h * _CompanyV3Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV3,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV3Layout.headerBrandTop,
          height: _h * _CompanyV3Layout.headerBrandHeight,
          left: _w * _CompanyV3Layout.headerBrandSide,
          right: _w * _CompanyV3Layout.headerBrandSide,
          child: Align(
            alignment: const Alignment(0, 0.55),
            child: _CompanyV3BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
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
            borderWidth: _CompanyV3Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV3Layout.frontContentSide,
          right: _w * _CompanyV3Layout.frontContentSide,
          bottom: _h * _CompanyV3Layout.frontContentBottomRatio,
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
                    child: _CompanyV3FrontBody(
                      data: data,
                      bodyStyle: IdCardTextStyles.detail(fontFamily),
                      titleStyle: IdCardTextStyles.position(fontFamily),
                      nameStyle: IdCardTextStyles.personName(fontFamily),
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV3,
          fit: BoxFit.fill,
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV3Layout.backTermsTop,
            left: _w * _CompanyV3Layout.backTermsSide,
            right: _w * _CompanyV3Layout.backTermsSide,
            bottom: _h * _CompanyV3Layout.backTermsBottom,
            child: _CompanyV3SquareBullets(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 13,
            ),
          ),
        if (dates.isNotEmpty)
          Positioned(
            top: _h * _CompanyV3Layout.backDatesTop,
            left: _w * _CompanyV3Layout.backDatesSide,
            right: _w * _CompanyV3Layout.backDatesSide,
            height: _h * _CompanyV3Layout.backDatesHeight,
            child: _CompanyV3CenteredLines(
              lines: dates,
              style: IdCardTextStyles.backBody(fontFamily),
              minFontSize: 14,
            ),
          ),

        Positioned(
          left: _w * _CompanyV3Layout.backFooterSide,
          right: _w * _CompanyV3Layout.backFooterSide,
          bottom: _h * 0.02,
          height: _h * 0.08,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV3BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompanyV3BrandRow extends StatelessWidget {
  const _CompanyV3BrandRow({
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
              width: _CompanyV3Layout.logoSize,
              height: _CompanyV3Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV3Layout.logoGap),
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

class _CompanyV3FrontBody extends StatelessWidget {
  const _CompanyV3FrontBody({
    required this.data,
    required this.bodyStyle,
    required this.titleStyle,
    required this.nameStyle,
    required this.bodyMinFontSize,
  });

  final EmployeeData data;
  final TextStyle bodyStyle;
  final TextStyle titleStyle;
  final TextStyle nameStyle;
  final double bodyMinFontSize;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    String cap(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final name = data.employeeName.trim().toUpperCase();
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 2,
          minFontSize: bodyMinFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 38) * 1.1,
      );
    }

    final title = data.position.trim();
    if (title.isNotEmpty) {
      add(
        AutoSizeText(
          title,
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        (titleStyle.fontSize ?? 22) * 1.15,
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
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: lineMinFont,
          textAlign: TextAlign.center,
          style: lineStyle,
        ),
        (lineStyle.fontSize ?? 24) *
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
          _CompanyV3Layout.frontLineGapMin,
          _CompanyV3Layout.frontLineGapMax,
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

class _CompanyV3SquareBullets extends StatelessWidget {
  const _CompanyV3SquareBullets({
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
          if (i > 0) const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: 10,
                  height: 10,
                  color: _CompanyV3Layout.accentBlue,
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

class _CompanyV3CenteredLines extends StatelessWidget {
  const _CompanyV3CenteredLines({
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
