import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 7 — teal wave theme (ref: 7th front/back company PNGs).
abstract final class _CompanyV7Layout {
  static const Color accentTeal = Color(0xFF1DB7C5);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMuted = Color(0xFF4A5568);
  static const Color headerOnDark = Colors.white;

  static const double headerBrandTop = 0.058;
  static const double headerBrandHeight = 0.095;
  static const double headerBrandSide = 0.12;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 26;

  static const double frontPhotoSizeRatio = 0.36;
  static const double frontPhotoCenterYRatio = 0.535;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 20.0;
  static const double frontContentMinTopRatio = 0.635;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.06;
  static const double frontNameFontSize = 36;
  static const double frontTitleFontSize = 21;
  static const double frontBodyFontSize = 22;
  static const double frontBodyMinFontSize = 14;
  static const double frontLineGapMin = 6.0;
  static const double frontLineGapMax = 11.0;

  static const double backBrandTop = 0.075;
  static const double backBrandHeight = 0.11;
  static const double backBrandSide = 0.12;

  static const double backTermsTop = 0.60;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.22;

  static const double backDatesTop = 0.72;
  static const double backDatesHeight = 0.08;
  static const double backDatesSide = 0.14;

  static const double backSignatureTop = 0.80;
  static const double backSignatureHeight = 0.10;
  static const double backSignatureSide = 0.18;
}

class CompanyIdTemplatePortraitV7 extends StatelessWidget {
  const CompanyIdTemplatePortraitV7({
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
    final photoSize = _w * _CompanyV7Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV7Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV7Layout.frontGapBelowPhoto,
      _h * _CompanyV7Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV7,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV7Layout.headerBrandTop,
          height: _h * _CompanyV7Layout.headerBrandHeight,
          left: _w * _CompanyV7Layout.headerBrandSide,
          right: _w * _CompanyV7Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV7BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV7Layout.accentTeal,
                fontSize: _CompanyV7Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.45,
              )),
              accentStyle: _ts(const TextStyle(
                color: _CompanyV7Layout.textDark,
                fontSize: _CompanyV7Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.45,
              )),
              minNameSize: 14,
              onDark: false,
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
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV7Layout.textDark,
                        fontSize: _CompanyV7Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV7Layout.textMuted,
                        fontSize: _CompanyV7Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV7Layout.textDark,
                        fontSize: _CompanyV7Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      bodyMinFontSize: _CompanyV7Layout.frontBodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV7,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV7Layout.backBrandTop,
          height: _h * _CompanyV7Layout.backBrandHeight,
          left: _w * _CompanyV7Layout.backBrandSide,
          right: _w * _CompanyV7Layout.backBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV7BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV7Layout.accentTeal,
                fontSize: _CompanyV7Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              accentStyle: _ts(const TextStyle(
                color: _CompanyV7Layout.headerOnDark,
                fontSize: _CompanyV7Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
              onDark: true,
            ),
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV7Layout.backTermsTop,
            left: _w * _CompanyV7Layout.backTermsSide,
            right: _w * _CompanyV7Layout.backTermsSide,
            bottom: _h * _CompanyV7Layout.backTermsBottom,
            child: _CompanyV7SquareBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV7Layout.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.36,
              )),
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
              style: _ts(const TextStyle(
                color: _CompanyV7Layout.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                height: 1.3,
              )),
              minFontSize: 13,
            ),
          ),
        if (data.hasSignature)
          Positioned(
            top: _h * _CompanyV7Layout.backSignatureTop,
            left: _w * _CompanyV7Layout.backSignatureSide,
            right: _w * _CompanyV7Layout.backSignatureSide,
            height: _h * _CompanyV7Layout.backSignatureHeight,
            child: Center(
              child: _CompanyV7SignaturePreview(
                path: data.signaturePath,
                bytes: data.signatureBytes,
              ),
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
    required this.accentStyle,
    required this.minNameSize,
    required this.onDark,
  });

  final String companyName;
  final String logoAsset;
  final TextStyle nameStyle;
  final TextStyle accentStyle;
  final double minNameSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final name = companyName.trim();
    final logo = logoAsset.trim();
    final parts = name.split(RegExp(r'\s+'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              logo,
              width: _CompanyV7Layout.logoSize,
              height: _CompanyV7Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.lens_outlined,
                size: _CompanyV7Layout.logoSize,
                color: onDark ? _CompanyV7Layout.accentTeal : _CompanyV7Layout.textDark,
              ),
            ),
          ),
          SizedBox(width: _CompanyV7Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: parts.length >= 2
                ? AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${parts.sublist(0, parts.length - 1).join(' ').toUpperCase()} ',
                          style: nameStyle,
                        ),
                        TextSpan(
                          text: parts.last.toUpperCase(),
                          style: accentStyle,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    minFontSize: minNameSize,
                    textAlign: TextAlign.center,
                  )
                : AutoSizeText(
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
        (bodyStyle.fontSize ?? 22) * (isEmail ? 1.45 : 1.22),
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

class _CompanyV7SignaturePreview extends StatelessWidget {
  const _CompanyV7SignaturePreview({
    required this.path,
    this.bytes,
  });

  final String path;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    Widget? image;
    if (bytes != null && bytes!.isNotEmpty) {
      image = Image.memory(bytes!, fit: BoxFit.contain);
    } else if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        image = Image.file(file, fit: BoxFit.contain);
      }
    }
    if (image == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 48, child: image),
        const SizedBox(height: 4),
        Container(
          width: 140,
          height: 1.2,
          color: _CompanyV7Layout.textDark.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
