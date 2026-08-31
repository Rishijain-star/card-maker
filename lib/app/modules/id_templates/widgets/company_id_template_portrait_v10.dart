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

/// Company template 10 — purple curves; main form on front, optional on back.
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV10Layout {
  /// Decorative only (bullet dots, logo fallback icon, rules) — never text.
  static const Color accentPurple = Color(0xFF5E3A87);
  static const Color headerText = Colors.white;
  static const Color lineAccent = Color(0xFFB8A4CE);

  static const double frontPhotoSizeRatio = 0.33;
  static const double frontPhotoCenterYRatio = 0.245;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 16.0;
  static const double frontContentMinTopRatio = 0.345;
  static const double frontContentSide = 0.14;
  static const double frontContentBottomRatio = 0.12;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 18.0;

  static const double backBrandTop = 0.06;
  static const double backBrandHeight = 0.14;
  static const double backBrandSide = 0.12;
  static const double backLogoSize = 44.0;

  static const double backTermsTop = 0.24;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.24;
}

class CompanyIdTemplatePortraitV10 extends StatelessWidget {
  const CompanyIdTemplatePortraitV10({
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

  List<String> _frontLines(EmployeeData data) => data.frontDetailLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final photoSize = _w * _CompanyV10Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV10Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV10Layout.frontGapBelowPhoto,
      _h * _CompanyV10Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV10,
          fit: BoxFit.fill,
        ),
        if (data.companyName.trim().isNotEmpty)
          Positioned(
            top: _h * 0.038,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.companyName,
              fontFamily: fontFamily,
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
            borderWidth: _CompanyV10Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV10Layout.frontContentSide,
          right: _w * _CompanyV10Layout.frontContentSide,
          bottom: _h * _CompanyV10Layout.frontContentBottomRatio,
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
                    child: _CompanyV10FrontBody(
                      employeeName: data.employeeName,
                      position: data.position,
                      detailLines: _frontLines(data),
                      nameStyle: IdCardTextStyles.personName(fontFamily),
                      titleStyle: IdCardTextStyles.position(fontFamily),
                      bodyStyle: IdCardTextStyles.detail(fontFamily),
                      bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
                      isStudentData: data.isStudentData,
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV10,
          fit: BoxFit.fill,
        ),
        if (data.companyName.trim().isNotEmpty)
          Positioned(
            top: _h * 0.038,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.companyName,
              fontFamily: fontFamily,
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV10Layout.backTermsTop,
            left: _w * _CompanyV10Layout.backTermsSide,
            right: _w * _CompanyV10Layout.backTermsSide,
            bottom: _h * _CompanyV10Layout.backTermsBottom,
            child: _CompanyV10BackTerms(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 12,
            ),
          ),

      ],
    );
  }
}

class _CompanyV10BackBrand extends StatelessWidget {
  const _CompanyV10BackBrand({
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
    final hasLogo = logo.isNotEmpty && !logo.contains('business');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasLogo)
          Container(
            width: _CompanyV10Layout.backLogoSize,
            height: _CompanyV10Layout.backLogoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: ClipOval(
              child: Image.asset(
                logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        if (hasLogo && name.isNotEmpty) const SizedBox(height: 8),
        if (name.isNotEmpty)
          AutoSizeText(
            IdCardTypography.formatInstituteName(name.toUpperCase()),
            maxLines: 2,
            minFontSize: 14,
            textAlign: TextAlign.center,
            style: nameStyle,
          ),
      ],
    );
  }
}

class _CompanyV10FrontBody extends StatelessWidget {
  const _CompanyV10FrontBody({
    required this.employeeName,
    required this.position,
    required this.detailLines,
    required this.nameStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.isStudentData = false,
  });

  final String employeeName;
  final String position;
  final List<String> detailLines;
  final TextStyle nameStyle;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final bool isStudentData;

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

    final name = cap(employeeName);
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 2,
          minFontSize: bodyMinFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 34) * 1.1,
      );
    }

    final title = cap(position);
    if (title.isNotEmpty) {
      add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          child: _CompanyV10TitleWithLines(
            title: title,
            style: titleStyle,
            minFontSize: bodyMinFontSize,
          ),
        ),
        (titleStyle.fontSize ?? 18) * 1.4,
      );
    }

    for (var i = 0; i < detailLines.length; i++) {
      final line = detailLines[i];
      final isEmail = line.contains('@');
      final isStudentProminentLine = isStudentData && i < 2;
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
        (lineStyle.fontSize ?? 19) *
            (isEmail ? 1.4 : (isStudentProminentLine ? 1.08 : 1.2)),
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
          _CompanyV10Layout.frontLineGapMin,
          _CompanyV10Layout.frontLineGapMax,
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

class _CompanyV10TitleWithLines extends StatelessWidget {
  const _CompanyV10TitleWithLines({
    required this.title,
    required this.style,
    required this.minFontSize,
  });

  final String title;
  final TextStyle style;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.2,
            color: _CompanyV10Layout.lineAccent,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: minFontSize,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1.2,
            color: _CompanyV10Layout.lineAccent,
          ),
        ),
      ],
    );
  }
}

class _CompanyV10BackTerms extends StatelessWidget {
  const _CompanyV10BackTerms({
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
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: _CompanyV10Layout.accentPurple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  lines[i],
                  maxLines: 6,
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
