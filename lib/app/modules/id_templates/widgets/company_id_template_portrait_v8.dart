import 'dart:io';

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

/// Company template 8 — green swoosh theme (ref: 8th front/back company PNGs).
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV8Layout {
  /// Decorative only (icons, bullet dots, photo frame) — never text.
  static const Color accentGreen = Color(0xFF2E8B3C);
  static const Color textOnGradient = Colors.white;
  static const Color frameOuter = Color(0xFFA8B0BA);
  static const Color frameInner = Color(0xFFD1D5DB);

  static const double frontPhotoSizeRatio = 0.33;
  static const double frontPhotoCenterYRatio = 0.245;
  static const double frontGapBelowPhoto = 8.0;
  static const double frontContentMinTopRatio = 0.34;
  static const double frontContentSide = 0.14;
  static const double frontContactTop = 0.57;
  static const double frontContactSide = 0.22;
  static const double frontContactBottom = 0.14;
  static const double frontContactIconSize = 20.0;
  static const double frontContactGap = 10.0;

  static const double backBrandTop = 0.075;
  static const double backBrandHeight = 0.12;
  static const double logoSize = 38.0;
  static const double logoGap = 8.0;

  static const double backTermsTop = 0.22;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.28;
}

class CompanyIdTemplatePortraitV8 extends StatelessWidget {
  const CompanyIdTemplatePortraitV8({
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
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV8,
          fit: BoxFit.fill,
        ),
        if (data.companyName.trim().isNotEmpty)
          Positioned(
            top: _h * 0.038,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.companyName,
              fontFamily: fontFamily,
              color: Colors.white,
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
          bottom: _h * 0.10,
          child: _CompanyV8FrontBody(
            data: data,
            nameStyle: IdCardTextStyles.personName(fontFamily),
            titleStyle: IdCardTextStyles.position(fontFamily),
            bodyStyle: IdCardTextStyles.detail(fontFamily),
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV8,
          fit: BoxFit.fill,
        ),
        if (data.companyName.trim().isNotEmpty)
          Positioned(
            top: _h * 0.038,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.companyName,
              fontFamily: fontFamily,
              color: Colors.white,
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * 0.16,
            left: _w * _CompanyV8Layout.backTermsSide,
            right: _w * _CompanyV8Layout.backTermsSide,
            bottom: _h * 0.15,
            child: _CompanyV8DotBullets(
              lines: terms,
              textStyle: IdCardTextStyles.terms(fontFamily, onBanner: true),
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

class _CompanyV8FrontBody extends StatelessWidget {
  const _CompanyV8FrontBody({
    required this.data,
    required this.nameStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.minFontSize,
  });

  final EmployeeData data;
  final TextStyle nameStyle;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
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

    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    final name = cap(data.employeeName);
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 2,
          minFontSize: minFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 42) * 1.08,
      );
    }

    final title = cap(data.position);
    if (title.isNotEmpty) {
      add(
        AutoSizeText(
          title,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        (titleStyle.fontSize ?? 42) * 1.08,
      );
    }

    final detailLines = data.frontDetailLines;
    for (var i = 0; i < detailLines.length; i++) {
      final line = detailLines[i];
      final isEmail = line.contains('@');
      final isStudentProminentLine = data.isStudentData && i < 2;
      final lineStyle = isStudentProminentLine ? nameStyle : bodyStyle;
      final lineMinFont =
          isStudentProminentLine ? (minFontSize + 4) : minFontSize;

      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: lineMinFont,
          textAlign: TextAlign.center,
          style: lineStyle,
        ),
        (lineStyle.fontSize ?? 32) *
            (isEmail ? 1.45 : (isStudentProminentLine ? 1.08 : 1.22)),
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    final gapCount = blocks.length - 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalEstH = estimates.fold<double>(0, (a, b) => a + b);
        final availH = constraints.maxHeight;
        double gap = 6.0;
        if (gapCount > 0 && availH > totalEstH) {
          gap = ((availH - totalEstH) / gapCount).clamp(4.0, 14.0);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < blocks.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              blocks[i],
            ],
          ],
        );
      },
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
    final hasLogo = logo.isNotEmpty && !logo.contains('eco');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasLogo)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              logo,
              width: _CompanyV8Layout.logoSize,
              height: _CompanyV8Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        if (name.isNotEmpty) ...[
          SizedBox(height: hasLogo ? _CompanyV8Layout.logoGap : 0),
          AutoSizeText(
            name.replaceAll('\n', ' ').trim().toUpperCase(),
            maxLines: 2,
            minFontSize: 14,
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
