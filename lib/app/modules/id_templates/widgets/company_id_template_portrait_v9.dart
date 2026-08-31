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

/// Company template 9 — navy wave; all main form fields on front, optional on back.
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV9Layout {
  /// Decorative only (bullet dots, name divider) — never text.
  static const Color accentNavy = Color(0xFF1E2A4A);
  static const Color dividerColor = Color(0xFFCBD5E1);

  static const double headerBrandTop = 0.055;
  static const double headerBrandHeight = 0.10;
  static const double headerBrandSide = 0.05;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;

  static const double frontPhotoSizeRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.505;
  static const double frontPhotoBorderWidth = 5.0;
  static const double frontGapBelowPhoto = 18.0;
  static const double frontContentMinTopRatio = 0.555;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.08;
  static const double frontBodyMinFontSize = 13;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 18.0;

  static const double backTermsTop = 0.08;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.48;
}

class CompanyIdTemplatePortraitV9 extends StatelessWidget {
  const CompanyIdTemplatePortraitV9({
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
    final isCustomBg = frontBgAsset != null;
    final photoCenterYRatio = isCustomBg ? 0.230 : _CompanyV9Layout.frontPhotoCenterYRatio;
    final contentMinTopRatio = isCustomBg ? 0.370 : _CompanyV9Layout.frontContentMinTopRatio;
    final headerTopRatio = isCustomBg ? 0.020 : _CompanyV9Layout.headerBrandTop;

    final photoSize = _w * _CompanyV9Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * photoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV9Layout.frontGapBelowPhoto,
      _h * contentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV9,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * headerTopRatio,
          height: _h * _CompanyV9Layout.headerBrandHeight,
          left: _w * _CompanyV9Layout.headerBrandSide,
          right: _w * _CompanyV9Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV9BrandRow(
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
            borderWidth: _CompanyV9Layout.frontPhotoBorderWidth,
            padding: 2,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV9Layout.frontContentSide,
          right: _w * _CompanyV9Layout.frontContentSide,
          bottom: _h * _CompanyV9Layout.frontContentBottomRatio,
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
                    child: _CompanyV9FrontBody(
                      employeeName: data.employeeName,
                      position: data.position,
                      detailLines: _frontLines(data),
                      nameStyle: IdCardTextStyles.personName(fontFamily),
                      titleStyle: IdCardTextStyles.position(fontFamily),
                      bodyStyle: IdCardTextStyles.detail(fontFamily),
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV9,
          fit: BoxFit.fill,
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV9Layout.backTermsTop,
            left: _w * _CompanyV9Layout.backTermsSide,
            right: _w * _CompanyV9Layout.backTermsSide,
            bottom: _h * _CompanyV9Layout.backTermsBottom,
            child: _CompanyV9BackTerms(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 12,
            ),
          ),
        Positioned(
          left: _w * 0.05,
          right: _w * 0.05,
          bottom: _h * 0.02,
          height: _h * 0.08,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV9BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.035,
            bottom: _h * 0.16,
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
}

class _CompanyV9BrandRow extends StatelessWidget {
  const _CompanyV9BrandRow({
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
    final hasLogo = logo.isNotEmpty && !logo.contains('play');

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
              width: _CompanyV9Layout.logoSize,
              height: _CompanyV9Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV9Layout.logoGap),
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

class _CompanyV9FrontBody extends StatelessWidget {
  const _CompanyV9FrontBody({
    required this.employeeName,
    required this.position,
    required this.detailLines,
    required this.nameStyle,
    required this.titleStyle,
    required this.bodyStyle,
    this.bodyMinFontSize = 18.0,
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
      add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          width: 120,
          height: 1.2,
          color: _CompanyV9Layout.dividerColor,
        ),
        8,
      );
    }

    final title = cap(position);
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
        (lineStyle.fontSize ?? 20) *
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
          _CompanyV9Layout.frontLineGapMin,
          _CompanyV9Layout.frontLineGapMax,
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

class _CompanyV9BackTerms extends StatelessWidget {
  const _CompanyV9BackTerms({
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
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _CompanyV9Layout.accentNavy.withValues(alpha: 0.85),
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
