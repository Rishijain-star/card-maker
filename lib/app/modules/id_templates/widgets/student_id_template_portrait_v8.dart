import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 8 — chevron navy/orange/cyan PNG, circle photo, split name (1024×1536 → 638×1012).
abstract final class _PortraitV8Layout {
  static const Color accentCyan = StudentPortraitTemplate4Colors.accentCyan;
  static const Color accentOrange = Color(0xFFF97316);

  static const double frontInstituteTop = 0.036;
  static const double frontInstituteHeight = 0.095;
  static const double frontInstituteSide = 0.08;

  static const double frontPhotoSizeRatio = 0.32;
  static const double frontPhotoCenterYRatio = 0.268;
  static const double frontPhotoWhiteBorder = 5.5;
  static const double frontPhotoCyanBorder = 3.0;
  static const double frontGapBelowPhoto = 22.0;
  static const double frontContentSide = 0.11;
  static const double frontContentBottomRatio = 0.14;
  static const double frontBodyFontSize = 22;
  static const double frontLineGapMin = 10.0;
  static const double frontLineGapMax = 17.0;
  static const double frontLineGapCompactMin = 6.0;
  static const double frontLineGapCompactMax = 12.0;
  static const double frontLineGapRelaxedMin = 12.0;
  static const double frontLineGapRelaxedMax = 21.0;
  static const double frontLineGapSpread = 1.06;
  static const double frontBodyMinFontSize = 14;

  static const double frontSignatureSizeRatio = 0.10;
  static const double frontSignatureRightRatio = 0.06;
  static const double frontSignatureBottomRatio = 0.17;

  static const double backInstituteTop = 0.048;
  static const double backInstituteHeight = 0.09;
  static const double backInstituteSide = 0.10;

  static const double backTermsTop = 0.16;
  static const double backTermsSide = 0.12;
  static const double backTermsBottom = 0.40;
  static const double backTermsFontSize = 20;
  static const double backTermsMinFontSize = 13;

  static const double backContactTop = 0.52;
  static const double backContactBottom = 0.34;
  static const double backContactFontSize = 19;
  static const double backContactMinFontSize = 12;

  static const double backFooterBottom = 0.055;
  static const double backFooterHeight = 0.08;
  static const double backFooterSide = 0.10;
}

class StudentIdTemplatePortraitV8 extends StatelessWidget {
  const StudentIdTemplatePortraitV8({
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

  static (String first, String rest) _splitStudentName(String raw) {
    final parts = raw.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  List<String> _frontDetailLines() {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.rollNo);
    add(data.section);
    add(data.bloodGroup);
    add(data.mobileNumber);
    add(data.email);
    add(data.address);
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
    final photoSize = _w * _PortraitV8Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _PortraitV8Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop =
        photoTop + photoSize + _PortraitV8Layout.frontGapBelowPhoto;
    final nameParts = _splitStudentName(data.studentName);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV8,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV8Layout.frontInstituteTop,
            height: _h * _PortraitV8Layout.frontInstituteHeight,
            left: _w * _PortraitV8Layout.frontInstituteSide,
            right: _w * _PortraitV8Layout.frontInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _PortraitV8Layout.accentCyan,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  letterSpacing: 0.4,
                )),
              ),
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoSize,
          height: photoSize,
          child: _PortraitV8CirclePhoto(
            photoPath: data.photoPath,
            size: photoSize,
            whiteBorder: _PortraitV8Layout.frontPhotoWhiteBorder,
            cyanBorder: _PortraitV8Layout.frontPhotoCyanBorder,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _PortraitV8Layout.frontContentSide,
          right: _w * _PortraitV8Layout.frontContentSide,
          bottom: _h * _PortraitV8Layout.frontContentBottomRatio,
          child: _PortraitV8FrontContent(
            nameFirst: nameParts.$1,
            nameRest: nameParts.$2,
            fatherName: data.fatherName,
            className: data.className,
            detailLines: _frontDetailLines(),
            nameFirstStyle: _ts(const TextStyle(
              color: Color(0xFF334155),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
            )),
            nameRestStyle: _ts(const TextStyle(
              color: _PortraitV8Layout.accentCyan,
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w800,
              height: 1.05,
            )),
            nameMinFontSize: IdCardPortraitTypography.nameMinFontSize,
            bodyStyle: _ts(const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: _PortraitV8Layout.frontBodyFontSize,
              fontWeight: FontWeight.w400,
              height: 1.28,
            )),
            bodyMinFontSize: _PortraitV8Layout.frontBodyMinFontSize,
            compactSpacing: data.useCompactFrontSpacing,
            relaxedSpacing: data.useRelaxedFrontSpacing,
          ),
        ),
        if (data.hasSignature)
          Positioned(
            right: _w * 0.035,
            bottom: _h * 0.035,
            child: StudentPortraitSignatureCircle(
              size: _w * 0.08,
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
    final email = data.email.trim();
    final phone = data.mobileNumber.trim();
    final footer = data.address.trim();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.backBackgroundV8,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV8Layout.backInstituteTop,
            height: _h * _PortraitV8Layout.backInstituteHeight,
            left: _w * _PortraitV8Layout.backInstituteSide,
            right: _w * _PortraitV8Layout.backInstituteSide,
            child: Center(
              child: AutoSizeText(
                data.instituteName.trim().toUpperCase(),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _PortraitV8Layout.accentCyan,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.08,
                  letterSpacing: 0.3,
                )),
              ),
            ),
          ),
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV8Layout.backTermsTop,
            left: _w * _PortraitV8Layout.backTermsSide,
            right: _w * _PortraitV8Layout.backTermsSide,
            bottom: _h * _PortraitV8Layout.backTermsBottom,
            child: _PortraitV8CenteredParagraphs(
              lines: terms,
              textStyle: _ts(const TextStyle(
                color: Color(0xFFE0F2FE),
                fontSize: _PortraitV8Layout.backTermsFontSize,
                fontWeight: FontWeight.w400,
                height: 1.38,
              )),
              minFontSize: _PortraitV8Layout.backTermsMinFontSize,
              compactSpacing: data.useCompactFrontSpacing,
              relaxedSpacing: data.useRelaxedFrontSpacing,
            ),
          ),
        if (email.isNotEmpty || phone.isNotEmpty)
          Positioned(
            top: _h * _PortraitV8Layout.backContactTop,
            left: _w * _PortraitV8Layout.backTermsSide,
            right: _w * _PortraitV8Layout.backTermsSide,
            bottom: _h * _PortraitV8Layout.backContactBottom,
            child: _PortraitV8ContactBlock(
              email: email,
              phone: phone,
              textStyle: _ts(const TextStyle(
                color: Color(0xFFE0F2FE),
                fontSize: _PortraitV8Layout.backContactFontSize,
                fontWeight: FontWeight.w400,
                height: 1.25,
              )),
              minFontSize: _PortraitV8Layout.backContactMinFontSize,
            ),
          ),
        if (footer.isNotEmpty)
          Positioned(
            left: _w * _PortraitV8Layout.backFooterSide,
            right: _w * _PortraitV8Layout.backFooterSide,
            bottom: _h * _PortraitV8Layout.backFooterBottom,
            height: _h * _PortraitV8Layout.backFooterHeight,
            child: Center(
              child: AutoSizeText(
                footer.toUpperCase(),
                maxLines: 2,
                minFontSize: 11,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: _PortraitV8Layout.accentOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                  letterSpacing: 0.2,
                )),
              ),
            ),
          ),
      ],
    );
  }
}

