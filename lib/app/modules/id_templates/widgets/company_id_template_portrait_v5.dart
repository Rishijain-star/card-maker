import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_data.dart';
import '../assets/company_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_text_styles.dart';
import '../design_system/id_card_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

/// Company template 5 — gradient wave theme (ref: front/back company 5 PNGs).
///
/// Artwork only. All text styling comes from [IdCardTextStyles] so that every
/// template renders the same data identically — only the design differs.
abstract final class _CompanyV5Layout {
  static const double headerBrandTop = 0.062;
  static const double headerBrandHeight = 0.10;
  static const double headerBrandSide = 0.10;
  static const double logoSize = 36.0;
  static const double logoGap = 8.0;

  static const double frontPhotoSizeRatio = 0.34;
  static const double frontPhotoCenterYRatio = 0.405;
  static const double frontPhotoBorderWidth = 4.0;
  static const double frontGapBelowPhoto = 22.0;
  static const double frontContentMinTopRatio = 0.485;
  static const double frontContentSide = 0.12;
  static const double frontContentBottomRatio = 0.08;

  static const double backContentTop = 0.08;
  static const double backContentSide = 0.14;
  static const double backContentBottom = 0.32;
  static const double backBodyMinFontSize = 14;
  static const double backLineGap = 8.0;
}

class CompanyIdTemplatePortraitV5 extends StatelessWidget {
  const CompanyIdTemplatePortraitV5({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Poppins',
    this.frontBgAsset,
    this.backBgAsset,
  });

  final EmployeeData data;
  final StudentIdCardSide side;
  final String fontFamily;
  final String? frontBgAsset;
  final String? backBgAsset;

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
    final isCustomBg = frontBgAsset != null;
    final photoCenterYRatio = isCustomBg ? 0.280 : _CompanyV5Layout.frontPhotoCenterYRatio;
    final contentMinTopRatio = isCustomBg ? 0.420 : _CompanyV5Layout.frontContentMinTopRatio;
    final headerTopRatio = isCustomBg ? 0.035 : _CompanyV5Layout.headerBrandTop;
    final headerSideRatio = isCustomBg ? 0.08 : _CompanyV5Layout.headerBrandSide;
    final headerTextColor = Colors.white;

    final photoSize = _w * _CompanyV5Layout.frontPhotoSizeRatio;
    final photoTop =
        _h * photoCenterYRatio - photoSize / 2;
    final photoLeft = (_w - photoSize) / 2;
    final contentTop = [
      photoTop + photoSize + _CompanyV5Layout.frontGapBelowPhoto,
      _h * contentMinTopRatio,
    ].reduce((a, b) => a > b ? a : b);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          frontBgAsset ?? CompanyIdTemplateAssets.frontBackgroundV5,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: _h * headerTopRatio,
          height: _h * _CompanyV5Layout.headerBrandHeight,
          left: _w * headerSideRatio,
          right: _w * headerSideRatio,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV5BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily, onBanner: !isCustomBg, color: headerTextColor),
              minNameSize: 9,
              light: !isCustomBg,
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
            nameStyle: IdCardTextStyles.personName(fontFamily),
            titleStyle: IdCardTextStyles.position(fontFamily),
            bodyStyle: IdCardTextStyles.detail(fontFamily),
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
          backBgAsset ?? CompanyIdTemplateAssets.backBackgroundV5,
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
              style: IdCardTextStyles.terms(fontFamily),
              minFontSize: _CompanyV5Layout.backBodyMinFontSize,
            ),
          ),

        Positioned(
          left: _w * 0.05,
          right: _w * 0.05,
          bottom: _h * 0.02,
          height: _h * 0.08,
          child: Align(
            alignment: Alignment.center,
            child: _CompanyV5BrandRow(
              companyName: data.companyName,
              logoAsset: data.logoAsset,
              nameStyle: IdCardTextStyles.instituteHeader(fontFamily),
              minNameSize: IdCardPortraitTypography.headerMinFontSize,
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
    addContact(data.joinDate);
    addContact(data.address);
    addContact(data.phone);
    addContact(data.email);
    addContact(data.bloodGroup);

    if (lines.isNotEmpty && contact.isNotEmpty) {
      lines.add('');
    }
    lines.addAll(contact);
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
    final hasLogo = logo.isNotEmpty && !logo.contains('history');

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasLogo) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              logo,
              width: _CompanyV5Layout.logoSize,
              height: _CompanyV5Layout.logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SizedBox(width: _CompanyV5Layout.logoGap),
        ],
        if (name.isNotEmpty)
          Flexible(
            child: AutoSizeText(
              IdCardTypography.formatInstituteName(name.toUpperCase()),
              maxLines: 2,
              minFontSize: 14,
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

    final detailLines = data.frontDetailLines;
    for (var i = 0; i < detailLines.length; i++) {
      final line = detailLines[i];
      final isEmail = line.contains('@');
      final isStudentProminentLine = data.isStudentData && i < 2;
      final lineStyle = isStudentProminentLine ? nameStyle : bodyStyle;
      final lineMinFont =
          isStudentProminentLine ? (minFontSize + 4) : minFontSize;

      add(
        AutoSizeText(
          cap(line),
          maxLines: isEmail ? 2 : 1,
          minFontSize: lineMinFont,
          textAlign: TextAlign.center,
          style: lineStyle,
        ),
        (lineStyle.fontSize ?? 32) *
            (isEmail ? 1.45 : (isStudentProminentLine ? 1.08 : 1.22)),
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
        final gap = (free / gapCount).clamp(10.0, 18.0);

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
