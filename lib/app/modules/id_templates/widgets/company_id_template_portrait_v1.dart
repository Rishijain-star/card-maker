import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 1 — optional logo + company name; values-only body rows.
abstract final class _CompanyV1Layout {
  static const Color accentPurple = Color(0xFF6B2D8E);
  static const Color textDark = Color(0xFF1E293B);

  static const double headerBrandTop = 0.098;
  static const double headerBrandHeight = 0.095;
  static const double headerBrandSide = 0.08;
  static const double logoSize = 36.0;
  static const double logoGap = 10.0;
  static const double companyNameFontSize = 28;

  static const double frontPhotoSizeRatio = 0.28;
  static const double frontPhotoCenterYRatio = 0.362;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 16.0;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.10;
  static const double frontNameFontSize = 36;
  static const double frontTitleFontSize = 21;
  static const double frontBodyFontSize = 22;
  static const double frontBodyMinFontSize = 14;
  static const double frontLineGapMin = 6.0;
  static const double frontLineGapMax = 11.0;

  static const double backBrandTop = 0.055;
  static const double backBrandHeight = 0.11;
  static const double backBrandSide = 0.10;

  static const double backSignatureTop = 0.20;
  static const double backSignatureHeight = 0.12;
  static const double backSignatureSide = 0.16;

  static const double backTermsTop = 0.34;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.22;
  static const double backBulletSize = 11.0;
  static const double backBulletGap = 10.0;
}

class CompanyIdTemplatePortraitV1 extends StatelessWidget {
  const CompanyIdTemplatePortraitV1({
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
    final photoSize = _w * _CompanyV1Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV1Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop =
        photoTop + photoSize + _CompanyV1Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV1,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV1Layout.headerBrandTop,
          height: _h * _CompanyV1Layout.headerBrandHeight,
          left: _w * _CompanyV1Layout.headerBrandSide,
          right: _w * _CompanyV1Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _CompanyV1BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: Colors.white,
                fontSize: _CompanyV1Layout.companyNameFontSize,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: 0.35,
              )),
              minNameSize: 16,
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
            borderColor: _CompanyV1Layout.accentPurple,
            borderWidth: _CompanyV1Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV1Layout.frontContentSide,
          right: _w * _CompanyV1Layout.frontContentSide,
          bottom: _h * _CompanyV1Layout.frontContentBottomRatio,
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
                    child: _CompanyV1FrontBody(
                      data: data,
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV1Layout.accentPurple,
                        fontSize: _CompanyV1Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV1Layout.textDark,
                        fontSize: _CompanyV1Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV1Layout.textDark,
                        fontSize: _CompanyV1Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      bodyMinFontSize: _CompanyV1Layout.frontBodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV1,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV1Layout.backBrandTop,
          height: _h * _CompanyV1Layout.backBrandHeight,
          left: _w * _CompanyV1Layout.backBrandSide,
          right: _w * _CompanyV1Layout.backBrandSide,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _CompanyV1BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: Colors.white,
                fontSize: _CompanyV1Layout.companyNameFontSize,
                fontWeight: FontWeight.w900,
                height: 1.05,
              )),
              minNameSize: 16,
            ),
          ),
        ),
        if (data.hasSignature)
          Positioned(
            top: _h * _CompanyV1Layout.backSignatureTop,
            left: _w * _CompanyV1Layout.backSignatureSide,
            right: _w * _CompanyV1Layout.backSignatureSide,
            height: _h * _CompanyV1Layout.backSignatureHeight,
            child: Center(
              child: _CompanyV1SignaturePreview(
                path: data.signaturePath,
                bytes: data.signatureBytes,
                hasBorder: data.signatureHasBorder,
                borderColor: data.signatureBorderColor,
                borderWidth: data.signatureBorderWidth,
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV1Layout.backTermsTop,
            left: _w * _CompanyV1Layout.backTermsSide,
            right: _w * _CompanyV1Layout.backTermsSide,
            bottom: _h * _CompanyV1Layout.backTermsBottom,
            child: _CompanyV1OutlineBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV1Layout.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.34,
              )),
              minFontSize: 12,
            ),
          ),
      ],
    );
  }
}

class _CompanyV1BrandRow extends StatelessWidget {
  const _CompanyV1BrandRow({
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
              width: _CompanyV1Layout.logoSize,
              height: _CompanyV1Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.business,
                size: _CompanyV1Layout.logoSize,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(width: _CompanyV1Layout.logoGap),
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

class _CompanyV1FrontBody extends StatelessWidget {
  const _CompanyV1FrontBody({
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

    String cap(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final name = cap(data.employeeName);
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 1,
          minFontSize: bodyMinFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 38) * 1.08,
      );
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
        (bodyStyle.fontSize ?? 22) * (isEmail ? 1.5 : 1.22),
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
        final gap = (free / gapCount)
            .clamp(_CompanyV1Layout.frontLineGapMin, _CompanyV1Layout.frontLineGapMax);

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

class _CompanyV1OutlineBullets extends StatelessWidget {
  const _CompanyV1OutlineBullets({
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
                  width: _CompanyV1Layout.backBulletSize,
                  height: _CompanyV1Layout.backBulletSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _CompanyV1Layout.accentPurple,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: _CompanyV1Layout.backBulletGap),
              Expanded(
                child: AutoSizeText(
                  lines[i],
                  maxLines: 4,
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

class _CompanyV1SignaturePreview extends StatelessWidget {
  const _CompanyV1SignaturePreview({
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
