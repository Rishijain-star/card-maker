import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 16 — elephant landscape card; front only; main form fields only.
abstract final class _LandscapeV16Layout {
  static const Color schoolBlue = Color(0xFF0F2B5B);
  static const Color addressBlue = Color(0xFF1E3A8A);
  static const Color sessionRed = Color(0xFFD32F2F);
  static const Color bannerGreen = Color(0xFF1B6B3A);
  static const Color textDark = Color(0xFF0F172A);
  static const Color photoBorderRed = Color(0xFFE53935);

  static const double headerTop = 0.040;
  static const double headerLeft = 0.33;
  static const double headerRight = 0.08;
  static const double headerHeight = 0.20;

  static const double nameBannerTop = 0.250;
  static const double nameBannerLeft = 0.30;
  static const double nameBannerRight = 0.38;
  static const double nameBannerHeight = 0.080;

  static const double detailsTop = 0.355;
  static const double detailsLeft = 0.30;
  static const double detailsRight = 0.38;
  static const double detailsBottom = 0.12;
  static const double detailFontSize = 17;
  static const double detailMinFontSize = 10;

  static const double photoTop = 0.27;
  static const double photoRight = 0.055;
  static const double photoSize = 0.54;
  static const double photoBorderWidth = 3.0;

  static const double classBannerBottom = 0.095;
  static const double classBannerRight = 0.055;
  static const double classBannerWidth = 0.31;
  static const double classBannerHeight = 0.075;
}

class StudentIdTemplateLandscapeV16 extends StatelessWidget {
  const StudentIdTemplateLandscapeV16({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardDimensions.width;
  static const double _h = IdCardDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);

  static int _instituteMaxLines(String name) =>
      name.trim().length > 34 ? 2 : 1;

  String? _classLine() {
    final cls = data.className.trim();
    final sec = data.section.trim();
    if (cls.isEmpty && sec.isEmpty) return null;
    if (cls.isNotEmpty && sec.isNotEmpty) return '$cls ($sec)';
    return cls.isNotEmpty ? cls : sec;
  }

  List<String> _detailLines() {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.fatherName);
    add(data.rollNo);
    add(data.bloodGroup);
    add(data.mobileNumber);
    add(data.address);
    add(data.email);
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    if (side == StudentIdCardSide.back) {
      return const SizedBox(width: _w, height: _h);
    }
    return SizedBox(
      width: _w,
      height: _h,
      child: _buildFront(),
    );
  }

  Widget _buildFront() {
    final detailLines = _detailLines();
    final session = data.validityText.trim();
    final classLine = _classLine();
    final photoDiameter = _h * _LandscapeV16Layout.photoSize;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV16,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _LandscapeV16Layout.headerTop,
          left: _w * _LandscapeV16Layout.headerLeft,
          right: _w * _LandscapeV16Layout.headerRight,
          height: _h * _LandscapeV16Layout.headerHeight,
          child: _LandscapeV16Header(
            instituteName: data.instituteName.trim(),
            address: data.address.trim(),
            session: session,
            schoolStyle: _ts(const TextStyle(
              color: _LandscapeV16Layout.schoolBlue,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              height: 1.02,
            )),
            addressStyle: _ts(const TextStyle(
              color: _LandscapeV16Layout.addressBlue,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: 0.5,
            )),
            sessionStyle: _ts(const TextStyle(
              color: _LandscapeV16Layout.sessionRed,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.1,
            )),
            instituteMaxLines: _instituteMaxLines(data.instituteName),
            minFontSize: 12,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV16Layout.nameBannerTop,
            left: _w * _LandscapeV16Layout.nameBannerLeft,
            right: _w * _LandscapeV16Layout.nameBannerRight,
            height: _h * _LandscapeV16Layout.nameBannerHeight,
            child: _LandscapeV16GreenBanner(
              text: data.studentName.trim().toUpperCase(),
              compact: data.useCompactFrontSpacing,
              textStyle: _ts(const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: 0.5,
              )),
              minFontSize: 12,
            ),
          ),
        if (detailLines.isNotEmpty)
          Positioned(
            top: _h * _LandscapeV16Layout.detailsTop,
            left: _w * _LandscapeV16Layout.detailsLeft,
            right: _w * _LandscapeV16Layout.detailsRight,
            bottom: _h * _LandscapeV16Layout.detailsBottom,
            child: _LandscapeV16DetailColumn(
              lines: detailLines,
              textStyle: _ts(const TextStyle(
                color: _LandscapeV16Layout.textDark,
                fontSize: _LandscapeV16Layout.detailFontSize,
                fontWeight: FontWeight.w700,
                height: 1.28,
              )),
              minFontSize: _LandscapeV16Layout.detailMinFontSize,
              compact: data.useCompactFrontSpacing,
              relaxed: data.useRelaxedFrontSpacing,
            ),
          ),
        Positioned(
          top: _h * _LandscapeV16Layout.photoTop,
          right: _w * _LandscapeV16Layout.photoRight,
          child: StudentPortraitPhoto(
            photoPath: data.photoPath,
            size: photoDiameter,
            borderColor: _LandscapeV16Layout.photoBorderRed,
            borderWidth: _LandscapeV16Layout.photoBorderWidth,
            padding: 2,
            showShadow: false,
          ),
        ),
        if (classLine != null)
          Positioned(
            right: _w * _LandscapeV16Layout.classBannerRight,
            bottom: _h * _LandscapeV16Layout.classBannerBottom,
            width: _w * _LandscapeV16Layout.classBannerWidth,
            height: _h * _LandscapeV16Layout.classBannerHeight,
            child: _LandscapeV16GreenBanner(
              text: classLine.toUpperCase(),
              textStyle: _ts(const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minFontSize: 10,
            ),
          ),
      ],
    );
  }
}