class _PortraitV8CirclePhoto extends StatelessWidget {
  const _PortraitV8CirclePhoto({
    required this.photoPath,
    required this.size,
    required this.whiteBorder,
    required this.cyanBorder,
  });

  final String photoPath;
  final double size;
  final double whiteBorder;
  final double cyanBorder;

  @override
  Widget build(BuildContext context) {
    final inner = size - whiteBorder * 2;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: whiteBorder),
      ),
      alignment: Alignment.center,
      child: StudentPortraitPhoto(
        photoPath: photoPath,
        size: inner,
        borderColor: _PortraitV8Layout.accentCyan,
        borderWidth: cyanBorder,
        padding: 2,
        showShadow: false,
      ),
    );
  }
}

class _PortraitV8SplitName extends StatelessWidget {
  const _PortraitV8SplitName({
    required this.first,
    required this.rest,
    required this.firstStyle,
    required this.restStyle,
    required this.minFontSize,
  });

  final String first;
  final String rest;
  final TextStyle firstStyle;
  final TextStyle restStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final f = first.trim().toUpperCase();
    final r = rest.trim().toUpperCase();
    if (f.isEmpty && r.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (f.isNotEmpty)
                  AutoSizeText(
                    f,
                    maxLines: 1,
                    minFontSize: minFontSize,
                    style: firstStyle,
                  ),
                if (f.isNotEmpty && r.isNotEmpty) const SizedBox(width: 6),
                if (r.isNotEmpty)
                  AutoSizeText(
                    r,
                    maxLines: 1,
                    minFontSize: minFontSize,
                    style: restStyle,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PortraitV8FrontContent extends StatelessWidget {
  const _PortraitV8FrontContent({
    required this.nameFirst,
    required this.nameRest,
    required this.fatherName,
    required this.className,
    required this.detailLines,
    required this.nameFirstStyle,
    required this.nameRestStyle,
    required this.nameMinFontSize,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final String nameFirst;
  final String nameRest;
  final String fatherName;
  final String className;
  final List<String> detailLines;
  final TextStyle nameFirstStyle;
  final TextStyle nameRestStyle;
  final double nameMinFontSize;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: _PortraitV8FrontColumn(
              nameFirst: nameFirst,
              nameRest: nameRest,
              fatherName: fatherName,
              className: className,
              detailLines: detailLines,
              nameFirstStyle: nameFirstStyle,
              nameRestStyle: nameRestStyle,
              nameMinFontSize: nameMinFontSize,
              bodyStyle: bodyStyle,
              bodyMinFontSize: bodyMinFontSize,
              compactSpacing: compactSpacing,
              relaxedSpacing: relaxedSpacing,
              maxHeight: constraints.maxHeight,
            ),
          ),
        );
      },
    );
  }
}

