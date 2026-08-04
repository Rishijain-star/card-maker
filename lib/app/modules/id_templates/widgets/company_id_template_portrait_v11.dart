import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 11 — green sidebar; main form on front, optional on back.
abstract final class _CompanyV11Layout {
  static const Color accentGreen = Color(0xFF1F6B45);
  static const Color accentGreenLight = Color(0xFF2E8B57);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color sidebarText = Color(0xFFD1D5DB);

  static const double sidebarWidthRatio = 0.23;
  static const double contentRightMarginRatio = 0.04;

  static const double sidebarTextTop = 0.22;
  static const double sidebarTextBottom = 0.22;

  static const double headerTop = 0.07;
  static const double headerHeight = 0.10;
  static const double logoSize = 34.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 22;

  static const double frontPhotoSizeRatio = 0.30;
  static const double frontPhotoCenterYRatio = 0.335;
  static const double frontPhotoBorderWidth = 5.0;
  static const double frontGapBelowPhoto = 14.0;
  static const double frontContentMinTopRatio = 0.47;
  static const double frontContentBottomRatio = 0.16;
  static const double frontNameFontSize = 32;
  static const double frontTitleFontSize = 19;
  static const double frontBodyFontSize = 18;
  static const double frontBodyMinFontSize = 12;
  static const double frontLineGapMin = 4.0;
  static const double frontLineGapMax = 8.0;

  static const double frontSignatureHeight = 0.09;
  static const double frontSignatureBottom = 0.10;

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
  });

  final EmployeeData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);

  double get _contentLeft => _w * _CompanyV11Layout.sidebarWidthRatio;

  double get _contentWidth =>
      _w - _contentLeft - _w * _CompanyV11Layout.contentRightMarginRatio;

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
    final photoSize = _w * _CompanyV11Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV11Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = _contentLeft + (_contentWidth - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV11Layout.frontGapBelowPhoto,
      _h * _CompanyV11Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);
    final position = data.position.trim();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV11,
          fit: BoxFit.fill,
        ),
        if (position.isNotEmpty)
          Positioned(
            left: 0,
            top: _h * _CompanyV11Layout.sidebarTextTop,
            bottom: _h * _CompanyV11Layout.sidebarTextBottom,
            width: _contentLeft,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: AutoSizeText(
                  position.toUpperCase(),
                  maxLines: 1,
                  minFontSize: 10,
                  textAlign: TextAlign.center,
                  style: _ts(const TextStyle(
                    color: _CompanyV11Layout.sidebarText,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    height: 1.0,
                  )),
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
            nameStyle: _ts(const TextStyle(
              color: _CompanyV11Layout.accentGreen,
              fontSize: _CompanyV11Layout.companyNameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
            )),
            minNameSize: 12,
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
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV11Layout.textDark,
                        fontSize: _CompanyV11Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV11Layout.textMuted,
                        fontSize: _CompanyV11Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV11Layout.textDark,
                        fontSize: _CompanyV11Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                      )),
                      bodyMinFontSize: _CompanyV11Layout.frontBodyMinFontSize,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (data.hasSignature)
          Positioned(
            left: _contentLeft,
            width: _contentWidth,
            bottom: _h * _CompanyV11Layout.frontSignatureBottom,
            height: _h * _CompanyV11Layout.frontSignatureHeight,
            child: _CompanyV11SignaturePreview(
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
          CompanyIdTemplateAssets.backBackgroundV11,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV11Layout.backBrandTop,
          height: _h * _CompanyV11Layout.backBrandHeight,
          left: _w * _CompanyV11Layout.backTermsSide,
          right: _w * _CompanyV11Layout.backTermsSide,
          child: _CompanyV11BrandRow(
            companyName: data.companyName,
            logoAsset: data.logoAsset,
            nameStyle: _ts(const TextStyle(
              color: _CompanyV11Layout.accentGreen,
              fontSize: _CompanyV11Layout.companyNameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
            )),
            minNameSize: 12,
          ),
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV11Layout.backTermsTop,
            left: _w * _CompanyV11Layout.backTermsSide,
            right: _w * _CompanyV11Layout.backTermsSide,
            bottom: _h * _CompanyV11Layout.backTermsBottom,
            child: _CompanyV11BackTerms(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV11Layout.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
              )),
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
    final parts = name.split(RegExp(r'\s+'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logo.isNotEmpty) ...[
          ClipOval(
            child: Image.asset(
              logo,
              width: _CompanyV11Layout.logoSize,
              height: _CompanyV11Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: _CompanyV11Layout.logoSize,
                height: _CompanyV11Layout.logoSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      _CompanyV11Layout.accentGreenLight,
                      _CompanyV11Layout.accentGreen,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.business_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: _CompanyV11Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: parts.length >= 2
                ? AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${parts.sublist(0, parts.length - 1).join(' ').toUpperCase()} ',
                          style: nameStyle,
                        ),
                        TextSpan(
                          text: parts.last.toUpperCase(),
                          style: nameStyle.copyWith(
                            color: _CompanyV11Layout.textDark,
                          ),
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

class _CompanyV11FrontBody extends StatelessWidget {
  const _CompanyV11FrontBody({
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
        (bodyStyle.fontSize ?? 18) * (isEmail ? 1.4 : 1.2),
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

class _CompanyV11SignaturePreview extends StatelessWidget {
  const _CompanyV11SignaturePreview({
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
