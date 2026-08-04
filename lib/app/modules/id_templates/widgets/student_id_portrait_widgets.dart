import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../design_system/id_card_typography.dart';

/// Shared portrait card text/photo widgets (template 1 & 2).
class StudentPortraitEvenContent extends StatelessWidget {
  const StudentPortraitEvenContent({
    required this.lines,
    required this.fontFamily,
    required this.bodyStyle,
    required this.bodyMinFontSize,
    this.photoPath = '',
    this.photoSize = 0,
    this.studentName = '',
    this.nameStyle,
    this.nameMinFontSize = 20,
    this.nameAlign = TextAlign.center,
    this.bodyAlign = TextAlign.center,
    this.maxLinesPerItem = 2,
    this.compactSpacing = false,
    this.footerLine,
    this.footerStyle,
    this.footerMinFontSize = 13,
    this.referenceNameFontSize = 40,
    this.referenceBodyFontSize = 27,
    this.gapMin = 15.0,
    this.gapMax = 25.0,
    this.gapSpreadFactor = 0.96,
    this.relaxedSpacing = false,
    this.gapRelaxedMin = 22.0,
    this.gapRelaxedMax = 34.0,
    this.gapRelaxedSpreadFactor = 1.05,
  });

  final bool compactSpacing;
  final bool relaxedSpacing;
  final double gapRelaxedMin;
  final double gapRelaxedMax;
  final double gapRelaxedSpreadFactor;
  final String? footerLine;
  final TextStyle? footerStyle;
  final double footerMinFontSize;
  final String photoPath;
  final double photoSize;
  final String studentName;
  final List<String> lines;
  final String fontFamily;
  final TextStyle bodyStyle;
  final double bodyMinFontSize;
  final TextStyle? nameStyle;
  final double nameMinFontSize;
  final TextAlign nameAlign;
  final TextAlign bodyAlign;
  final int maxLinesPerItem;
  final double referenceNameFontSize;
  final double referenceBodyFontSize;
  final double gapMin;
  final double gapMax;
  final double gapSpreadFactor;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];

    if (photoSize > 0) {
      blocks.add(StudentPortraitPhoto(photoPath: photoPath, size: photoSize));
    }

    final name = studentName.trim();
    if (name.isNotEmpty && nameStyle != null) {
      blocks.add(
        AutoSizeText(
          name.toUpperCase(),
          maxLines: 2,
          minFontSize: nameMinFontSize,
          textAlign: nameAlign,
          style: nameStyle,
        ),
      );
    }

    for (final rawLine in lines) {
      final subLines = rawLine.split('\n');
      for (final line in subLines) {
        final v = line.trim();
        if (v.isEmpty) continue;
        blocks.add(
          AutoSizeText(
            v,
            maxLines: maxLinesPerItem,
            minFontSize: bodyMinFontSize,
            textAlign: bodyAlign,
            style: bodyStyle,
          ),
        );
      }
    }

    final footer = footerLine?.trim() ?? '';
    if (footer.isNotEmpty && footerStyle != null) {
      blocks.add(
        AutoSizeText(
          footer,
          maxLines: 1,
          minFontSize: footerMinFontSize,
          textAlign: TextAlign.left,
          style: footerStyle,
        ),
      );
    }

    if (blocks.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gapCount = blocks.length - 1;
        if (gapCount <= 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: blocks,
          );
        }

        final minGap = compactSpacing
            ? 6.0
            : relaxedSpacing
                ? gapRelaxedMin
                : gapMin;
        final maxGap = compactSpacing
            ? 14.0
            : relaxedSpacing
                ? gapRelaxedMax
                : gapMax;
        final spreadFactor = compactSpacing
            ? 0.82
            : relaxedSpacing
                ? gapRelaxedSpreadFactor
                : gapSpreadFactor;
        final footerCount =
            (footerLine?.trim().isNotEmpty ?? false) && footerStyle != null ? 1 : 0;
        final estContent = _estimateHeight(
          photoSize: photoSize,
          hasName: name.isNotEmpty,
          lineCount: lines.length + footerCount,
          nameSize: nameStyle?.fontSize ?? referenceNameFontSize,
          bodySize: bodyStyle.fontSize ?? referenceBodyFontSize,
        );
        final free = (constraints.maxHeight - estContent).clamp(0.0, double.infinity);
        var gap = (free / gapCount) * spreadFactor;
        gap = gap.clamp(minGap, maxGap);

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
      },
    );
  }

  static double _estimateHeight({
    required double photoSize,
    required bool hasName,
    required int lineCount,
    required double nameSize,
    required double bodySize,
  }) {
    var h = 0.0;
    if (photoSize > 0) h += photoSize;
    if (hasName) h += nameSize * 1.15;
    h += lineCount * bodySize * 1.3;
    return h;
  }
}

