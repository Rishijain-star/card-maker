import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 10 — purple curves; main form on front, optional on back.
abstract final class _CompanyV10Layout {
  static const Color accentPurple = Color(0xFF5E3A87);
  static const Color textDark = Color(0xFF3D2B54);
  static const Color textMuted = Color(0xFF6B5B7B);
  static const Color headerText = Colors.white;
  static const Color lineAccent = Color(0xFFB8A4CE);

  static const double frontPhotoSizeRatio = 0.33;
  static const double frontPhotoCenterYRatio = 0.145;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 16.0;
  static const double frontContentMinTopRatio = 0.30;
  static const double frontContentSide = 0.14;
  static const double frontContentBottomRatio = 0.12;
  static const double frontNameFontSize = 34;
  static const double frontTitleFontSize = 18;
  static const double frontBodyFontSize = 19;
  static const double frontBodyMinFontSize = 13;
  static const double frontLineGapMin = 5.0;
  static const double frontLineGapMax = 9.0;

  static const double backBrandTop = 0.06;
  static const double backBrandHeight = 0.14;
  static const double backBrandSide = 0.12;
  static const double backLogoSize = 44.0;
  static const double backCompanyNameFontSize = 22;

  static const double backTermsTop = 0.24;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.24;

  static const double backSignatureLeft = 0.12;
  static const double backSignatureBottom = 0.10;
  static const double backSignatureWidth = 0.45;
  static const double backSignatureHeight = 0.08;
}

class CompanyIdTemplatePortraitV10 extends StatelessWidget {
  const CompanyIdTemplatePortraitV10({
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

  List<String> _frontLines(EmployeeData data) {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.employeeId);
    add(data.joinDate);
    add(data.email);
    add(data.phone);
    add(data.bloodGroup);
    return lines;
  }

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
          CompanyIdTemplateAssets.frontBackgroundV10,
          fit: BoxFit.fill,
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
                      nameStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV10Layout.textDark,
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: 0.3,
                      )),
                      titleStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV10Layout.textMuted,
                        fontSize: IdCardPortraitTypography.nameFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: 1.2,
                      )),
                      bodyStyle: _tsPrimary(const TextStyle(
                        color: _CompanyV10Layout.textDark,
                        fontSize: IdCardPortraitTypography.bodyFontSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.28,
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
          CompanyIdTemplateAssets.backBackgroundV10,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV10Layout.backBrandTop,
          height: _h * _CompanyV10Layout.backBrandHeight,
          left: _w * _CompanyV10Layout.backBrandSide,
          right: _w * _CompanyV10Layout.backBrandSide,
          child: _CompanyV10BackBrand(
            companyName: data.companyName,
            logoAsset: data.logoAsset,
            nameStyle: _ts(const TextStyle(
              color: _CompanyV10Layout.headerText,
              fontSize: _CompanyV10Layout.backCompanyNameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            minNameSize: 12,
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
              textStyle: _ts(const TextStyle(
                color: _CompanyV10Layout.textDark,
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: 12,
            ),
          ),
        if (data.hasSignature)
          Positioned(
            left: _w * _CompanyV10Layout.backSignatureLeft,
            bottom: _h * _CompanyV10Layout.backSignatureBottom,
            width: _w * _CompanyV10Layout.backSignatureWidth,
            height: _h * _CompanyV10Layout.backSignatureHeight,
            child: _CompanyV10SignaturePreview(
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (logo.isNotEmpty)
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
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.business_rounded,
                    color: _CompanyV10Layout.headerText,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        if (logo.isNotEmpty && name.isNotEmpty) const SizedBox(height: 8),
        if (name.isNotEmpty)
          AutoSizeText(
            name.toUpperCase(),
            maxLines: 2,
            minFontSize: minNameSize,
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
  });

  final String employeeName;
  final String position;
  final List<String> detailLines;
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

    for (final line in detailLines) {
      final isEmail = line.contains('@');
      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 19) * (isEmail ? 1.4 : 1.2),
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

class _CompanyV10SignaturePreview extends StatelessWidget {
  const _CompanyV10SignaturePreview({
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
