import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 5 — gradient wave theme (ref: front/back company 5 PNGs).
abstract final class _CompanyV5Layout {
  static const Color textDark = Color(0xFF2D3748);
  static const Color textMuted = Color(0xFF718096);
  static const Color headerText = Colors.white;

  static const double headerBrandTop = 0.062;
  static const double headerBrandHeight = 0.10;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;
  static const double companyNameFontSize = 26;

  static const double frontPhotoSizeRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.405;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 22.0;
  static const double frontContentMinTopRatio = 0.485;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.08;
  static const double frontNameFontSize = 38;
  static const double frontTitleFontSize = 22;

  static const double backContentTop = 0.08;
  static const double backContentSide = 0.14;
  static const double backContentBottom = 0.32;
  static const double backBodyFontSize = 20;
  static const double backBodyMinFontSize = 14;
  static const double backLineGap = 8.0;

  static const double backSignatureTop = 0.58;
  static const double backSignatureHeight = 0.10;
  static const double backSignatureSide = 0.16;

  static const double backFooterHeight = 0.26;
  static const double backFooterSide = 0.10;
}

class CompanyIdTemplatePortraitV5 extends StatelessWidget {
  const CompanyIdTemplatePortraitV5({
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
  TextStyle _tsPrimary(TextStyle base) =>
      studentPortraitPrimaryTextStyle(base, fontFamily);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final photoSize = _w * _CompanyV5Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * _CompanyV5Layout.frontPhotoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV5Layout.frontGapBelowPhoto,
      _h * _CompanyV5Layout.frontContentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.frontBackgroundV5,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * _CompanyV5Layout.headerBrandTop,
          height: _h * _CompanyV5Layout.headerBrandHeight,
          left: _w * _CompanyV5Layout.headerBrandSide,
          right: _w * _CompanyV5Layout.headerBrandSide,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV5BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV5Layout.headerText,
                fontSize: _CompanyV5Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.5,
              )),
              minNameSize: 14,
              light: true,
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
            borderWidth: _CompanyV5Layout.frontPhotoBorderWidth,
            padding: 0,
            showShadow: true,
          ),
        ),
        Positioned(
          top: contentTop,
          left: _w * _CompanyV5Layout.frontContentSide,
          right: _w * _CompanyV5Layout.frontContentSide,
          bottom: _h * _CompanyV5Layout.frontContentBottomRatio,
          child: _CompanyV5FrontBody(
            data: data,
            nameStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.05,
            )),
            titleStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.nameFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.05,
            )),
            bodyStyle: _tsPrimary(const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: IdCardPortraitTypography.bodyFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.05,
              letterSpacing: 0.5,
            )),
            minFontSize: IdCardPortraitTypography.bodyMinFontSize,
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
    final detailLines = _CompanyV5BackLines.fromData(data);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          CompanyIdTemplateAssets.backBackgroundV5,
          fit: BoxFit.fill,
        ),
        if (detailLines.isNotEmpty)
          Positioned(
            top: _h * _CompanyV5Layout.backContentTop,
            left: _w * _CompanyV5Layout.backContentSide,
            right: _w * _CompanyV5Layout.backContentSide,
            bottom: _h * _CompanyV5Layout.backContentBottom,
            child: _CompanyV5BackDetailList(
              lines: detailLines,
              style: _ts(const TextStyle(
                color: _CompanyV5Layout.textDark,
                fontSize: _CompanyV5Layout.backBodyFontSize,
                fontWeight: FontWeight.w500,
                height: 1.35,
              )),
              minFontSize: _CompanyV5Layout.backBodyMinFontSize,
            ),
          ),

        Positioned(
          left: _w * _CompanyV5Layout.backFooterSide,
          right: _w * _CompanyV5Layout.backFooterSide,
          bottom: 0,
          height: _h * _CompanyV5Layout.backFooterHeight,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV5BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: _ts(const TextStyle(
                color: _CompanyV5Layout.headerText,
                fontSize: _CompanyV5Layout.companyNameFontSize,
                fontWeight: FontWeight.w800,
                height: 1.05,
              )),
              minNameSize: 14,
              light: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompanyV5BackLines {
  static List<String> fromData(EmployeeData data) {
    final lines = <String>[];
    void add(String value) {
      final v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    for (final note in data.backDetailLines) {
      add(note);
    }

    final contact = <String>[];
    void addContact(String value) {
      final v = value.trim();
      if (v.isNotEmpty) contact.add(v);
    }

    addContact(data.employeeId);
    addContact(data.email);
    addContact(data.phone);
    addContact(data.bloodGroup);

    final dates = <String>[];
    void addDate(String value) {
      final v = value.trim();
      if (v.isNotEmpty) dates.add(v);
    }

    addDate(data.joinDate);

    if (lines.isNotEmpty && (contact.isNotEmpty || dates.isNotEmpty)) {
      lines.add('');
    }
    lines.addAll(contact);
    if (contact.isNotEmpty && dates.isNotEmpty) {
      lines.add('');
    }
    lines.addAll(dates);
    return lines;
  }
}

class _CompanyV5BrandRow extends StatelessWidget {
  const _CompanyV5BrandRow({
    required this.companyName,
    required this.logoAsset,
    required this.nameStyle,
    required this.minNameSize,
    required this.light,
  });

  final String companyName;
  final String logoAsset;
  final TextStyle nameStyle;
  final double minNameSize;
  final bool light;

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
              width: _CompanyV5Layout.logoSize,
              height: _CompanyV5Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.change_history_rounded,
                size: _CompanyV5Layout.logoSize,
                color: light ? Colors.white : _CompanyV5Layout.textDark,
              ),
            ),
          ),
          SizedBox(width: _CompanyV5Layout.logoGap),
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

