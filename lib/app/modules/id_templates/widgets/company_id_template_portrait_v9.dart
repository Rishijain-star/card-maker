import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 9 — navy wave; all main form fields on front, optional on back.
abstract final class _CompanyV9Layout {
  static const Color accentNavy = Color(0xFF1E2A4A);
  static const Color textDark = Color(0xFF2D3748);
  static const Color textMuted = Color(0xFF64748B);
  static const Color headerText = Colors.white;
  static const Color dividerColor = Color(0xFFCBD5E1);

  static const double headerBrandTop = 0.055;
  static const double headerBrandHeight = 0.10;
  static const double headerBrandSide = 0.12;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 24;

  static const double frontPhotoSizeRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.505;
  static const double frontPhotoBorderWidth = 5.0;
  static const double frontGapBelowPhoto = 18.0;
  static const double frontContentMinTopRatio = 0.555;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.08;
  static const double frontNameFontSize = 34;
  static const double frontTitleFontSize = 20;
  static const double frontBodyFontSize = 20;
  static const double frontBodyMinFontSize = 13;
  static const double frontLineGapMin = 5.0;
  static const double frontLineGapMax = 10.0;

  static const double backTermsTop = 0.08;
  static const double backTermsSide = 0.14;
  static const double backTermsBottom = 0.48;

  static const double backFooterHeight = 0.42;
  static const double backFooterSide = 0.10;
}

class CompanyIdTemplatePortraitV9 extends StatelessWidget {
  const CompanyIdTemplatePortraitV9({
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

  List<String> _frontLines(EmployeeData data) {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.employeeId);
    add(data.joinDate);
    add(data.expireDate);
    add(data.phone);
    add(data.email);
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
    final photoSize = _w * _CompanyV9Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV9Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV9Layout.frontGapBelowPhoto,
      _h * _CompanyV9Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV9,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV9Layout.headerBrandTop,
          height: _h * _CompanyV9Layout.headerBrandHeight,
          left: _w * _CompanyV9Layout.headerBrandSide,
          right: _w * _CompanyV9Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV9BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV9Layout.headerText,
                fontSize: _CompanyV9Layout.companyNameFontSize,
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
            borderColor: Colors.white,
            borderWidth: _CompanyV9Layout.frontPhotoBorderWidth,
            padding: 2,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV9Layout.frontContentSide,
          right: _w * _CompanyV9Layout.frontContentSide,
          bottom: _h * _CompanyV9Layout.frontContentBottomRatio,
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
                    child: _CompanyV9FrontBody(
                      employeeName: data.employeeName,
                      position: data.position,
                      detailLines: _frontLines(data),
                      nameStyle: _ts(const TextStyle(
                        color: _CompanyV9Layout.textDark,
                        fontSize: _CompanyV9Layout.frontNameFontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      )),
                      titleStyle: _ts(const TextStyle(
                        color: _CompanyV9Layout.textMuted,
                        fontSize: _CompanyV9Layout.frontTitleFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      )),
                      bodyStyle: _ts(const TextStyle(
                        color: _CompanyV9Layout.textDark,
                        fontSize: _CompanyV9Layout.frontBodyFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.26,
                      )),
                      bodyMinFontSize: _CompanyV9Layout.frontBodyMinFontSize,
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
          CompanyIdTemplateAssets.backBackgroundV9,
          fit: BoxFit.fill,
        ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _CompanyV9Layout.backTermsTop,
            left: _w * _CompanyV9Layout.backTermsSide,
            right: _w * _CompanyV9Layout.backTermsSide,
            bottom: _h * _CompanyV9Layout.backTermsBottom,
            child: _CompanyV9BackTerms(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: _CompanyV9Layout.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.36,
              )),
              minFontSize: 12,
            ),
          ),
        Positioned(
          left: _w * _CompanyV9Layout.backFooterSide,
          right: _w * _CompanyV9Layout.backFooterSide,
          bottom: 0,
          height: _h * _CompanyV9Layout.backFooterHeight,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV9BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV9Layout.headerText,
                fontSize: _CompanyV9Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
            ),
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.035,
            bottom: _h * 0.16,
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
}

class _CompanyV9BrandRow extends StatelessWidget {
  const _CompanyV9BrandRow({
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
              width: _CompanyV9Layout.logoSize,
              height: _CompanyV9Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.play_arrow_rounded,
                size: _CompanyV9Layout.logoSize,
                color: _CompanyV9Layout.headerText,
              ),
            ),
          ),
          SizedBox(width: _CompanyV9Layout.logoGap),
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

class _CompanyV9FrontBody extends StatelessWidget {
  const _CompanyV9FrontBody({
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

    final name = employeeName.trim();
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 2,
          minFontSize: bodyMinFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 34) * 1.1,
      );
      add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          width: 120,
          height: 1.2,
          color: _CompanyV9Layout.dividerColor,
        ),
        8,
      );
    }

    final title = position.trim();
    if (title.isNotEmpty) {
      add(
        AutoSizeText(
          title.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        (titleStyle.fontSize ?? 20) * 1.15,
      );
    }

    for (final line in detailLines) {
      final isEmail = line.contains('@');
      add(
        AutoSizeText(
          line,
          maxLines: isEmail ? 2 : 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 20) * (isEmail ? 1.4 : 1.2),
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
          _CompanyV9Layout.frontLineGapMin,
          _CompanyV9Layout.frontLineGapMax,
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

class _CompanyV9BackTerms extends StatelessWidget {
  const _CompanyV9BackTerms({
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
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _CompanyV9Layout.accentNavy.withValues(alpha: 0.85),
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