class _LandscapeV16Header extends StatelessWidget {
  const _LandscapeV16Header({
    required this.instituteName,
    required this.address,
    required this.session,
    required this.schoolStyle,
    required this.addressStyle,
    required this.sessionStyle,
    required this.instituteMaxLines,
    required this.minFontSize,
  });

  final String instituteName;
  final String address;
  final String session;
  final TextStyle schoolStyle;
  final TextStyle addressStyle;
  final TextStyle sessionStyle;
  final int instituteMaxLines;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    if (instituteName.isNotEmpty) {
      rows.add(
        AutoSizeText(
          instituteName,
          maxLines: instituteMaxLines,
          minFontSize: minFontSize + 4,
          textAlign: TextAlign.center,
          style: schoolStyle,
        ),
      );
    }
    if (address.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 3));
      rows.add(
        AutoSizeText(
          address.toUpperCase(),
          maxLines: 2,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: addressStyle,
        ),
      );
    }
    if (session.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 4));
      rows.add(
        AutoSizeText(
          session.toUpperCase(),
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: sessionStyle,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }
}

class _LandscapeV16GreenBanner extends StatelessWidget {
  const _LandscapeV16GreenBanner({
    required this.text,
    required this.textStyle,
    required this.minFontSize,
    this.compact = false,
  });

  final String text;
  final TextStyle textStyle;
  final double minFontSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 16,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: _LandscapeV16Layout.bannerGreen,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AutoSizeText(
          text,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}

class _LandscapeV16DetailColumn extends StatelessWidget {
  const _LandscapeV16DetailColumn({
    required this.lines,
    required this.textStyle,
    required this.minFontSize,
    required this.compact,
    required this.relaxed,
  });

  final List<String> lines;
  final TextStyle textStyle;
  final double minFontSize;
  final bool compact;
  final bool relaxed;

  Widget _buildRow(String line) {
    if (line.contains(':')) {
      final parts = line.split(':');
      final label = parts[0].trim();
      final value = parts.sublist(1).join(':').trim();
      return AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: textStyle.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            TextSpan(
              text: value,
              style: textStyle.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        maxLines: 2,
        minFontSize: minFontSize,
        textAlign: TextAlign.left,
      );
    }
    return AutoSizeText(
      line,
      maxLines: 2,
      minFontSize: minFontSize,
      textAlign: TextAlign.left,
      style: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var gap = compact ? 1.5 : (relaxed ? 4.0 : 2.5);

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < lines.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              _buildRow(lines[i]),
            ],
          ],
        );
      },
    );
  }
}