class _CompanyV5FrontBody extends StatelessWidget {
  const _CompanyV5FrontBody({
    required this.data,
    required this.nameStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.minFontSize,
  });

  final EmployeeData data;
  final TextStyle nameStyle;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    String cap(String raw) {
      final s = raw.trim();
      if (s.isEmpty) return '';
      return s
          .split(' ')
          .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final blocks = <Widget>[];
    final estimates = <double>[];

    void add(Widget w, double est) {
      blocks.add(w);
      estimates.add(est);
    }

    final name = cap(data.employeeName);
    if (name.isNotEmpty) {
      add(
        AutoSizeText(
          name,
          maxLines: 2,
          minFontSize: minFontSize + 4,
          textAlign: TextAlign.center,
          style: nameStyle,
        ),
        (nameStyle.fontSize ?? 42) * 1.08,
      );
    }

    final title = cap(data.position);
    if (title.isNotEmpty) {
      add(
        AutoSizeText(
          title,
          maxLines: 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        (titleStyle.fontSize ?? 42) * 1.08,
      );
    }

    for (final line in data.frontDetailLines) {
      final isEmail = line.contains('@');
      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: minFontSize,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        (bodyStyle.fontSize ?? 32) * (isEmail ? 1.45 : 1.22),
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
        final gap = (free / gapCount).clamp(3.0, 10.0);

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
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class _CompanyV5BackDetailList extends StatelessWidget {
  const _CompanyV5BackDetailList({
    required this.lines,
    required this.style,
    required this.minFontSize,
  });

  final List<String> lines;
  final TextStyle style;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (final line in lines) {
      if (line.isEmpty) {
        items.add(const SizedBox(height: _CompanyV5Layout.backLineGap));
        continue;
      }
      items.add(
        AutoSizeText(
          line,
          maxLines: 2,
          minFontSize: minFontSize,
          textAlign: TextAlign.left,
          style: style,
        ),
      );
      items.add(const SizedBox(height: _CompanyV5Layout.backLineGap));
    }
    if (items.isNotEmpty) items.removeLast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: items,
    );
  }
}

class _CompanyV5SignaturePreview extends StatelessWidget {
  const _CompanyV5SignaturePreview({
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
