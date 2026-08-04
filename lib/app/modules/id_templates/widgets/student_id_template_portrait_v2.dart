import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Pixel-accurate measurements from background PNG (1024×1536 → Flutter 638×1012)
/// Scale: sw=0.6230, sh=0.6589
///
/// Grey circle (image px):  x=300..723, y=162..599
/// White border starts:     y=137 (image) → 90px flutter
/// Circle x-diameter:       423px image → 263px flutter (ratio 0.413 of W)
/// White left edge:         x=258 image → 161px flutter (ratio 0.252)
/// Circle bottom:           y=599 image → 395px flutter (ratio 0.390)
abstract final class _PortraitV2Layout {
  // ── Typography (same as Template 2 / student_id_template_portrait.dart) ─────
  static const double headerFontSize = IdCardPortraitTypography.headerFontSize;
  static const double headerMinFontSize = IdCardPortraitTypography.headerMinFontSize;
  static const double nameFontSize = IdCardPortraitTypography.nameFontSize;
  static const double nameMinFontSize = IdCardPortraitTypography.nameMinFontSize;
  static const double bodyFontSize = IdCardPortraitTypography.bodyFontSize;
  static const double bodyMinFontSize = IdCardPortraitTypography.bodyMinFontSize;
  static const double validityFontSize = 17;
  static const double validityMinFontSize = 13;
  static const double addressFontSize = 20;
  static const double addressMinFontSize = 15;
  static const double backHeaderFontSize = 28;
  static const double backBodyFontSize = 27;
  static const double backMinFontSize = 18;

  // ── Front — photo circle ────────────────────────────────────────────────────
  static const double frontPhotoTopRatio  = 0.0950; // nudge up ~10px on 1012h
  static const double frontPhotoSizeRatio = 0.4647; // 296.5 / 638
  static const double frontPhotoBorderWidth = 4.0;

  // ── Front — institute name ──────────────────────────────────────────────────
  // Green band is from top to ~90px (photo_top). Name lives in top 90px.
  // Left from card left edge, right stops before circle left (~28% of W)
  static const double frontInstituteTop    = 0.015;
  static const double frontInstituteHeight = 0.080;
  static const double frontInstituteLeftRatio  = 0.05;
  static const double frontInstituteRightRatio = 0.05;

  // ── Front — student name (just below circle) ────────────────────────────────
  // Circle bottom moved down → name top updated accordingly
  // Extra gap added between circle bottom and name for breathing room
  static const double frontNameTopRatio    = 0.420;
  static const double frontNameHeightRatio = 0.060;
  static const double frontNameLeftRatio   = 0.290; // shifted right for clean separation
  static const double frontNameRightRatio  = 0.04;

  // ── Front — body lines ──────────────────────────────────────────────────────
  // Starts after name: updated top + right-shifted left margin
  static const double frontBodyTopRatio    = 0.485;
  static const double frontBodyLeftRatio   = 0.290; // matches name left
  static const double frontBodyRightRatio  = 0.04;
  static const double frontBodyBottomRatio = 0.120;

  static const double frontGapMin    = 15.0;
  static const double frontGapMax    = 25.0;
  static const double frontGapSpread = 0.96;
  static const double frontGapRelaxedMin    = 22.0;
  static const double frontGapRelaxedMax    = 34.0;
  static const double frontGapRelaxedSpread = 1.05;

  // ── Front — signature ───────────────────────────────────────────────────────
  static const double frontSignatureSizeRatio   = 0.12;
  static const double frontSignatureRightRatio  = 0.04;
  static const double frontSignatureBottomRatio = 0.120;

  // ── Front — address (bottom) ────────────────────────────────────────────────
  static const double frontAddressBottomRatio = 0.018;
  static const double frontAddressLeftRatio   = 0.320; // slightly right of body block
  static const double frontAddressRightRatio  = 0.04;
  static const double frontAddressHeightRatio = 0.095;

