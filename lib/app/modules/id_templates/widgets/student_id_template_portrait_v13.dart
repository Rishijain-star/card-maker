import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Template 13 — colorful single-sided student card (front only).
abstract final class _PortraitV13Layout {
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color nameGreen = Color(0xFF2D9B47);
  static const Color pillBorder = Color(0xFF7EC8E3);
  static const Color photoBorder = Color(0xFFE85D4C);
  static const Color dottedLine = Color(0xFFD1D5DB);
  static const Color iconTint = Color(0xFF374151);

  static const List<Color> titleGradient = [
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF2563EB),
  ];

  static const double headerInstituteTop = 0.088;
  static const double headerInstituteHeight = 0.075;
  static const double headerInstituteSide = 0.10;

  static const double headerContactTop = 0.168;
  static const double headerContactHeight = 0.052;
  static const double headerContactSide = 0.12;

  static const double photoWidthRatio = 0.40;
  static const double photoHeightRatio = 0.22;
  static const double photoTopRatio = 0.195;
  static const double photoRadius = 10.0;
  static const double photoBorderWidth = 4.0;

  static const double sessionLeftRatio = 0.06;
  static const double sessionWidthRatio = 0.20;

  static const double namePillTopRatio = 0.415;
  static const double namePillSide = 0.10;

  static const double detailsTopRatio = 0.485;
  static const double detailsSide = 0.11;
  static const double detailsBottomRatio = 0.13;

  static const double detailFontSize = 17;
  static const double detailMinFontSize = 11;
  static const double detailRowGapMin = 6.0;
  static const double detailRowGapMax = 11.0;
}

