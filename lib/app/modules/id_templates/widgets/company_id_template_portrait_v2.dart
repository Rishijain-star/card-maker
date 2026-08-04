import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 2 — orange / charcoal theme (ref: company front 2 PNGs).
abstract final class _CompanyV2Layout {
  static const Color accentOrange = Color(0xFFFF7A00);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color headerText = Colors.white;

  static const double headerBrandTop = 0.042;
  static const double headerBrandHeight = 0.085;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 24;

  // Orange circle is already part of the background PNG, so we match the
  // photo circle just inside it (slightly smaller than the orange ring).
  static const double frontPhotoSizeRatio = 0.505;
  static const double frontPhotoCenterYRatio = 0.288;
  static const double frontPhotoBorderWidth = 0.0;
  static const double frontGapBelowPhoto = 28.0;
  static const double frontContentMinTopRatio = 0.495;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.14;
  static const double frontNameFontSize = 38;
  static const double frontTitleFontSize = 22;
  static const double frontBodyFontSize = 24;
  static const double frontBodyMinFontSize = 15;
  static const double frontLineGapMin = 7.0;
  static const double frontLineGapMax = 13.0;

  static const double backBrandTop = 0.038;
  static const double backBrandHeight = 0.095;
  static const double backBrandSide = 0.10;

  static const double backTermsHeadingTop = 0.21;
  static const double backTermsHeadingHeight = 0.045;
  static const double backTermsTop = 0.27;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.36;

  static const double backContactTop = 0.66;
  static const double backContactSide = 0.10;
  static const double backContactBottom = 0.12;
}

class CompanyIdTemplatePortraitV2 extends StatelessWidget {
  const CompanyIdTemplatePortraitV2({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
  });

  final EmployeeData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);
  TextStyle _tsPrimary(TextStyle base) =>
      studentPortraitPrimaryTextStyle(base, fontFamily);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final photoSize = _w * _CompanyV2Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV2Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV2Layout.frontGapBelowPhoto,
      _h * _CompanyV2Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV2,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV2Layout.headerBrandTop,
          height: _h * _CompanyV2Layout.headerBrandHeight,
          left: _w * _CompanyV2Layout.headerBrandSide,
          right: _w * _CompanyV2Layout.headerBrandSide,
          child: Align(
            alignment: const Alignment(0, 0.68),
            child: _CompanyV2BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV2Layout.headerText,
                fontSize: _CompanyV2Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.4,
              )),
              minNameSize: 14,
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
            borderColor: _CompanyV2Layout.accentOrange,
            borderWidth: _CompanyV2Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV2Layout.frontContentSide,
          right: _w * _CompanyV2Layout.frontContentSide,
          bottom: _h * _CompanyV2Layout.frontContentBottomRatio,
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
                    child: _CompanyV2FrontBody(
                      data: data,
                      bodyStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV2Layout.textDark,
                        fontSize: IdCardPortraitTypography.bodyFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.28,
                      )),
                      titleStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV2Layout.textMuted,
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      )),
                      nameDarkStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV2Layout.textDark,
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      )),
                      nameAccentStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV2Layout.accentOrange,
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      )),
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.backBackgroundV2,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV2Layout.backBrandTop,
          height: _h * _CompanyV2Layout.backBrandHeight,
          left: _w * _CompanyV2Layout.backBrandSide,
          right: _w * _CompanyV2Layout.backBrandSide,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _CompanyV2BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV2Layout.headerText,
                fontSize: _CompanyV2Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
            ),
          ),
        ),
        if (terms.isNotEmpty) ...[
          Positioned(
            top: _h * _CompanyV2Layout.backTermsHeadingTop,
            left: _w * _CompanyV2Layout.backTermsSide,
            right: _w * _CompanyV2Layout.backTermsSide,
            height: _h * _CompanyV2Layout.backTermsHeadingHeight,
            child: Center(
              child: AutoSizeText(
                'Terms And Conditions :',
                maxLines: 1,
                minFontSize: 14,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _CompanyV2Layout.accentOrange,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                )),
              ),
            ),
          ),
          Positioned(
            top: _h * _CompanyV2Layout.backTermsTop,
            left: _w * _CompanyV2Layout.backTermsSide,
            right: _w * _CompanyV2Layout.backTermsSide,
            bottom: _h * _CompanyV2Layout.backTermsBottom,
            child: _CompanyV2SquareBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV2Layout.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: 13,
            ),
          ),
        ],
        Positioned(
          top: _h * _CompanyV2Layout.backContactTop,
          left: _w * _CompanyV2Layout.backContactSide,
          right: _w * _CompanyV2Layout.backContactSide,
          bottom: _h * _CompanyV2Layout.backContactBottom,
          child: _CompanyV2ContactSection(
            phone: data.phone,
            email: data.email,
            bloodGroup: data.bloodGroup,
            valueStyle: _ts(const TextStyle(
              color: _CompanyV2Layout.textDark,
              fontSize: 19,
              fontWeight: FontWeight.w500,
              height: 1.25,
            )),
            minFontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _CompanyV2BrandRow extends StatelessWidget {
  const _CompanyV2BrandRow({
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              logo,
              width: _CompanyV2Layout.logoSize,
              height: _CompanyV2Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.hexagon_outlined,
                size: _CompanyV2Layout.logoSize,
                color: _CompanyV2Layout.accentOrange,
              ),
            ),
          ),
          SizedBox(width: _CompanyV2Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: AutoSizeText(
              name.toUpperCase(),
              maxLines: 2,
              minFontSize: minNameSize,
              textAlign: TextAlign.center,
              style: nameStyle,
            ),
          ),
      ],
    );
  }
}

