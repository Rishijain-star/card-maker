import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 6 — navy / orange geometric theme, rounded-rect photo.
abstract final class _CompanyV6Layout {
  static const Color accentOrange = Color(0xFFF97316);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF6B7280);

  static const double headerBrandTop = 0.055;
  static const double headerBrandHeight = 0.085;
  static const double headerBrandSide = 0.18;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 24;

  static const double frontPhotoWidthRatio = 0.40;
  static const double frontPhotoAspect = 1.18;
  static const double frontPhotoTopRatio = 0.155;
  static const double frontPhotoRadius = 14.0;
  static const double frontGapBelowPhoto = 18.0;
  static const double frontContentSide = 0.18;
  static const double frontContentBottomRatio = 0.10;
  static const double frontNameFontSize = 36;
  static const double frontTitleFontSize = 21;
  static const double frontBodyFontSize = 22;
  static const double frontBodyMinFontSize = 14;
  static const double frontLineGapMin = 6.0;
  static const double frontLineGapMax = 11.0;

  static const double backBrandTop = 0.058;
  static const double backBrandHeight = 0.085;
  static const double backBrandSide = 0.16;

  static const double backTermsTop = 0.155;
  static const double backTermsSide = 0.16;
  static const double backTermsBottom = 0.50;

  static const double backDatesTop = 0.46;
  static const double backDatesHeight = 0.09;
  static const double backDatesSide = 0.16;

  static const double backSignatureTop = 0.56;
  static const double backSignatureHeight = 0.12;
  static const double backSignatureSide = 0.18;
}

class CompanyIdTemplatePortraitV6 extends StatelessWidget {
  const CompanyIdTemplatePortraitV6({
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
    final photoW = _w * _CompanyV6Layout.frontPhotoWidthRatio;
    final photoH = photoW * _CompanyV6Layout.frontPhotoAspect;
    final photoTop = _h * _CompanyV6Layout.frontPhotoTopRatio;
    final photoLeft = (_w - photoW) / 2;
    final contentTop = photoTop + photoH + _CompanyV6Layout.frontGapBelowPhoto;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV6,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV6Layout.headerBrandTop,
          height: _h * _CompanyV6Layout.headerBrandHeight,
          left: _w * _CompanyV6Layout.headerBrandSide,
          right: _w * _CompanyV6Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV6BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV6Layout.textDark,
                fontSize: _CompanyV6Layout.companyNameFontSize,
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
          width: photoW,
          height: photoH,
          child: _CompanyV6RoundedPhoto(
            photoPath: data.photoPath,
            width: photoW,
            height: photoH,
            radius: _CompanyV6Layout.frontPhotoRadius,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV6Layout.frontContentSide,
          right: _w * _CompanyV6Layout.frontContentSide,
          bottom: _h * _CompanyV6Layout.frontContentBottomRatio,
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
                    child: _CompanyV6FrontBody(
                      data: data,
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV6Layout.textDark,
                        fontSize: _CompanyV6Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV6Layout.textMuted,
                        fontSize: _CompanyV6Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV6Layout.textDark,
                        fontSize: _CompanyV6Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      bodyMinFontSize: _CompanyV6Layout.frontBodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV6,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV6Layout.backBrandTop,
          height: _h * _CompanyV6Layout.backBrandHeight,
          left: _w * _CompanyV6Layout.backBrandSide,
          right: _w * _CompanyV6Layout.backBrandSide,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _CompanyV6BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV6Layout.textDark,
                fontSize: _CompanyV6Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
            ),
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV6Layout.backTermsTop,
            left: _w * _CompanyV6Layout.backTermsSide,
            right: _w * _CompanyV6Layout.backTermsSide,
            bottom: _h * _CompanyV6Layout.backTermsBottom,
            child: _CompanyV6CircleBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV6Layout.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: 13,
            ),
          ),
        if (dates.isNotEmpty)
          Positioned(
            top: _h * _CompanyV6Layout.backDatesTop,
            left: _w * _CompanyV6Layout.backDatesSide,
            right: _w * _CompanyV6Layout.backDatesSide,
            height: _h * _CompanyV6Layout.backDatesHeight,
            child: _CompanyV6CenteredLines(
              lines: dates,
              style: _ts(const TextStyle(
                color: _CompanyV6Layout.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
              )),
              minFontSize: 14,
            ),
          ),
        if (data.hasSignature)
          Positioned(
            top: _h * _CompanyV6Layout.backSignatureTop,
            left: _w * _CompanyV6Layout.backSignatureSide,
            right: _w * _CompanyV6Layout.backSignatureSide,
            height: _h * _CompanyV6Layout.backSignatureHeight,
            child: Center(
              child: _CompanyV6SignaturePreview(
                path: data.signaturePath,
                bytes: data.signatureBytes,
                hasBorder: data.signatureHasBorder,
                borderColor: data.signatureBorderColor,
                borderWidth: data.signatureBorderWidth,
              ),
            ),
          ),
      ],
    );
  }
}

class _CompanyV6BrandRow extends StatelessWidget {
  const _CompanyV6BrandRow({
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              logo,
              width: _CompanyV6Layout.logoSize,
              height: _CompanyV6Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.hexagon_outlined,
                size: _CompanyV6Layout.logoSize,
                color: _CompanyV6Layout.accentOrange,
              ),
            ),
          ),
          SizedBox(width: _CompanyV6Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: AutoSizeText(
              name.toUpperCase(),
              maxLines: 2,
              minFontSize: minNameSize,
              textAlign: TextAlign.left,
              style: nameStyle,
            ),
          ),
      ],
    );
  }
}

class _CompanyV6RoundedPhoto extends StatelessWidget {
  const _CompanyV6RoundedPhoto({
    required this.photoPath,
    required this.width,
    required this.height,
    required this.radius,
  });

  final String photoPath;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(
          Icons.person,
          size: width * 0.35,
          color: const Color(0xFF94A3B8),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(
        Icons.person,
        size: width * 0.35,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}

class _CompanyV6FrontBody extends StatelessWidget {
  const _CompanyV6FrontBody({
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
          _CompanyV6Layout.frontLineGapMin,
          _CompanyV6Layout.frontLineGapMax,
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

class _CompanyV6CircleBullets extends StatelessWidget {
  const _CompanyV6CircleBullets({
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
                  decoration: const BoxDecoration(
                    color: _CompanyV6Layout.accentOrange,
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

class _CompanyV6CenteredLines extends StatelessWidget {
  const _CompanyV6CenteredLines({
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

class _CompanyV6SignaturePreview extends StatelessWidget {
  const _CompanyV6SignaturePreview({
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