  // ── Back ─────────────────────────────────────────────────────────────────────
  static const double backBodyTopRatio    = 0.10;
  static const double backBodyLeftRatio   = 0.08;
  static const double backBodyRightRatio  = 0.32;
  static const double backBodyBottomRatio = 0.18;
  static const double backGapMin    = 14.0;
  static const double backGapMax    = 24.0;
  static const double backGapSpread = 0.96;
  static const double backInstituteBottomRatio = 0.04;
  static const double backInstituteLeftRatio   = 0.08;
  static const double backInstituteRightRatio  = 0.32;
}

class StudentIdTemplatePortraitV2 extends StatelessWidget {
  const StudentIdTemplatePortraitV2({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);

  static int _instituteMaxLines(String name) {
    if (name.contains('\n')) {
      final lines = name.split('\n').where((s) => s.trim().isNotEmpty).length;
      return lines.clamp(2, 4);
    }
    return 1;
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
    final bodyLines = data.frontBodyLines;

    // Photo: size includes the white border so it covers the entire PNG circle.
    final photoSize = _w * _PortraitV2Layout.frontPhotoSizeRatio; // ~296px
    final photoTop  = _h * _PortraitV2Layout.frontPhotoTopRatio;  // shifted down
    final photoLeft = (_w - photoSize) / 2;                        // centered

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV2,
          fit: BoxFit.fill,
        ),

        // Institute name — green top band, centered; wrap only if very long
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top:    _h * _PortraitV2Layout.frontInstituteTop,
            height: _h * _PortraitV2Layout.frontInstituteHeight,
            left:   _w * _PortraitV2Layout.frontInstituteLeftRatio,
            right:  _w * _PortraitV2Layout.frontInstituteRightRatio,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: _PortraitV2Layout.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: _PortraitV2Layout.headerFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: 0.3,
                )),
              ),
            ),
          ),

        // Photo — exactly over the PNG circle
        Positioned(
          top:    photoTop,
          left:   photoLeft,
          width:  photoSize,
          height: photoSize,
          child: StudentPortraitPhoto(
            photoPath: data.photoPath,
            size: photoSize,
            borderColor: Colors.white,
            borderWidth: _PortraitV2Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: false,
          ),
        ),

        // Student name — just below circle, in white area
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top:    _h * _PortraitV2Layout.frontNameTopRatio,
            height: _h * _PortraitV2Layout.frontNameHeightRatio,
            left:   _w * _PortraitV2Layout.frontNameLeftRatio,
            right:  _w * _PortraitV2Layout.frontNameRightRatio,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.formattedStudentName,
                maxLines: 1,
                minFontSize: _PortraitV2Layout.nameMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: _PortraitV2Layout.nameFontSize,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 1.1,
                )),
              ),
            ),
          ),

        // Body lines
        Positioned(
          top:    _h * _PortraitV2Layout.frontBodyTopRatio,
          left:   _w * _PortraitV2Layout.frontBodyLeftRatio,
          right:  _w * _PortraitV2Layout.frontBodyRightRatio,
          bottom: _h * _PortraitV2Layout.frontBodyBottomRatio,
          child: _LabeledBodyList(
            fatherName: data.fatherName,
            className: data.className,
            fatherStyle: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: _PortraitV2Layout.nameFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.1,
              letterSpacing: 0.5,
            )),
            courseStyle: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: _PortraitV2Layout.nameFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.1,
              letterSpacing: 0.5,
            )),
            lines: data.frontDetailLines,
            footerLine: data.frontValidityHorizontalLine,
            fontFamily: fontFamily,
            bodyStyle: _ts(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: _PortraitV2Layout.bodyFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.1,
              letterSpacing: 0.5,
            )),
            bodyMinFontSize: _PortraitV2Layout.bodyMinFontSize,
            footerStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: _PortraitV2Layout.validityFontSize,
              fontWeight: FontWeight.w900,
              height: 1.2,
            )),
            footerMinFontSize: _PortraitV2Layout.validityMinFontSize,
            gapMin: _PortraitV2Layout.frontGapMin,
            gapMax: _PortraitV2Layout.frontGapMax,
            gapSpread: _PortraitV2Layout.frontGapSpread,
            gapRelaxedMin: _PortraitV2Layout.frontGapRelaxedMin,
            gapRelaxedMax: _PortraitV2Layout.frontGapRelaxedMax,
            gapRelaxedSpread: _PortraitV2Layout.frontGapRelaxedSpread,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),

        // Signature
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
    final lines = data.backDetailLines;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.backBackgroundV2,
          fit: BoxFit.fill,
        ),
        Positioned(
          top:    _h * _PortraitV2Layout.backBodyTopRatio,
          left:   _w * _PortraitV2Layout.backBodyLeftRatio,
          right:  _w * _PortraitV2Layout.backBodyRightRatio,
          bottom: _h * _PortraitV2Layout.backBodyBottomRatio,
          child: StudentPortraitEvenContent(
            lines: lines,
            fontFamily: fontFamily,
            bodyStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: _PortraitV2Layout.backBodyFontSize,
              fontWeight: FontWeight.w600,
              height: 1.35,
            )),
            bodyMinFontSize: _PortraitV2Layout.backMinFontSize,
            maxLinesPerItem: 4,
            compactSpacing: data.useCompactFrontSpacing,
            referenceBodyFontSize: _PortraitV2Layout.backBodyFontSize,
            gapMin: _PortraitV2Layout.backGapMin,
            gapMax: _PortraitV2Layout.backGapMax,
            gapSpreadFactor: _PortraitV2Layout.backGapSpread,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            left:   _w * _PortraitV2Layout.backInstituteLeftRatio,
            right:  _w * _PortraitV2Layout.backInstituteRightRatio,
            bottom: _h * _PortraitV2Layout.backInstituteBottomRatio,
            height: _h * 0.08,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: 2,
                minFontSize: _PortraitV2Layout.headerMinFontSize,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: _PortraitV2Layout.backHeaderFontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                )),
              ),
            ),
          ),
      ],
    );
  }
}

