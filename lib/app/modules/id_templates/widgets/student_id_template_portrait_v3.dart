import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_text_styles.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Layout tuned for 3rd portrait PNG (1024×1536 → 638×1012).
/// Ref: purple diamond header, photo straddling header/body line, centered name/body.
abstract final class _PortraitV3Layout {
  // ── Front — institute (purple header, centered) ──────────────────────────────
  static const double frontInstituteTop = 0.032;
  static const double frontInstituteHeight = 0.115;
  static const double frontInstituteLeftRatio = 0.05;
  static const double frontInstituteRightRatio = 0.05;

  // ── Front — photo circle on purple/white seam (~y 255 / 1012) ───────────────
  static const double frontPhotoSizeRatio = 0.30;
  static const double frontPhotoCenterYRatio = 0.252;
  static const double frontPhotoBorderWidth = 4.0;

  // ── Front — name (centered, white body) ─────────────────────────────────────
  static const double frontNameTopRatio = 0.385;
  static const double frontNameHeightRatio = 0.068;
  static const double frontNameSideRatio = 0.08;

  // ── Front — body (centered column) ──────────────────────────────────────────
  static const double frontBodyTopRatio = 0.455;
  static const double frontBodySideRatio = 0.10;
  static const double frontBodyBottomRatio = 0.18;

  // ── Back — terms in upper white; institute in bottom purple art ─────────────
  static const double backBodyTopRatio = 0.16;
  static const double backBodySideRatio = 0.12;
  static const double backBodyBottomRatio = 0.15;
  static const double backInstituteTopRatio = 0.038;
  static const double backInstituteSideRatio = 0.05;
  static const double backInstituteHeightRatio = 0.08;
}

class StudentIdTemplatePortraitV3 extends StatelessWidget {
  const StudentIdTemplatePortraitV3({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
    this.headerTextColor,
    this.backHeaderTextColor,
    this.isBackHeaderAtTop = false,
    this.isBackTermsShiftedDown = false,
    this.isBackTermsBold = false,
    this.frontInstituteTopOverride,
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;
  final Color? headerTextColor;
  final Color? backHeaderTextColor;
  final bool isBackHeaderAtTop;
  final bool isBackTermsShiftedDown;
  final bool isBackTermsBold;
  final double? frontInstituteTopOverride;

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
    final photoSize = _w * _PortraitV3Layout.frontPhotoSizeRatio;
    final photoTop = _h * _PortraitV3Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? StudentIdTemplateAssets.frontBackgroundV3,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * (frontInstituteTopOverride ?? _PortraitV3Layout.frontInstituteTop),
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
              color: headerTextColor,
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
            borderWidth: _PortraitV3Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV3Layout.frontNameTopRatio,
            height: _h * _PortraitV3Layout.frontNameHeightRatio,
            left: _w * _PortraitV3Layout.frontNameSideRatio,
            right: _w * _PortraitV3Layout.frontNameSideRatio,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                data.formattedStudentName,
                maxLines: 1,
                minFontSize: IdCardPortraitTypography.nameMinFontSize,
                textAlign: TextAlign.center,
                style: IdCardTextStyles.personName(fontFamily),
              ),
            ),
          ),
        Positioned(
          top: _h * _PortraitV3Layout.frontBodyTopRatio,
          left: _w * _PortraitV3Layout.frontBodySideRatio,
          right: _w * _PortraitV3Layout.frontBodySideRatio,
          bottom: _h * _PortraitV3Layout.frontBodyBottomRatio,
          child: _PortraitV3BodyList(
            fatherName: data.fatherName,
            className: data.className,
            fatherStyle: IdCardTextStyles.fatherName(fontFamily),
            courseStyle: IdCardTextStyles.course(fontFamily),
            lines: data.frontDetailLines,
            footerLine: data.frontValidityHorizontalLine,
            bodyStyle: IdCardTextStyles.detail(fontFamily),
            bodyMinFontSize: IdCardPortraitTypography.bodyMinFontSize,
            footerStyle: IdCardTextStyles.footer(fontFamily),
            footerMinFontSize: IdCardPortraitTypography.validityMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
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
          backBgAsset ?? StudentIdTemplateAssets.backBackgroundV3,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * (isBackTermsShiftedDown ? 0.20 : _PortraitV3Layout.backBodyTopRatio),
          left: _w * _PortraitV3Layout.backBodySideRatio,
          right: _w * _PortraitV3Layout.backBodySideRatio,
          bottom: _h * (isBackTermsShiftedDown ? 0.12 : 0.13),
          child: StudentPortraitEvenContent(
            lines: terms,
            fontFamily: fontFamily,
            bodyStyle: isBackTermsBold
                ? IdCardTextStyles.terms(fontFamily).copyWith(fontWeight: FontWeight.w600)
                : IdCardTextStyles.terms(fontFamily),
            bodyMinFontSize: IdCardPortraitTypography.backBodyMinFontSize,
            maxLinesPerItem: 4,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
            referenceBodyFontSize: IdCardPortraitTypography.backBodyFontSize,
            gapMin: IdCardPortraitTypography.backGapMin,
            gapMax: IdCardPortraitTypography.backGapMax,
            gapSpreadFactor: IdCardPortraitTypography.backGapSpread,
          ),
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: isBackHeaderAtTop ? _h * (frontInstituteTopOverride ?? _PortraitV3Layout.backInstituteTopRatio) : null,
            bottom: isBackHeaderAtTop ? null : _h * 0.035,
            left: _w * 0.05,
            right: _w * 0.05,
            child: GlobalInstituteHeader(
              name: data.instituteName,
              fontFamily: fontFamily,
              color: backHeaderTextColor ?? headerTextColor,
            ),
          ),
      ],
    );
  }
}

