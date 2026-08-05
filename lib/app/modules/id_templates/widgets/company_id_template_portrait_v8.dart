import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 8 — green swoosh theme (ref: 8th front/back company PNGs).
abstract final class _CompanyV8Layout {
  static const Color accentGreen = Color(0xFF2E8B3C);
  static const Color lightGreen = Color(0xFF5FAF4A);
  static const Color textOnGradient = Colors.white;
  static const Color frameOuter = Color(0xFFA8B0BA);
  static const Color frameInner = Color(0xFFD1D5DB);

  static const double frontPhotoSizeRatio = 0.33;
  static const double frontPhotoCenterYRatio = 0.245;
  static const double frontGapBelowPhoto = 16.0;
  static const double frontContentMinTopRatio = 0.375;
  static const double frontContentSide = 0.14;
  static const double frontNameFontSize = 34;
  static const double frontTitleFontSize = 20;
  static const double frontContactTop = 0.57;
  static const double frontContactSide = 0.22;
  static const double frontContactBottom = 0.14;
  static const double frontContactFontSize = 18;
  static const double frontContactMinFontSize = 13;
  static const double frontContactIconSize = 20.0;
  static const double frontContactGap = 10.0;

  static const double backBrandTop = 0.075;
  static const double backBrandHeight = 0.12;
  static const double backBrandSide = 0.12;
  static const double logoSize = 38.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 26;

  static const double backTermsTop = 0.22;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.28;

  static const double backSignatureRight = 0.12;
  static const double backSignatureBottom = 0.10;
  static const double backSignatureWidth = 0.42;
  static const double backSignatureHeight = 0.12;
}

