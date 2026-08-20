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

/// Company template 7 — teal wave theme (ref: 7th front/back company PNGs).
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV7Layout {
  /// Decorative only (bullet squares) — never text.
  static const Color accentTeal = Color(0xFF1DB7C5);

  static const double headerBrandTop = 0.058;
  static const double headerBrandHeight = 0.095;
  static const double headerBrandSide = 0.05;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;

  static const double frontPhotoSizeRatio = 0.36;
  static const double frontPhotoCenterYRatio = 0.535;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 20.0;
  static const double frontContentMinTopRatio = 0.635;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.06;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 18.0;

  static const double backBrandTop = 0.075;
  static const double backBrandHeight = 0.11;

  static const double backTermsTop = 0.60;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.22;

  static const double backDatesTop = 0.72;
  static const double backDatesHeight = 0.08;
  static const double backDatesSide = 0.14;
}

class CompanyIdTemplatePortraitV7 extends StatelessWidget {
  const CompanyIdTemplatePortraitV7({
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
    final isCustomBg = frontBgAsset != null;
    final photoCenterYRatio = isCustomBg ? 0.280 : _CompanyV7Layout.frontPhotoCenterYRatio;
    final contentMinTopRatio = isCustomBg ? 0.420 : _CompanyV7Layout.frontContentMinTopRatio;
    final headerTopRatio = isCustomBg ? 0.040 : _CompanyV7Layout.headerBrandTop;
    final headerSideRatio = isCustomBg ? 0.08 : _CompanyV7Layout.headerBrandSide;
    final headerTextColor = isCustomBg ? const Color(0xFF0F172A) : Colors.white;

    final photoSize = _w * _CompanyV7Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * photoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV7Layout.frontGapBelowPhoto,
      _h * contentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV7,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * headerTopRatio,
          height: _h * _CompanyV7Layout.headerBrandHeight,
          left: _w * headerSideRatio,
          right: _w * headerSideRatio,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV7BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle:
                  IdCardTextStyles.instituteHeader(fontFamily, onBanner: !isCustomBg, color: headerTextColor),
              minNameSize: 12,
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
            borderWidth: _CompanyV7Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV7Layout.frontContentSide,
          right: _w * _CompanyV7Layout.frontContentSide,
          bottom: _h * _CompanyV7Layout.frontContentBottomRatio,
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
                    child: _CompanyV7FrontBody(
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV7,
          fit: BoxFit.fill,
        ),
        Positioned(
          bottom: _h * 0.035,
          height: _h * _CompanyV7Layout.backBrandHeight,
          left: _w * 0.05,
          right: _w * 0.05,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV7BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily, onBanner: false, color: Colors.black),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV7Layout.backTermsTop,
            left: _w * _CompanyV7Layout.backTermsSide,
            right: _w * _CompanyV7Layout.backTermsSide,
            bottom: _h * 0.13,
            child: _CompanyV7SquareBullets(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 13,
            ),
          ),
        if (dates.isNotEmpty)
          Positioned(
            top: _h * _CompanyV7Layout.backDatesTop,
            left: _w * _CompanyV7Layout.backDatesSide,
            right: _w * _CompanyV7Layout.backDatesSide,
            height: _h * _CompanyV7Layout.backDatesHeight,
            child: _CompanyV7CenteredLines(
              lines: dates,
              style: IdCardTextStyles.backBody(fontFamily),
              minFontSize: 13,
            ),
          ),

      ],
    );
  }
}

class _CompanyV7BrandRow extends StatelessWidget {
  const _CompanyV7BrandRow({
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
    final hasLogo = logo.isNotEmpty && !logo.contains('lens');
    final parts = name.split(RegExp(r'\s+'));

    final effectiveStyle = nameStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasLogo) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              logo,
              width: _CompanyV7Layout.logoSize,
              height: _CompanyV7Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV7Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: AutoSizeText(
              IdCardTypography.formatInstituteName(name.toUpperCase()),
              maxLines: 3,
              minFontSize: IdCardPortraitTypography.headerMinFontSize,
              textAlign: TextAlign.center,
              style: effectiveStyle,
            ),
          ),
      ],
    );
  }
}

class _CompanyV7FrontBody extends StatelessWidget {
  const _CompanyV7FrontBody({
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
          _CompanyV7Layout.frontLineGapMin,
          _CompanyV7Layout.frontLineGapMax,
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

class _CompanyV7SquareBullets extends StatelessWidget {
  const _CompanyV7SquareBullets({
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
                  color: _CompanyV7Layout.accentTeal,
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

class _CompanyV7CenteredLines extends StatelessWidget {
  const _CompanyV7CenteredLines({
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

