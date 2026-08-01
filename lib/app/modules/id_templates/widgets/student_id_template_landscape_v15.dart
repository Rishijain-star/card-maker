import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_dimensions.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 15 — deer / grass landscape card; front only; main form fields only.
abstract final class _LandscapeV15Layout {
  static const Color instituteRed = Color(0xFFC62828);
  static const Color nameRed = Color(0xFFB71C1C);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color textDark = Color(0xFF1F2937);
  static const Color sessionBadgeRed = Color(0xFFD32F2F);

  static const double headerTop = 0.055;
  static const double headerLeft = 0.22;
  static const double headerRight = 0.28;
  static const double headerHeight = 0.21;

  static const double photoTop = 0.12;
  static const double photoRight = 0.065;
  static const double photoWidth = 0.205;
  static const double photoHeight = 0.58;
  static const double photoRadius = 6.0;
  static const double photoBorderWidth = 2.5;

  static const double nameTop = 0.710;
  static const double nameRight = 0.05;
  static const double nameWidth = 0.245;

  static const double detailsTop = 0.28;
  static const double detailsLeft = 0.24;
  static const double detailsRight = 0.30;
  static const double detailsBottom = 0.20;
  static const double detailFontSize = 16;
  static const double detailMinFontSize = 9;
  static const double detailGapMin = 3.0;
  static const double detailGapMax = 7.0;

  static const double sessionBadgeBottom = 0.195;
  static const double sessionBadgeLeft = 0.24;

  static const double signatureLeft = 0.05;
  static const double signatureBottom = 0.06;
  static const double signatureWidth = 0.22;
  static const double signatureHeight = 0.11;
}

class StudentIdTemplateLandscapeV15 extends StatelessWidget {
  const StudentIdTemplateLandscapeV15({
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
      name.trim().length > 40 ? 2 : 1;

  String? _classLine() {
    final cls = data.className.trim();
    final sec = data.section.trim();
    if (cls.isEmpty && sec.isEmpty) return null;
    if (cls.isNotEmpty && sec.isNotEmpty) return '$cls · $sec';
    return cls.isNotEmpty ? cls : sec;
  }

  List<String> _detailLines() {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    add(data.fatherName);
    final cls = _classLine();
    if (cls != null) add(cls);
    add(data.rollNo);
    add(data.bloodGroup);
    add(data.mobileNumber);
    add(data.email);
    add(data.address);
    for (final term in data.backDetailLines) {
      add(term);
    }
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV15,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _LandscapeV15Layout.headerTop,
          left: _w * _LandscapeV15Layout.headerLeft,
          right: _w * _LandscapeV15Layout.headerRight,
          height: _h * _LandscapeV15Layout.headerHeight,
          child: _LandscapeV15Header(
            instituteName: data.instituteName.trim(),
            address: data.address.trim(),
            classLine: classLine,
            mobile: data.mobileNumber.trim(),
            instituteStyle: _ts(const TextStyle(
              color: _LandscapeV15Layout.instituteRed,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.02,
              letterSpacing: 0.3,
            )),
            bodyStyle: _ts(const TextStyle(
              color: _LandscapeV15Layout.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.2,
            )),
            greenStyle: _ts(const TextStyle(
              color: _LandscapeV15Layout.accentGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.15,
            )),
            mobileStyle: _ts(const TextStyle(
              color: _LandscapeV15Layout.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.15,
            )),
            instituteMaxLines: _instituteMaxLines(data.instituteName),
            minFontSize: 8,
          ),
        ),
        Positioned(
          top: _h * _LandscapeV15Layout.photoTop,
          right: _w * _LandscapeV15Layout.photoRight,
          width: _w * _LandscapeV15Layout.photoWidth,
          height: _h * _LandscapeV15Layout.photoHeight,
          child: _LandscapeV15RectPhoto(
            photoPath: data.photoPath,
            borderWidth: _LandscapeV15Layout.photoBorderWidth,
            radius: _LandscapeV15Layout.photoRadius,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _LandscapeV15Layout.nameTop,
            right: _w * _LandscapeV15Layout.nameRight,
            width: _w * _LandscapeV15Layout.nameWidth,
            child: AutoSizeText(
              data.studentName.trim().toUpperCase(),
              maxLines: 2,
              minFontSize: 12,
              textAlign: TextAlign.center,
              style: _ts(const TextStyle(
                color: _LandscapeV15Layout.nameRed,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: 0.35,
              )),
            ),
          ),
        if (detailLines.isNotEmpty)
          Positioned(
            top: _h * _LandscapeV15Layout.detailsTop,
            left: _w * _LandscapeV15Layout.detailsLeft,
            right: _w * _LandscapeV15Layout.detailsRight,
            bottom: _h * _LandscapeV15Layout.detailsBottom,
            child: _LandscapeV15DetailColumn(
              lines: detailLines,
              textStyle: _ts(const TextStyle(
                color: _LandscapeV15Layout.textDark,
                fontSize: _LandscapeV15Layout.detailFontSize,
                fontWeight: FontWeight.w700,
                height: 1.22,
              )),
              minFontSize: _LandscapeV15Layout.detailMinFontSize,
              compact: data.useCompactFrontSpacing,
              relaxed: data.useRelaxedFrontSpacing,
            ),
          ),
        if (session.isNotEmpty)
          Positioned(
            left: _w * _LandscapeV15Layout.sessionBadgeLeft,
            bottom: _h * _LandscapeV15Layout.sessionBadgeBottom,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _LandscapeV15Layout.sessionBadgeRed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AutoSizeText(
                session,
                maxLines: 1,
                minFontSize: 8,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                )),
              ),
            ),
          ),
        if (data.hasSignature)
          Positioned(
            left: _w * _LandscapeV15Layout.signatureLeft,
            bottom: _h * _LandscapeV15Layout.signatureBottom,
            width: _w * _LandscapeV15Layout.signatureWidth,
            height: _h * _LandscapeV15Layout.signatureHeight,
            child: _LandscapeV15Signature(
              path: data.signaturePath,
              bytes: data.signatureBytes,
            ),
          ),
      ],
    );
  }
}

