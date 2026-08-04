import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 4 — black / red chevron theme, square portrait photo.
abstract final class _CompanyV4Layout {
  static const Color accentRed = Color(0xFFE31E24);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF888888);
  static const Color headerText = Colors.white;
  static const Color backOnDarkText = Colors.white;

  static const double headerBrandTop = 0.052;
  static const double headerBrandHeight = 0.095;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 24;

  static const double frontPhotoSizeRatio = 0.355;
  static const double frontPhotoCenterYRatio = 0.298;
  static const double frontPhotoBorderWidth = 3.0;
  static const double frontGapBelowPhoto = 24.0;
  static const double frontContentMinTopRatio = 0.48;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.10;
  static const double frontNameFontSize = 38;
  static const double frontTitleFontSize = 22;
  static const double frontBodyFontSize = 24;
  static const double frontBodyMinFontSize = 15;
  static const double frontLineGapMin = 7.0;
  static const double frontLineGapMax = 13.0;

  static const double backTermsTop = 0.08;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.50;

  static const double backDatesTop = 0.46;
  static const double backDatesHeight = 0.10;
  static const double backDatesSide = 0.12;

  static const double backSignatureTop = 0.56;
  static const double backSignatureHeight = 0.12;
  static const double backSignatureSide = 0.16;

  static const double backFooterHeight = 0.14;
  static const double backFooterSide = 0.10;
}

class CompanyIdTemplatePortraitV4 extends StatelessWidget {
  const CompanyIdTemplatePortraitV4({
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
    final photoSize = _w * _CompanyV4Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV4Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV4Layout.frontGapBelowPhoto,
      _h * _CompanyV4Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV4,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV4Layout.headerBrandTop,
          height: _h * _CompanyV4Layout.headerBrandHeight,
          left: _w * _CompanyV4Layout.headerBrandSide,
          right: _w * _CompanyV4Layout.headerBrandSide,
          child: Align(
            alignment: const Alignment(0, 0.5),
            child: _CompanyV4BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV4Layout.headerText,
                fontSize: _CompanyV4Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.4,
              )),
              minNameSize: 14,
              onDark: true,
            ),
          ),
        ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoSize,
          height: photoSize,
          child: _CompanyV4SquarePhoto(
            photoPath: data.photoPath,
            size: photoSize,
            borderWidth: _CompanyV4Layout.frontPhotoBorderWidth,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV4Layout.frontContentSide,
          right: _w * _CompanyV4Layout.frontContentSide,
          bottom: _h * _CompanyV4Layout.frontContentBottomRatio,
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
                    child: _CompanyV4FrontBody(
                      data: data,
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV4Layout.textDark,
                        fontSize: _CompanyV4Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV4Layout.textMuted,
                        fontSize: _CompanyV4Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        height: 1.15,
                      )),
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV4Layout.textDark,
                        fontSize: _CompanyV4Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      bodyMinFontSize: _CompanyV4Layout.frontBodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV4,
          fit: BoxFit.fill,
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV4Layout.backTermsTop,
            left: _w * _CompanyV4Layout.backTermsSide,
            right: _w * _CompanyV4Layout.backTermsSide,
            bottom: _h * _CompanyV4Layout.backTermsBottom,
            child: _CompanyV4CircleBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV4Layout.backOnDarkText,
                fontSize: 19,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: 13,
            ),
          ),
        if (dates.isNotEmpty)
          Positioned(
            top: _h * _CompanyV4Layout.backDatesTop,
            left: _w * _CompanyV4Layout.backDatesSide,
            right: _w * _CompanyV4Layout.backDatesSide,
            height: _h * _CompanyV4Layout.backDatesHeight,
            child: _CompanyV4CenteredLines(
              lines: dates,
              style: _ts(const TextStyle(
                color: _CompanyV4Layout.backOnDarkText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
              )),
              minFontSize: 14,
            ),
          ),
        if (data.hasSignature)
          Positioned(
            top: _h * _CompanyV4Layout.backSignatureTop,
            left: _w * _CompanyV4Layout.backSignatureSide,
            right: _w * _CompanyV4Layout.backSignatureSide,
            height: _h * _CompanyV4Layout.backSignatureHeight,
            child: Center(
              child: _CompanyV4SignaturePreview(
                path: data.signaturePath,
                bytes: data.signatureBytes,
                hasBorder: data.signatureHasBorder,
                borderColor: data.signatureBorderColor,
                borderWidth: data.signatureBorderWidth,
              ),
            ),
          ),
        Positioned(
          left: _w * _CompanyV4Layout.backFooterSide,
          right: _w * _CompanyV4Layout.backFooterSide,
          bottom: 0,
          height: _h * _CompanyV4Layout.backFooterHeight,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV4BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV4Layout.textDark,
                fontSize: _CompanyV4Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
              onDark: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompanyV4BrandRow extends StatelessWidget {
  const _CompanyV4BrandRow({
    required this.companyName,
    required this.logoAsset,
    required this.nameStyle,
    required this.minNameSize,
    required this.onDark,
  });

  final String companyName;
  final String logoAsset;
  final TextStyle nameStyle;
  final double minNameSize;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final name = companyName.trim();
    final logo = logoAsset.trim();
    final fallbackIconColor =
        onDark ? _CompanyV4Layout.accentRed : _CompanyV4Layout.textDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              logo,
              width: _CompanyV4Layout.logoSize,
              height: _CompanyV4Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.diamond_outlined,
                size: _CompanyV4Layout.logoSize,
                color: fallbackIconColor,
              ),
            ),
          ),
          SizedBox(width: _CompanyV4Layout.logoGap),
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

class _CompanyV4SquarePhoto extends StatelessWidget {
  const _CompanyV4SquarePhoto({
    required this.photoPath,
    required this.size,
    required this.borderWidth,
  });

  final String photoPath;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRect(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(
          Icons.person,
          size: size * 0.45,
          color: const Color(0xFF94A3B8),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, width: size, height: size, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(
        Icons.person,
        size: size * 0.45,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}

class _CompanyV4FrontBody extends StatelessWidget {
  const _CompanyV4FrontBody({
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
          _CompanyV4Layout.frontLineGapMin,
          _CompanyV4Layout.frontLineGapMax,
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

class _CompanyV4CircleBullets extends StatelessWidget {
  const _CompanyV4CircleBullets({
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
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: _CompanyV4Layout.accentRed,
                    shape: BoxShape.circle,
                  ),
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

class _CompanyV4CenteredLines extends StatelessWidget {
  const _CompanyV4CenteredLines({
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

class _CompanyV4SignaturePreview extends StatelessWidget {
  const _CompanyV4SignaturePreview({
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