class CompanyIdTemplatePortraitV8 extends StatelessWidget {
  const CompanyIdTemplatePortraitV8({
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
    final photoSize = _w * _CompanyV8Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV8Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final greetingTop = [
      photoTop + photoSize + _CompanyV8Layout.frontGapBelowPhoto,
      _h * _CompanyV8Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV8,
          fit: BoxFit.fill,
        ),
        if (data.companyName.trim().isNotEmpty)
          Positioned(
            top: _h * 0.035,
            height: _h * 0.075,
            left: _w * 0.08,
            right: _w * 0.08,
            child: Center(
              child: AutoSizeText(
                data.companyName,
                maxLines: 2,
                minFontSize: 12,
                textAlign: TextAlign.center,
                style: _tsPrimary(const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                )),
              ),
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoSize,
          height: photoSize,
          child: _CompanyV8FramedPhoto(
            photoPath: data.photoPath,
            size: photoSize,
          ),
        ),
        Positioned(
          top: greetingTop,
          left: _w * _CompanyV8Layout.frontContentSide,
          right: _w * _CompanyV8Layout.frontContentSide,
          height: _h * 0.14,
          child: _CompanyV8GreetingBlock(
            employeeName: data.employeeName,
            position: data.position,
            nameStyle: _tsPrimary(const TextStyle(
              color: _CompanyV8Layout.accentGreen,
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
            )),
            titleStyle: _tsPrimary(const TextStyle(
              color: _CompanyV8Layout.lightGreen,
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
            )),
            minFontSize: IdCardPortraitTypography.nameMinFontSize,
          ),
        ),
        Positioned(
          top: _h * _CompanyV8Layout.frontContactTop,
          left: _w * _CompanyV8Layout.frontContactSide,
          right: _w * _CompanyV8Layout.frontContactSide,
          bottom: _h * _CompanyV8Layout.frontContactBottom,
          child: _CompanyV8ContactRows(
            data: data,
            valueStyle: _tsPrimary(const TextStyle(
              color: _CompanyV8Layout.accentGreen,
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.2,
            )),
            minFontSize: IdCardPortraitTypography.bodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV8,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV8Layout.backBrandTop,
          height: _h * _CompanyV8Layout.backBrandHeight,
          left: _w * _CompanyV8Layout.backBrandSide,
          right: _w * _CompanyV8Layout.backBrandSide,
          child: _CompanyV8BrandColumn(
            companyName: data.companyName,
            logoAsset: data.logoAsset,
            nameStyle: _ts(const TextStyle(
              color: _CompanyV8Layout.textOnGradient,
              fontSize: _CompanyV8Layout.companyNameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            minNameSize: 14,
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV8Layout.backTermsTop,
            left: _w * _CompanyV8Layout.backTermsSide,
            right: _w * _CompanyV8Layout.backTermsSide,
            bottom: _h * _CompanyV8Layout.backTermsBottom,
            child: _CompanyV8DotBullets(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV8Layout.textOnGradient,
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: 12,
            ),
          ),

      ],
    );
  }
}

class _CompanyV8FramedPhoto extends StatelessWidget {
  const _CompanyV8FramedPhoto({
    required this.photoPath,
    required this.size,
  });

  final String photoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final inner = size - 16;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: _CompanyV8Layout.frameOuter,
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: _CompanyV8Layout.frameInner,
        ),
        padding: const EdgeInsets.all(4),
        child: ClipOval(child: _buildImage(inner - 8)),
      ),
    );
  }

  Widget _buildImage(double diameter) {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(
          Icons.person,
          size: diameter * 0.45,
          color: const Color(0xFF94A3B8),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, width: diameter, height: diameter, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(
        Icons.person,
        size: diameter * 0.45,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}

class _CompanyV8GreetingBlock extends StatelessWidget {
  const _CompanyV8GreetingBlock({
    required this.employeeName,
    required this.position,
    required this.nameStyle,
    required this.titleStyle,
    required this.minFontSize,
  });

  final String employeeName;
  final String position;
  final TextStyle nameStyle;
  final TextStyle titleStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    String cap(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final name = cap(employeeName);
    final title = cap(position);
    if (name.isEmpty && title.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (name.isNotEmpty)
          AutoSizeText(
            name,
            maxLines: 2,
            minFontSize: minFontSize + 2,
            textAlign: TextAlign.center,
            style: nameStyle,
          ),
        if (title.isNotEmpty) ...[
          const SizedBox(height: 4),
          AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: minFontSize,
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
        ],
      ],
    );
  }
}

class _CompanyV8ContactRows extends StatelessWidget {
  const _CompanyV8ContactRows({
    required this.data,
    required this.valueStyle,
    required this.minFontSize,
  });

  final EmployeeData data;
  final TextStyle valueStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <({IconData icon, String value})>[];
    void add(IconData icon, String value) {
      final v = value.trim();
      if (v.isNotEmpty) rows.add((icon: icon, value: v));
    }

    add(Icons.badge_outlined, data.employeeId);
    add(Icons.event_outlined, data.joinDate);
    add(Icons.email_outlined, data.email);
    add(Icons.phone_outlined, data.phone);
    add(Icons.bloodtype_outlined, data.bloodGroup);

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: _CompanyV8Layout.frontContactGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                rows[i].icon,
                size: _CompanyV8Layout.frontContactIconSize,
                color: _CompanyV8Layout.accentGreen,
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

class _CompanyV8BrandColumn extends StatelessWidget {
  const _CompanyV8BrandColumn({
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              logo,
              width: _CompanyV8Layout.logoSize,
              height: _CompanyV8Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.eco_outlined,
                size: _CompanyV8Layout.logoSize,
                color: _CompanyV8Layout.textOnGradient,
              ),
            ),
          )
        else
          const Icon(
            Icons.eco_outlined,
            size: _CompanyV8Layout.logoSize,
            color: _CompanyV8Layout.textOnGradient,
          ),
        if (name.isNotEmpty) ...[
          SizedBox(height: logo.isNotEmpty ? _CompanyV8Layout.logoGap : 0),
          AutoSizeText(
            name.toUpperCase(),
            maxLines: 2,
            minFontSize: minNameSize,
            textAlign: TextAlign.center,
            style: nameStyle,
          ),
        ],
      ],
    );
  }
}

class _CompanyV8DotBullets extends StatelessWidget {
  const _CompanyV8DotBullets({
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
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) const SizedBox(height: 18),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _CompanyV8Layout.textOnGradient,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            lines[i],
            maxLines: 5,
            minFontSize: minFontSize,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ],
    );
  }
}

class _CompanyV8SignaturePreview extends StatelessWidget {
  const _CompanyV8SignaturePreview({
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
