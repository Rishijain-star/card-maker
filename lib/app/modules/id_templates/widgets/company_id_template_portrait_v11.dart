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

/// Company template 11 — green sidebar; main form on front, optional on back.
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV11Layout {
  /// Decorative only (photo ring, bullet dots) — never text.
  static const Color accentGreen = Color(0xFF1F6B45);

  static const double sidebarWidthRatio = 0.23;
  static const double contentRightMarginRatio = 0.04;

  static const double sidebarTextTop = 0.22;
  static const double sidebarTextBottom = 0.22;

  static const double headerTop = 0.04;
  static const double headerHeight = 0.135;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;

  static const double frontPhotoSizeRatio = 0.30;
  static const double frontPhotoCenterYRatio = 0.355;
  static const double frontPhotoBorderWidth = 5.0;
  static const double frontGapBelowPhoto = 14.0;
  static const double frontContentMinTopRatio = 0.47;
  static const double frontContentBottomRatio = 0.16;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 18.0;

  static const double frontSignatureHeight = 0.09;

  static const double backBrandTop = 0.08;
  static const double backBrandHeight = 0.14;
  static const double backTermsTop = 0.28;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.22;
}

class CompanyIdTemplatePortraitV11 extends StatelessWidget {
  const CompanyIdTemplatePortraitV11({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
    this.headerTextColor,
  });

  final EmployeeData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;
  final Color? headerTextColor;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  double get _contentLeft => _w * _CompanyV11Layout.sidebarWidthRatio;

  double get _contentWidth =>
      _w - _contentLeft - _w * _CompanyV11Layout.contentRightMarginRatio;

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
    final photoSize = _w * _CompanyV11Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV11Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = _contentLeft + (_contentWidth - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV11Layout.frontGapBelowPhoto,
      _h * _CompanyV11Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);
    final sidebarText = data.isStudentData
        ? data.companyName.trim()
        : (data.position.trim().isNotEmpty ? data.position.trim() : data.companyName.trim());

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV11,
          fit: BoxFit.fill,
        ),
        if (sidebarText.isNotEmpty)
          Positioned(
            left: 0,
            top: _h * _CompanyV11Layout.sidebarTextTop,
            bottom: _h * _CompanyV11Layout.sidebarTextBottom,
            width: _contentLeft,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: AutoSizeText(
                  sidebarText.toUpperCase(),
                  maxLines: 1,
                  softWrap: false,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                  style: IdCardTextStyles.instituteHeader(fontFamily).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: _h * _CompanyV11Layout.headerTop,
          height: _h * _CompanyV11Layout.headerHeight,
          left: _contentLeft,
          width: _contentWidth,
          child: _CompanyV11BrandRow(
            companyName: data.companyName,
            logoAsset: data.logoAsset,
            nameStyle: IdCardTextStyles.instituteHeader(fontFamily, onBanner: false).copyWith(
              color: headerTextColor ?? (data.isStudentData ? const Color(0xFF1F6B45) : null),
            ),
            minNameSize: 14,
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
            borderColor: _CompanyV11Layout.accentGreen,
            borderWidth: _CompanyV11Layout.frontPhotoBorderWidth,
            padding: 3,
            showShadow: false,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _contentLeft,
          width: _contentWidth,
          bottom: _h * (_CompanyV11Layout.frontContentBottomRatio +
              _CompanyV11Layout.frontSignatureHeight),
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
                    child: _CompanyV11FrontBody(
                      employeeName: data.employeeName,
                      position: data.position,
                      detailLines: _frontLines(data),
                      nameStyle: IdCardTextStyles.personName(fontFamily),
                      fatherStyle: IdCardTextStyles.fatherName(fontFamily),
                      courseStyle: IdCardTextStyles.course(fontFamily),
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
            right: _w * 0.05,
            bottom: _h * 0.04,
            child: StudentPortraitSignatureCircle(
              size: _h * 0.09,
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV11,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV11Layout.backBrandTop,
          height: _h * _CompanyV11Layout.backBrandHeight,
          left: _w * 0.05,
          right: _w * 0.05,
          child: _CompanyV11BrandRow(
            companyName: data.companyName,
            logoAsset: data.logoAsset,
            nameStyle: IdCardTextStyles.instituteHeader(fontFamily, onBanner: false).copyWith(
              color: headerTextColor ?? (data.isStudentData ? const Color(0xFF1F6B45) : null),
            ),
            minNameSize: 14,
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV11Layout.backTermsTop,
            left: _w * 0.22,
            right: _w * 0.06,
            bottom: _h * _CompanyV11Layout.backTermsBottom,
            child: _CompanyV11BackTerms(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily),
              minFontSize: 11,
            ),
          ),
      ],
    );
  }
}

class _CompanyV11BrandRow extends StatelessWidget {
  const _CompanyV11BrandRow({
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
    final parts = name.split(RegExp(r'\s+'));

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
              width: _CompanyV11Layout.logoSize,
              height: _CompanyV11Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV11Layout.logoGap),
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

class _CompanyV11FrontBody extends StatelessWidget {
  const _CompanyV11FrontBody({
    required this.employeeName,
    required this.position,
    required this.detailLines,
    required this.nameStyle,
    required this.fatherStyle,
    required this.courseStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.isStudentData = false,
  });

  final String employeeName;
  final String position;
  final List<String> detailLines;
  final TextStyle nameStyle;
  final TextStyle fatherStyle;
  final TextStyle courseStyle;
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
        (nameStyle.fontSize ?? 32) * 1.1,
      );
    }

    final title = cap(position);
    if (title.isNotEmpty) {
      add(
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: bodyMinFontSize,
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
        ),
        (titleStyle.fontSize ?? 19) * 1.15,
      );
    }

    for (var i = 0; i < detailLines.length; i++) {
      final line = detailLines[i];
      final isEmail = line.contains('@');
      TextStyle lineStyle = bodyStyle;
      double lineMinFont = bodyMinFontSize;

      if (isStudentData) {
        if (i == 0) {
          lineStyle = fatherStyle;
          lineMinFont = bodyMinFontSize + 2;
        } else if (i == 1) {
          lineStyle = courseStyle;
          lineMinFont = bodyMinFontSize + 2;
        }
      }

      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: lineMinFont,
          textAlign: TextAlign.center,
          style: lineStyle,
        ),
        (lineStyle.fontSize ?? 19) *
            (isEmail ? 1.4 : (isStudentData && i < 2 ? 1.08 : 1.2)),
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
          _CompanyV11Layout.frontLineGapMin,
          _CompanyV11Layout.frontLineGapMax,
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

class _CompanyV11BackTerms extends StatelessWidget {
  const _CompanyV11BackTerms({
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
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: _CompanyV11Layout.accentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  lines[i],
                  maxLines: 8,
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