class _LandscapeV15Header extends StatelessWidget {
  const _LandscapeV15Header({
    required this.instituteName,
    required this.address,
    required this.classLine,
    required this.mobile,
    required this.instituteStyle,
    required this.bodyStyle,
    required this.greenStyle,
    required this.mobileStyle,
    required this.instituteMaxLines,
    required this.minFontSize,
  });

  final String instituteName;
  final String address;
  final String? classLine;
  final String mobile;
  final TextStyle instituteStyle;
  final TextStyle bodyStyle;
  final TextStyle greenStyle;
  final TextStyle mobileStyle;
  final int instituteMaxLines;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    if (instituteName.isNotEmpty) {
      rows.add(
        AutoSizeText(
          instituteName.toUpperCase(),
          maxLines: instituteMaxLines,
          minFontSize: minFontSize + 2,
          textAlign: TextAlign.center,
          style: instituteStyle,
        ),
      );
    }
    if (address.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 2));
      rows.add(
        AutoSizeText(
          address,
          maxLines: 2,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
      );
    }
    if (classLine != null) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 2));
      rows.add(
        AutoSizeText(
          classLine!,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: greenStyle,
        ),
      );
    }
    if (mobile.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 2));
      rows.add(
        AutoSizeText(
          mobile,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: mobileStyle,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }
}

class _LandscapeV15RectPhoto extends StatelessWidget {
  const _LandscapeV15RectPhoto({
    required this.photoPath,
    required this.borderWidth,
    required this.radius,
  });

  final String photoPath;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final path = photoPath.trim();
    if (path.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFE0E0E0),
        child: Center(
          child: Icon(Icons.person, color: Color(0xFF9E9E9E), size: 48),
        ),
      );
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return const ColoredBox(
      color: Color(0xFFE0E0E0),
      child: Center(
        child: Icon(Icons.person, color: Color(0xFF9E9E9E), size: 48),
      ),
    );
  }
}

class _LandscapeV15DetailColumn extends StatelessWidget {
  const _LandscapeV15DetailColumn({
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
        var gapMin = compact ? 2.0 : _LandscapeV15Layout.detailGapMin;
        var gapMax = compact ? 5.0 : _LandscapeV15Layout.detailGapMax;
        if (relaxed) {
          gapMin = 5;
          gapMax = 9;
        }

        final est = lines.length * (textStyle.fontSize ?? 17) * 1.2;
        final free =
            (constraints.maxHeight - est).clamp(0.0, double.infinity);
        final gap = lines.length <= 1
            ? 0.0
            : (free / (lines.length - 1)).clamp(gapMin, gapMax);

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  if (i > 0) SizedBox(height: gap),
                  _buildRow(lines[i]),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LandscapeV15Signature extends StatelessWidget {
  const _LandscapeV15Signature({
    required this.path,
    this.bytes,
  });

  final String path;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    Widget? image;
    if (bytes != null && bytes!.isNotEmpty) {
      image = Image.memory(bytes!, fit: BoxFit.contain);
    } else if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        image = Image.file(file, fit: BoxFit.contain);
      }
    }
    if (image == null) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(height: 52, child: image),
    );
  }
}