class _CompanyV2FrontBody extends StatelessWidget {
  const _CompanyV2FrontBody({
    required this.data,
    required this.bodyStyle,
    required this.titleStyle,
    required this.nameDarkStyle,
    required this.nameAccentStyle,
    required this.bodyMinFontSize,
  });

  final EmployeeData data;
  final TextStyle bodyStyle;
  final TextStyle titleStyle;
  final TextStyle nameDarkStyle;
  final TextStyle nameAccentStyle;
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
        _CompanyV2SplitName(
          fullName: name,
          darkStyle: nameDarkStyle,
          accentStyle: nameAccentStyle,
          minFontSize: bodyMinFontSize + 4,
        ),
        (nameDarkStyle.fontSize ?? 38) * 1.1,
      );
    }

    String cap(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final title = cap(data.position);
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

    for (final line in data.frontDetailLines) {
      final isEmail = line.contains('@');
      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 24) * (isEmail ? 1.45 : 1.22),
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
          _CompanyV2Layout.frontLineGapMin,
          _CompanyV2Layout.frontLineGapMax,
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

class _CompanyV2SplitName extends StatelessWidget {
  const _CompanyV2SplitName({
    required this.fullName,
    required this.darkStyle,
    required this.accentStyle,
    required this.minFontSize,
  });

  final String fullName;
  final TextStyle darkStyle;
  final TextStyle accentStyle;
  final double minFontSize;

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
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return AutoSizeText(
        _cap(fullName),
        maxLines: 2,
        minFontSize: minFontSize,
        textAlign: TextAlign.center,
        style: darkStyle,
      );
    }

    final lead = _cap(parts.sublist(0, parts.length - 1).join(' '));
    final last = _cap(parts.last);

    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(text: '$lead ', style: darkStyle),
          TextSpan(text: last, style: accentStyle),
        ],
      ),
      maxLines: 2,
      minFontSize: minFontSize,
      textAlign: TextAlign.center,
    );
  }
}

class _CompanyV2SquareBullets extends StatelessWidget {
  const _CompanyV2SquareBullets({
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
                  color: _CompanyV2Layout.accentOrange,
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

class _CompanyV2ContactSection extends StatelessWidget {
  const _CompanyV2ContactSection({
    required this.phone,
    required this.email,
    required this.bloodGroup,
    required this.valueStyle,
    required this.minFontSize,
  });

  final String phone;
  final String email;
  final String bloodGroup;
  final TextStyle valueStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <({IconData icon, String value})>[];
    void add(IconData icon, String value) {
      final v = value.trim();
      if (v.isNotEmpty) rows.add((icon: icon, value: v));
    }

    add(Icons.phone_outlined, phone);
    add(Icons.language_outlined, email);
    add(Icons.bloodtype_outlined, bloodGroup);

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                rows[i].icon,
                size: 20,
                color: _CompanyV2Layout.accentOrange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AutoSizeText(
                  rows[i].value,
                  maxLines: 2,
                  minFontSize: minFontSize,
                  style: valueStyle,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
