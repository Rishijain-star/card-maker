import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 14 — mango-shaped single-sided student card (front only).
abstract final class _PortraitV14Layout {
  static const Color instituteRed = Color(0xFFB71C1C);
  static const Color textBrown = Color(0xFF3E2723);
  static const Color nameBarBlue = Color(0xFF4FC3F7);
  static const Color sessionRed = Color(0xFFD32F2F);

  static const double headerTop = 0.088;
  static const double headerHeight = 0.110;
  static const double headerCenterY = 0.145;

  static const double photoLeft = 0.085;
  static const double photoTop = 0.270;
  static const double photoWidth = 0.225;
  static const double photoHeight = 0.185;
  static const double photoRadius = 6.0;
  static const double photoBorderWidth = 3.0;

  static const double nameBarLeft = 0.33;
  static const double nameBarTop = 0.275;
  static const double nameBarRight = 0.09;
  static const double nameBarHeight = 0.058;

  static const double detailsTop = 0.355;
  static const double detailsLeft = 0.33;
  static const double detailsRight = 0.09;
  static const double detailsBottom = 0.23;
  static const double detailFontSize = 24;
  static const double detailMinFontSize = 14;

  static const double sessionBottom = 0.18;
  static const double sessionLeft = 0.10;
  static const double sessionMaxWidth = 0.44;

  static const double signatureRight = 0.09;
  static const double signatureBottom = 0.16;
  static const double signatureWidth = 0.32;
  static const double signatureHeight = 0.095;
}

/// Horizontal inset inside the mango white border (varies by height).
abstract final class _PortraitV14MangoInsets {
  static const List<(double y, double left, double right)> _keys = [
    (0.10, 0.20, 0.16),
    (0.20, 0.10, 0.08),
    (0.35, 0.05, 0.03),
    (0.50, 0.05, 0.03),
    (0.70, 0.17, 0.07),
    (0.85, 0.32, 0.10),
    (0.92, 0.40, 0.12),
  ];

  static double _lerp(double y, bool left) {
    final keys = _keys;
    if (y <= keys.first.$1) {
      return left ? keys.first.$2 : keys.first.$3;
    }
    if (y >= keys.last.$1) {
      return left ? keys.last.$2 : keys.last.$3;
    }
    for (var i = 0; i < keys.length - 1; i++) {
      final a = keys[i];
      final b = keys[i + 1];
      if (y >= a.$1 && y <= b.$1) {
        final t = (y - a.$1) / (b.$1 - a.$1);
        final va = left ? a.$2 : a.$3;
        final vb = left ? b.$2 : b.$3;
        return va + (vb - va) * t;
      }
    }
    return left ? 0.08 : 0.06;
  }

  static double leftAt(double centerYRatio) => _lerp(centerYRatio, true);

  static double rightAt(double centerYRatio) => _lerp(centerYRatio, false);
}