/// Centered body lines + validity footer with adaptive vertical gaps.
class _PortraitV3BodyList extends StatelessWidget {
  const _PortraitV3BodyList({
    required this.lines,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.fatherName = '',
    this.className = '',
    this.fatherStyle,
    this.courseStyle,
    this.compactSpacing = false,
    this.relaxedSpacing = false,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
  });

  final List<String> lines;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final String fatherName;
  final String className;
  final TextStyle? fatherStyle;
  final TextStyle? courseStyle;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  static String _cap(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '';
    return s
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];

    final father = _cap(fatherName);
    if (father.isNotEmpty && fatherStyle != null) {
      blocks.add(AutoSizeText(
        father,
        maxLines: 1,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.center,
        style: fatherStyle,
      ));
    }

    final course = _cap(className);
    if (course.isNotEmpty && courseStyle != null) {
      blocks.add(AutoSizeText(
        course,
        maxLines: 1,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.center,
        style: courseStyle,
      ));
    }

    for (final line in lines) {
      blocks.add(AutoSizeText(
        _cap(line),
        maxLines: 2,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.center,
        style: bodyStyle,
      ));
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(AutoSizeText(
        footer,
        maxLines: 1,
        minFontSize: footerMinFontSize,
        textAlign: TextAlign.center,
        style: footerStyle,
      ));
    }

    if (blocks.isEmpty) return const SizedBox.shrink();
    if (blocks.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: blocks,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final gapCount = blocks.length - 1;
      final gapMin = IdCardPortraitTypography.frontGapMin;
      final gapMax = IdCardPortraitTypography.frontGapMax;
      final gapSpread = IdCardPortraitTypography.frontGapSpread;
      final gapRelaxedMin = IdCardPortraitTypography.frontGapRelaxedMin;
      final gapRelaxedMax = IdCardPortraitTypography.frontGapRelaxedMax;
      final gapRelaxedSpread = IdCardPortraitTypography.frontGapRelaxedSpread;

      final eGapMin = compactSpacing
          ? 6.0
          : relaxedSpacing
              ? gapRelaxedMin
              : gapMin;
      final eGapMax = compactSpacing
          ? 12.0
          : relaxedSpacing
              ? gapRelaxedMax
              : gapMax;
      final spread = compactSpacing
          ? 0.78
          : relaxedSpacing
              ? gapRelaxedSpread
              : gapSpread;

      final bodySize = bodyStyle.fontSize ?? IdCardPortraitTypography.bodyFontSize;
      final estContent = blocks.length * bodySize * 1.28;
      final free =
          (constraints.maxHeight - estContent).clamp(0.0, double.infinity);
      final gap = ((free / gapCount) * spread).clamp(eGapMin, eGapMax);

      final children = <Widget>[];
      for (var i = 0; i < blocks.length; i++) {
        if (i > 0) children.add(SizedBox(height: gap));
        children.add(blocks[i]);
      }
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        ),
      );
    });
  }
}