class StudentIdTemplatePortraitV13 extends StatelessWidget {
  const StudentIdTemplatePortraitV13({
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
    return 2;
  }

  String? _classLine() {
    final cls = data.className.trim();
    final sec = data.section.trim();
    if (cls.isEmpty && sec.isEmpty) return null;
    if (cls.isNotEmpty && sec.isNotEmpty) return '$cls · $sec';
    return cls.isNotEmpty ? cls : sec;
  }

  List<_PortraitV13DetailRow> _detailRows() {
    final rows = <_PortraitV13DetailRow>[];
    void add(IconData icon, String value) {
      final v = value.trim();
      if (v.isNotEmpty) rows.add(_PortraitV13DetailRow(icon: icon, value: v));
    }

    add(Icons.family_restroom_outlined, data.fatherName);
    final cls = _classLine();
    if (cls != null) add(Icons.school_outlined, cls);
    add(Icons.badge_outlined, data.rollNo);
    add(Icons.bloodtype_outlined, data.bloodGroup);
    add(Icons.phone_android_outlined, data.mobileNumber);
    add(Icons.email_outlined, data.email);
    add(Icons.home_outlined, data.address);

    for (final term in data.backDetailLines) {
      add(Icons.notes_outlined, term);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    if (side == StudentIdCardSide.back) {
      return const SizedBox(
        width: _w,
        height: _h,
      );
    }
    return SizedBox(
      width: _w,
      height: _h,
      child: _buildFront(),
    );
  }

  Widget _buildFront() {
    final photoW = _w * _PortraitV13Layout.photoWidthRatio;
    final photoH = _h * _PortraitV13Layout.photoHeightRatio;
    final photoTop = _h * _PortraitV13Layout.photoTopRatio;
    final photoLeft = (_w - photoW) / 2;
    final session = data.validityText.trim();
    final detailRows = _detailRows();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV13,
          fit: BoxFit.fill,
        ),
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV13Layout.headerInstituteTop,
            height: _h * _PortraitV13Layout.headerInstituteHeight,
            left: _w * _PortraitV13Layout.headerInstituteSide,
            right: _w * _PortraitV13Layout.headerInstituteSide,
            child: _PortraitV13GradientTitle(
              text: data.instituteName.trim().toUpperCase(),
              maxLines: _instituteMaxLines(data.instituteName),
              style: _ts(const TextStyle(
                fontSize: IdCardPortraitTypography.headerFontSize,
                fontWeight: FontWeight.w900,
                height: 1.02,
                letterSpacing: 0.5,
              )),
              minFontSize: IdCardPortraitTypography.headerMinFontSize,
            ),
          ),
        if (data.address.trim().isNotEmpty || data.mobileNumber.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV13Layout.headerContactTop,
            height: _h * _PortraitV13Layout.headerContactHeight,
            left: _w * _PortraitV13Layout.headerContactSide,
            right: _w * _PortraitV13Layout.headerContactSide,
            child: _PortraitV13HeaderContacts(
              address: data.address.trim(),
              phone: data.mobileNumber.trim(),
              textStyle: _ts(const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: 0.35,
              )),
              minFontSize: 9,
            ),
          ),
        if (session.isNotEmpty)
          Positioned(
            left: _w * _PortraitV13Layout.sessionLeftRatio,
            width: _w * _PortraitV13Layout.sessionWidthRatio,
            top: photoTop,
            height: photoH,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                session,
                maxLines: 3,
                minFontSize: 10,
                textAlign: TextAlign.left,
                style: _ts(const TextStyle(
                  color: _PortraitV13Layout.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  letterSpacing: 0.35,
                )),
              ),
            ),
          ),
        Positioned(
          top: photoTop,
          left: photoLeft,
          width: photoW,
          height: photoH,
          child: _PortraitV13RectPhoto(
            photoPath: data.photoPath,
            width: photoW,
            height: photoH,
            borderWidth: _PortraitV13Layout.photoBorderWidth,
            radius: _PortraitV13Layout.photoRadius,
          ),
        ),
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV13Layout.namePillTopRatio,
            left: _w * _PortraitV13Layout.namePillSide,
            right: _w * _PortraitV13Layout.namePillSide,
            child: _PortraitV13NamePill(
              name: data.studentName.trim().toUpperCase(),
              textStyle: _ts(const TextStyle(
                color: _PortraitV13Layout.nameGreen,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                height: 1.05,
                letterSpacing: 0.45,
              )),
              minFontSize: 14,
            ),
          ),
        if (detailRows.isNotEmpty)
          Positioned(
            top: _h * _PortraitV13Layout.detailsTopRatio,
            left: _w * _PortraitV13Layout.detailsSide,
            right: _w * _PortraitV13Layout.detailsSide,
            bottom: _h * _PortraitV13Layout.detailsBottomRatio,
            child: _PortraitV13DetailList(
              rows: detailRows,
              textStyle: _ts(const TextStyle(
                color: _PortraitV13Layout.textDark,
                fontSize: _PortraitV13Layout.detailFontSize,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                height: 1.35,
                letterSpacing: 0.35,
              )),
              minFontSize: _PortraitV13Layout.detailMinFontSize,
              compact: data.useCompactFrontSpacing,
              relaxed: data.useRelaxedFrontSpacing,
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
}

class _PortraitV13DetailRow {
  const _PortraitV13DetailRow({required this.icon, required this.value});

  final IconData icon;
  final String value;
}

class _PortraitV13GradientTitle extends StatelessWidget {
  const _PortraitV13GradientTitle({
    required this.text,
    required this.maxLines,
    required this.style,
    required this.minFontSize,
  });

  final String text;
  final int maxLines;
  final TextStyle style;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _PortraitV13Layout.titleGradient,
      ).createShader(bounds),
      child: AutoSizeText(
        text,
        maxLines: maxLines,
        minFontSize: minFontSize,
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

class _PortraitV13HeaderContacts extends StatelessWidget {
  const _PortraitV13HeaderContacts({
    required this.address,
    required this.phone,
    required this.textStyle,
    required this.minFontSize,
  });

  final String address;
  final String phone;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (address.isNotEmpty) {
      rows.add(
        _PortraitV13ContactLine(
          icon: Icons.location_on_outlined,
          value: address,
          textStyle: textStyle,
          minFontSize: minFontSize,
        ),
      );
    }
    if (phone.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 2));
      rows.add(
        _PortraitV13ContactLine(
          icon: Icons.phone_outlined,
          value: phone,
          textStyle: textStyle,
          minFontSize: minFontSize,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }
}

class _PortraitV13ContactLine extends StatelessWidget {
  const _PortraitV13ContactLine({
    required this.icon,
    required this.value,
    required this.textStyle,
    required this.minFontSize,
  });

  final IconData icon;
  final String value;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.95)),
        const SizedBox(width: 5),
        Flexible(
          child: AutoSizeText(
            value,
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

class _PortraitV13RectPhoto extends StatelessWidget {
  const _PortraitV13RectPhoto({
    required this.photoPath,
    required this.width,
    required this.height,
    required this.borderWidth,
    required this.radius,
  });

  final String photoPath;
  final double width;
  final double height;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: _PortraitV13Layout.photoBorder,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final path = photoPath.trim();
    if (path.isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE8E4DC),
        child: Icon(
          Icons.person,
          size: height * 0.42,
          color: const Color(0xFF9CA3AF),
        ),
      );
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, width: width, height: height, fit: BoxFit.cover);
    }
    return ColoredBox(
      color: const Color(0xFFE8E4DC),
      child: Icon(
        Icons.person,
        size: height * 0.42,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

class _PortraitV13NamePill extends StatelessWidget {
  const _PortraitV13NamePill({
    required this.name,
    required this.textStyle,
    required this.minFontSize,
  });

  final String name;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: _PortraitV13Layout.pillBorder, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AutoSizeText(
          name,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}

class _PortraitV13DetailList extends StatelessWidget {
  const _PortraitV13DetailList({
    required this.rows,
    required this.textStyle,
    required this.minFontSize,
    required this.compact,
    required this.relaxed,
  });

  final List<_PortraitV13DetailRow> rows;
  final TextStyle textStyle;
  final double minFontSize;
  final bool compact;
  final bool relaxed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var gapMin = compact ? 4.0 : _PortraitV13Layout.detailRowGapMin;
        var gapMax = compact ? 8.0 : _PortraitV13Layout.detailRowGapMax;
        if (relaxed) {
          gapMin = 9;
          gapMax = 13;
        }

        final est = rows.length * 28.0;
        final free =
            (constraints.maxHeight - est).clamp(0.0, double.infinity);
        final gap = rows.length <= 1
            ? 0.0
            : (free / (rows.length - 1)).clamp(gapMin, gapMax);

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) SizedBox(height: gap),
                  _PortraitV13DetailItem(
                    row: rows[i],
                    textStyle: textStyle,
                    minFontSize: minFontSize,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PortraitV13DetailItem extends StatelessWidget {
  const _PortraitV13DetailItem({
    required this.row,
    required this.textStyle,
    required this.minFontSize,
  });

  final _PortraitV13DetailRow row;
  final TextStyle textStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              row.icon,
              size: 20,
              color: _PortraitV13Layout.iconTint,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AutoSizeText(
                row.value,
                maxLines: 3,
                minFontSize: minFontSize,
                textAlign: TextAlign.left,
                style: textStyle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const _PortraitV13DottedDivider(),
      ],
    );
  }
}

class _PortraitV13DottedDivider extends StatelessWidget {
  const _PortraitV13DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashW = 4.0;
        const gapW = 3.0;
        final count =
            (constraints.maxWidth / (dashW + gapW)).floor().clamp(1, 200);
        return Row(
          children: List.generate(count, (i) {
            return Container(
              width: dashW,
              height: 1.3,
              margin: EdgeInsets.only(right: i < count - 1 ? gapW : 0),
              color: _PortraitV13Layout.dottedLine,
            );
          }),
        );
      },
    );
  }
}