class StudentIdTemplatePortraitV14 extends StatelessWidget {
  const StudentIdTemplatePortraitV14({
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

  static int _instituteMaxLines(String name) =>
      name.trim().length > 36 ? 2 : 1;

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
    final headerLeft =
        _w * _PortraitV14MangoInsets.leftAt(_PortraitV14Layout.headerCenterY);
    final headerRight =
        _w * _PortraitV14MangoInsets.rightAt(_PortraitV14Layout.headerCenterY);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV14,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV14Layout.headerTop,
            height: _h * _PortraitV14Layout.headerHeight,
            left: headerLeft,
            right: headerRight,
            child: AutoSizeText(
              data.instituteName.trim().toUpperCase(),
              maxLines: _instituteMaxLines(data.instituteName),
              minFontSize: IdCardPortraitTypography.headerMinFontSize,
              textAlign: TextAlign.center,
              style: _ts(const TextStyle(
                color: _PortraitV14Layout.instituteRed,
                fontSize: IdCardPortraitTypography.headerFontSize,
                fontWeight: FontWeight.w900,
                height: 1.02,
                letterSpacing: 0.35,
              )),
            ),
          ),
        Positioned(
          top: _h * _PortraitV14Layout.photoTop,
          left: _w * _PortraitV14Layout.photoLeft,
          width: _w * _PortraitV14Layout.photoWidth,
          height: _h * _PortraitV14Layout.photoHeight,
          child: _PortraitV14RectPhoto(
            photoPath: data.photoPath,
            borderWidth: _PortraitV14Layout.photoBorderWidth,
            radius: _PortraitV14Layout.photoRadius,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV14Layout.nameBarTop,
            left: _w * _PortraitV14Layout.nameBarLeft,
            right: _w * _PortraitV14Layout.nameBarRight,
            height: _h * _PortraitV14Layout.nameBarHeight,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _PortraitV14Layout.nameBarBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AutoSizeText(
                data.studentName.trim().toUpperCase(),
                maxLines: 1,
                minFontSize: 11,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: 0.3,
                )),
              ),
            ),
          ),
        if (detailLines.isNotEmpty)
          Positioned(
            top: _h * _PortraitV14Layout.detailsTop,
            left: _w * _PortraitV14Layout.detailsLeft,
            right: _w * _PortraitV14Layout.detailsRight,
            bottom: _h * _PortraitV14Layout.detailsBottom,
            child: _PortraitV14DetailColumn(
              lines: detailLines,
              textStyle: _ts(const TextStyle(
                color: _PortraitV14Layout.textBrown,
                fontSize: _PortraitV14Layout.detailFontSize,
                fontWeight: FontWeight.w700,
                height: 1.22,
              )),
              minFontSize: _PortraitV14Layout.detailMinFontSize,
              compact: data.useCompactFrontSpacing,
              relaxed: data.useRelaxedFrontSpacing,
            ),
          ),
        if (session.isNotEmpty)
          Positioned(
            left: _w * _PortraitV14Layout.sessionLeft,
            bottom: _h * _PortraitV14Layout.sessionBottom,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _w * _PortraitV14Layout.sessionMaxWidth,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _PortraitV14Layout.sessionRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AutoSizeText(
                  session,
                  maxLines: 1,
                  minFontSize: 9,
                  textAlign: TextAlign.center,
                  style: _ts(const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  )),
                ),
              ),
            ),
          ),
        if (data.hasSignature)
          Positioned(
            right: _w * _PortraitV14Layout.signatureRight,
            bottom: _h * _PortraitV14Layout.signatureBottom,
            width: _w * _PortraitV14Layout.signatureWidth,
            height: _h * _PortraitV14Layout.signatureHeight,
            child: _PortraitV14Signature(
              path: data.signaturePath,
              bytes: data.signatureBytes,
            ),
          ),
      ],
    );
  }
}

class _PortraitV14RectPhoto extends StatelessWidget {
  const _PortraitV14RectPhoto({
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
        border: Border.all(color: Colors.white, width: borderWidth),
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

class _PortraitV14DetailColumn extends StatelessWidget {
  const _PortraitV14DetailColumn({
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
                fontWeight: FontWeight.w800,
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
      style: textStyle.copyWith(fontWeight: FontWeight.w800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double currentGapMax;
        if (lines.length <= 6) {
          currentGapMax = compact ? 12.0 : (relaxed ? 22.0 : 18.0);
        } else if (lines.length <= 8) {
          currentGapMax = compact ? 8.0 : (relaxed ? 15.0 : 12.0);
        } else {
          currentGapMax = compact ? 5.0 : (relaxed ? 10.0 : 8.0);
        }

        final double currentGapMin = compact ? 4.0 : (relaxed ? 8.0 : 6.0);

        final est = lines.length * (textStyle.fontSize ?? 24) * 1.2;
        final free =
            (constraints.maxHeight - est).clamp(0.0, double.infinity);
        final gap = lines.length <= 1
            ? 0.0
            : (free / (lines.length - 1)).clamp(currentGapMin, currentGapMax);

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

class _PortraitV14Signature extends StatelessWidget {
  const _PortraitV14Signature({
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Center(child: image)),
      ],
    );
  }
}