class StudentPortraitPhoto extends StatelessWidget {
  const StudentPortraitPhoto({
    required this.photoPath,
    required this.size,
    this.borderColor = const Color(0xFF22C55E),
    this.borderWidth = 3.5,
    this.padding = 2.0,
    this.showShadow = true,
  });

  final String photoPath;
  final double size;
  final Color borderColor;
  final double borderWidth;
  final double padding;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(padding),
      child: ClipOval(child: _buildImage(size)),
    );
  }

  Widget _buildImage(double diameter) {
    if (photoPath.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE2E8F0),
        child: Icon(Icons.person, size: diameter * 0.45, color: Color(0xFF94A3B8)),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE2E8F0),
      child: Icon(Icons.person, size: diameter * 0.45, color: Color(0xFF94A3B8)),
    );
  }
}

class StudentPortraitSignatureCircle extends StatelessWidget {
  const StudentPortraitSignatureCircle({
    super.key,
    required this.size,
    required this.path,
    this.bytes,
    this.hasBorder = false,
    this.borderColor = const Color(0xFF0F172A),
    this.borderWidth = 1.0,
    this.aspectRatio = 2.0,
  });

  final double size;
  final String path;
  final Uint8List? bytes;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final height = size;
    final width = size * aspectRatio;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.elliptical(width / 2, height / 2),
        ),
        border: hasBorder
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(hasBorder ? borderWidth + 1 : 2),
      child: ClipOval(child: _buildImage(width, height)),
    );
  }

  Widget _buildImage(double w, double h) {
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(bytes!, fit: BoxFit.fill, width: w, height: h);
    }
    if (path.trim().isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.fill, width: w, height: h);
      }
    }
    return const SizedBox.shrink();
  }
}

/// Template 4 accent — matches PNG hex stroke / bullet dots (~#47BAE3).
abstract final class StudentPortraitTemplate4Colors {
  static const Color accentCyan = Color(0xFF47BAE3);
}

Path studentPortraitPointyHexagonPath(Size size, {double inset = 0}) {
  final w = size.width - inset * 2;
  final h = size.height - inset * 2;
  final ox = inset;
  final oy = inset;
  return Path()
    ..moveTo(ox + w / 2, oy)
    ..lineTo(ox + w, oy + h * 0.25)
    ..lineTo(ox + w, oy + h * 0.75)
    ..lineTo(ox + w / 2, oy + h)
    ..lineTo(ox, oy + h * 0.75)
    ..lineTo(ox, oy + h * 0.25)
    ..close();
}

class _PointyHexagonClipper extends CustomClipper<Path> {
  const _PointyHexagonClipper({this.inset = 0});

  final double inset;

  @override
  Path getClip(Size size) => studentPortraitPointyHexagonPath(size, inset: inset);

  @override
  bool shouldReclip(covariant _PointyHexagonClipper oldClipper) =>
      oldClipper.inset != inset;
}

class _HexagonBorderPainter extends CustomPainter {
  const _HexagonBorderPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      studentPortraitPointyHexagonPath(size, inset: strokeWidth / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HexagonBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// Hexagonal photo frame with thick cyan stroke (template 4).
class StudentPortraitHexagonPhoto extends StatelessWidget {
  const StudentPortraitHexagonPhoto({
    required this.photoPath,
    required this.width,
    this.borderColor = StudentPortraitTemplate4Colors.accentCyan,
    this.borderWidth = 7.0,
    this.heightFactor = 1.12,
  });

  final String photoPath;
  final double width;
  final Color borderColor;
  final double borderWidth;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final height = width * heightFactor;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: _PointyHexagonClipper(inset: borderWidth),
            child: _HexagonPhotoContent(photoPath: photoPath),
          ),
          CustomPaint(
            painter: _HexagonBorderPainter(
              color: borderColor,
              strokeWidth: borderWidth,
            ),
          ),
        ],
      ),
    );
  }
}

class _HexagonPhotoContent extends StatelessWidget {
  const _HexagonPhotoContent({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    if (photoPath.trim().isEmpty) {
      return const ColoredBox(
        color: Color(0xFFE2E8F0),
        child: Center(
          child: Icon(Icons.person, size: 72, color: Color(0xFF94A3B8)),
        ),
      );
    }
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return const ColoredBox(
      color: Color(0xFFE2E8F0),
      child: Center(
        child: Icon(Icons.person, size: 72, color: Color(0xFF94A3B8)),
      ),
    );
  }
}

TextStyle studentPortraitTextStyle(TextStyle base, String fontFamily) =>
    IdCardTypography.apply(base, fontFamily);