/// Labeled body lines + optional validity footer, evenly spaced.
class _LabeledBodyList extends StatelessWidget {
  const _LabeledBodyList({
    required this.lines,
    required this.fontFamily,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.fatherName = '',
    this.className = '',
    this.fatherStyle,
    this.courseStyle,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
    this.gapMin = 14.0,
    this.gapMax = 24.0,
    this.gapSpread = 0.96,
    this.gapRelaxedMin = 22.0,
    this.gapRelaxedMax = 34.0,
    this.gapRelaxedSpread = 1.05,
    this.compactSpacing = false,
    this.relaxedSpacing = false,
  });

  final List<String> lines;
  final String fontFamily;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final String fatherName;
  final String className;
  final TextStyle? fatherStyle;
  final TextStyle? courseStyle;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final double gapMin;
  final double gapMax;
  final double gapSpread;
  final double gapRelaxedMin;
  final double gapRelaxedMax;
  final double gapRelaxedSpread;
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
    if (father.isNotEmpty) {
      blocks.add(AutoSizeText(
        father,
        maxLines: 1,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.left,
        style: fatherStyle ?? bodyStyle,
      ));
    }

    final course = _cap(className);
    if (course.isNotEmpty) {
      blocks.add(AutoSizeText(
        course,
        maxLines: 1,
        minFontSize: bodyMinFontSize,
        textAlign: TextAlign.left,
        style: courseStyle ?? bodyStyle,
      ));
    }

    for (final rawLine in lines) {
      final subLines = rawLine.split('\n');
      for (final line in subLines) {
        final v = line.trim();
        if (v.isEmpty) continue;
        blocks.add(AutoSizeText(
          _cap(v),
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.left,
          style: bodyStyle,
        ));
      }
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(AutoSizeText(
        footer,
        maxLines: 1,
        minFontSize: footerMinFontSize,
        textAlign: TextAlign.left,
        style: footerStyle,
      ));
    }

    if (blocks.isEmpty) return const SizedBox.shrink();
    if (blocks.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final gapCount = blocks.length - 1;
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

      final bodySize   = bodyStyle.fontSize ?? 27.0;
      final estContent = blocks.length * bodySize * 1.35;
      final free = (constraints.maxHeight - estContent).clamp(0.0, double.infinity);
      final gap  = ((free / gapCount) * spread).clamp(eGapMin, eGapMax);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        ),
      );
    });
  }
}