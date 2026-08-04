import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 3 — blue wave theme (ref: 3rd company front/back PNGs).
abstract final class _CompanyV3Layout {
  static const Color accentBlue = Color(0xFF0B55A4);
  static const Color accentBlueLight = Color(0xFF2196F3);
  static const Color textDark = Color(0xFF2D3748);
  static const Color textMuted = Color(0xFF718096);
  static const Color headerText = Colors.white;

  static const double headerBrandTop = 0.048;
  static const double headerBrandHeight = 0.085;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 24;

  static const double frontPhotoSizeRatio = 0.46;
  static const double frontPhotoCenterYRatio = 0.292;
  static const double frontPhotoBorderWidth = 6.0;
  static const double frontGapBelowPhoto = 26.0;
  static const double frontContentMinTopRatio = 0.515;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.12;
  static const double frontNameFontSize = 38;
  static const double frontTitleFontSize = 22;
  static const double frontBodyFontSize = 24;
  static const double frontBodyMinFontSize = 15;
  static const double frontLineGapMin = 7.0;
  static const double frontLineGapMax = 13.0;

  static const double backTermsTop = 0.10;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.58;

  static const double backDatesTop = 0.44;
  static const double backDatesHeight = 0.10;
  static const double backDatesSide = 0.12;

  static const double backSignatureTop = 0.54;
  static const double backSignatureHeight = 0.12;
  static const double backSignatureSide = 0.18;

  static const double backFooterHeight = 0.11;
  static const double backFooterSide = 0.10;
}

class CompanyIdTemplatePortraitV3 extends StatelessWidget {
  const CompanyIdTemplatePortraitV3({
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
          CompanyIdTemplateAssets.frontBackgroundV3,
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
              nameStyle: _ts(const TextStyle(
                color: _CompanyV3Layout.headerText,
                fontSize: _CompanyV3Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.35,
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
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV3Layout.textDark,
                        fontSize: _CompanyV3Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV3Layout.textMuted,
                        fontSize: _CompanyV3Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      )),
                      nameDarkStyle: _ts(const TextStyle(
                        color: _CompanyV3Layout.textDark,
                        fontSize: _CompanyV3Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      nameAccentStyle: _ts(const TextStyle(
                        color: _CompanyV3Layout.accentBlueLight,
                        fontSize: _CompanyV3Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      bodyMinFontSize: _CompanyV3Layout.frontBodyMinFontSize,
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
    addDate(data.expireDate);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.backBackgroundV3,
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
              textStyle: _ts(const TextStyle(
                color: _CompanyV3Layout.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
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
              style: _ts(const TextStyle(
                color: _CompanyV3Layout.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
              )),
              minFontSize: 14,
            ),
          ),
        if (data.hasSignature)
          Positioned(
            top: _h * _CompanyV3Layout.backSignatureTop,
            left: _w * _CompanyV3Layout.backSignatureSide,
            right: _w * _CompanyV3Layout.backSignatureSide,
            height: _h * _CompanyV3Layout.backSignatureHeight,
            child: Center(
              child: _CompanyV3SignaturePreview(
                path: data.signaturePath,
                bytes: data.signatureBytes,
                hasBorder: data.signatureHasBorder,
                borderColor: data.signatureBorderColor,
                borderWidth: data.signatureBorderWidth,
              ),
            ),
          ),
        Positioned(
          left: _w * _CompanyV3Layout.backFooterSide,
          right: _w * _CompanyV3Layout.backFooterSide,
          bottom: 0,
          height: _h * _CompanyV3Layout.backFooterHeight,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV3BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV3Layout.headerText,
                fontSize: _CompanyV3Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              logo,
              width: _CompanyV3Layout.logoSize,
              height: _CompanyV3Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.hexagon_outlined,
                size: _CompanyV3Layout.logoSize,
                color: _CompanyV3Layout.headerText,
              ),
            ),
          ),
          SizedBox(width: _CompanyV3Layout.logoGap),
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

class _CompanyV3FrontBody extends StatelessWidget {
  const _CompanyV3FrontBody({
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
        _CompanyV3SplitName(
          fullName: name,
          darkStyle: nameDarkStyle,
          accentStyle: nameAccentStyle,
          minFontSize: bodyMinFontSize + 4,
        ),
        (nameDarkStyle.fontSize ?? 38) * 1.1,
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

    for (final line in data.frontDetailLines) {
      final isEmail = line.contains('@');
      add(
        AutoSizeText(
          line,
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

class _CompanyV3SplitName extends StatelessWidget {
  const _CompanyV3SplitName({
    required this.fullName,
    required this.darkStyle,
    required this.accentStyle,
    required this.minFontSize,
  });

  final String fullName;
  final TextStyle darkStyle;
  final TextStyle accentStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return AutoSizeText(
        fullName.toUpperCase(),
        maxLines: 2,
        minFontSize: minFontSize,
        textAlign: TextAlign.center,
        style: darkStyle,
      );
    }

    final lead = parts.sublist(0, parts.length - 1).join(' ').toUpperCase();
    final last = parts.last.toUpperCase();

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

class _CompanyV3SignaturePreview extends StatelessWidget {
  const _CompanyV3SignaturePreview({
    required this.path,
    this.bytes,
    this.hasBorder = false,
    this.borderColor = const Color(0xFF0F172A),
    this.borderWidth = 1.0,
  });

  final String path;
  final Uint8List? bytes;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return StudentPortraitSignatureCircle(
      size: 80,
      path: path,
      bytes: bytes,
      hasBorder: hasBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }
}