class _PortraitV8FrontColumn extends StatelessWidget {
  const _PortraitV8FrontColumn({
    required this.nameFirst,
    required this.nameRest,
    required this.fatherName,
    required this.className,
    required this.detailLines,
    required this.nameFirstStyle,
    required this.nameRestStyle,
    required this.nameMinFontSize,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
    required this.maxHeight,
  });

  final String nameFirst;
  final String nameRest;
  final String fatherName;
  final String className;
  final List<String> detailLines;
  final TextStyle nameFirstStyle;
  final TextStyle nameRestStyle;
  final double nameMinFontSize;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    if (nameFirst.trim().isNotEmpty || nameRest.trim().isNotEmpty) {
      add(
        _PortraitV8SplitName(
          first: nameFirst,
          rest: nameRest,
          firstStyle: nameFirstStyle,
          restStyle: nameRestStyle,
          minFontSize: nameMinFontSize,
        ),
        (nameFirstStyle.fontSize ?? 40) * 1.1,
      );
    }

    final father = fatherName.trim();
    if (father.isNotEmpty) {
      add(
        AutoSizeText(
          father.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 22) * 1.2,
      );
    }

    final course = className.trim();
    if (course.isNotEmpty) {
      add(
        AutoSizeText(
          course.toUpperCase(),
          maxLines: 1,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        (bodyStyle.fontSize ?? 22) * 1.15,
      );
    }

    for (final line in detailLines) {
      add(
        AutoSizeText(
          line,
          maxLines: 2,
          minFontSize: bodyMinFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 22) * 1.26,
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    final gapCount = blocks.length - 1;
    if (gapCount <= 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: blocks,
      );
    }

    var gapMin = compactSpacing
        ? _PortraitV8Layout.frontLineGapCompactMin
        : _PortraitV8Layout.frontLineGapMin;
    var gapMax = compactSpacing
        ? _PortraitV8Layout.frontLineGapCompactMax
        : _PortraitV8Layout.frontLineGapMax;
    if (relaxedSpacing) {
      gapMin = _PortraitV8Layout.frontLineGapRelaxedMin;
      gapMax = _PortraitV8Layout.frontLineGapRelaxedMax;
    }

    final estTotal = estimates.fold(0.0, (a, b) => a + b);
    final free = (maxHeight - estTotal).clamp(0.0, double.infinity);
    var gap = ((free / gapCount) * _PortraitV8Layout.frontLineGapSpread)
        .clamp(gapMin, gapMax);

    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      if (i > 0) children.add(SizedBox(height: gap));
      children.add(blocks[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class _PortraitV8CenteredParagraphs extends StatelessWidget {
  const _PortraitV8CenteredParagraphs({
    required this.lines,
    required this.textStyle,
    required this.minFontSize,
    required this.compactSpacing,
    required this.relaxedSpacing,
  });

  final List<String> lines;
  final TextStyle textStyle;
  final double minFontSize;
  final bool compactSpacing;
  final bool relaxedSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gapMin = compactSpacing
            ? 8.0
            : relaxedSpacing
                ? 18.0
                : IdCardPortraitTypography.backGapMin;
        final gapMax = compactSpacing
            ? 14.0
            : relaxedSpacing
                ? 26.0
                : IdCardPortraitTypography.backGapMax;

        final est = lines.length * (textStyle.fontSize ?? 20) * 1.4;
        final free =
            (constraints.maxHeight - est).clamp(0.0, double.infinity);
        final gap = lines.length <= 1
            ? 0.0
            : (free / (lines.length - 1)).clamp(gapMin, gapMax);

        final children = <Widget>[];
        for (var i = 0; i < lines.length; i++) {
          if (i > 0) children.add(SizedBox(height: gap));
          children.add(
            AutoSizeText(
              lines[i],
              maxLines: 4,
              minFontSize: minFontSize,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}

class _PortraitV8ContactBlock extends StatelessWidget {
  const _PortraitV8ContactBlock({
    required this.email,
    required this.phone,
    required this.textStyle,
    required this.minFontSize,
  });

  final String email;
  final String phone;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (email.isNotEmpty) {
      rows.add(_PortraitV8ContactRow(
        icon: Icons.email_outlined,
        label: email,
        textStyle: textStyle,
        minFontSize: minFontSize,
      ));
    }
    if (phone.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 10));
      rows.add(_PortraitV8ContactRow(
        icon: Icons.phone_outlined,
        label: phone,
        textStyle: textStyle,
        minFontSize: minFontSize,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }
}

class _PortraitV8ContactRow extends StatelessWidget {
  const _PortraitV8ContactRow({
    required this.icon,
    required this.label,
    required this.textStyle,
    required this.minFontSize,
  });

  final IconData icon;
  final String label;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: _PortraitV8Layout.accentCyan),
        const SizedBox(width: 8),
        Flexible(
          child: AutoSizeText(
            label,
            maxLines: 2,
            minFontSize: minFontSize,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
