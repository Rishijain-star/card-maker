import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/models/student_data.dart';
import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_dimensions.dart';
import '../design_system/id_card_portrait_typography.dart';
import 'student_id_card_side.dart';
import 'student_id_portrait_widgets.dart';

abstract final class _PortraitV17Layout {
  static const double headerTop = 0.035;
  static const double headerHeight = 0.075;
  static const double headerSide = 0.05;

  static const double photoTopRatio = 0.118;
  static const double photoSizeRatio = 0.400;

  static const double nameTop = 0.380;
  static const double nameLeft = 0.240;
  static const double nameRight = 0.050;

  static const double detailsTop = 0.450;
  static const double detailsLeft = 0.240;
  static const double detailsRight = 0.050;
  static const double detailsBottom = 0.070;

  static const double backHeaderTop = 0.035;
  static const double backHeaderHeight = 0.075;
  static const double backHeaderSide = 0.05;

  static const double backTermsTop = 0.160;
  static const double backTermsLeft = 0.160;
  static const double backTermsRight = 0.060;
  static const double backTermsBottom = 0.160;
}

class StudentIdTemplatePortraitV17 extends StatelessWidget {
  const StudentIdTemplatePortraitV17({
    super.key,
    required this.data,
    required this.side,
    this.fontFamily = 'Times New Roman',
  });

  final StudentData data;
  final StudentIdCardSide side;
  final String fontFamily;

  static const double _w = IdCardPortraitDimensions.width;
  static const double _h = IdCardPortraitDimensions.height;

  TextStyle _ts(TextStyle base) => studentPortraitTextStyle(base, fontFamily);
  TextStyle _tsPrimary(TextStyle base) =>
      studentPortraitPrimaryTextStyle(base, fontFamily);

  static int _instituteMaxLines(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return 1;
    final words = s.split(RegExp(r'\s+'));
    return words.length >= 4 ? 2 : 1;
  }

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
    return SizedBox(
      width: _w,
      height: _h,
      child: side == StudentIdCardSide.front ? _buildFront() : _buildBack(),
    );
  }

  List<String> _frontDetailLines() {
    final list = <String>[];

    if (data.fatherName.trim().isNotEmpty) {
      list.add('F/N: ${_cap(data.fatherName)}');
    }
    if (data.rollNo.trim().isNotEmpty) {
      list.add('Roll No: ${data.rollNo.trim()}');
    }
    if (data.className.trim().isNotEmpty) {
      list.add('Class: ${data.className.trim()}');
    }
    if (data.bloodGroup.trim().isNotEmpty) {
      list.add('Blood Grp: ${data.bloodGroup.trim().toUpperCase()}');
    }
    if (data.mobileNumber.trim().isNotEmpty) {
      list.add('Contact: ${data.mobileNumber.trim()}');
    }
    final addressStr = data.address.trim();
    if (addressStr.isNotEmpty) {
      list.add(addressStr);
    }
    return list;
  }

  Widget _buildFront() {
    final photoSize = _w * _PortraitV17Layout.photoSizeRatio;
    final photoTop = _h * _PortraitV17Layout.photoTopRatio;
    final photoLeft = (_w - photoSize) / 2;
    final detailLines = _frontDetailLines();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          StudentIdTemplateAssets.frontBackgroundV17,
          fit: BoxFit.fill,
        ),

        // Institute Name — Header over green polygon banner
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV17Layout.headerTop,
            height: _h * _PortraitV17Layout.headerHeight,
            left: _w * _PortraitV17Layout.headerSide,
            right: _w * _PortraitV17Layout.headerSide,
            child: Center(
              child: AutoSizeText(
                formatInstituteName(data.instituteName.trim().toUpperCase()),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: 0.3,
                )),
              ),
            ),
          ),

        // Photo — overlaying top-center circular cutout
        Positioned(
          top: photoTop,
          left: photoLeft,
          child: StudentPortraitPhoto(
            photoPath: data.photoPath,
            size: photoSize,
            borderColor: Colors.white,
            borderWidth: 4.0,
            showShadow: true,
          ),
        ),

        // Student Name — below photo circle
        if (data.studentName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV17Layout.nameTop,
            left: _w * _PortraitV17Layout.nameLeft,
            right: _w * _PortraitV17Layout.nameRight,
            child: AutoSizeText(
              _cap(data.studentName),
              maxLines: 2,
              minFontSize: IdCardPortraitTypography.nameMinFontSize,
              textAlign: TextAlign.left,
              style: _tsPrimary(const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: 0.35,
              )),
            ),
          ),

        // Detail list
        if (detailLines.isNotEmpty)
          Positioned(
            top: _h * _PortraitV17Layout.detailsTop,
            left: _w * _PortraitV17Layout.detailsLeft,
            right: _w * _PortraitV17Layout.detailsRight,
            bottom: _h * _PortraitV17Layout.detailsBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: detailLines
                  .map((line) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: AutoSizeText(
                          line,
                          maxLines: 2,
                          minFontSize: IdCardPortraitTypography.bodyMinFontSize,
                          textAlign: TextAlign.left,
                          style: _ts(const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: IdCardPortraitTypography.bodyFontSize,
                            fontWeight: FontWeight.w800,
                            height: 1.20,
                            letterSpacing: 0.3,
                          )),
                        ),
                      ))
                  .toList(),
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
          StudentIdTemplateAssets.backBackgroundV17,
          fit: BoxFit.fill,
        ),

        // Institute Name — Back Header
        if (data.instituteName.trim().isNotEmpty)
          Positioned(
            top: _h * _PortraitV17Layout.backHeaderTop,
            height: _h * _PortraitV17Layout.backHeaderHeight,
            left: _w * _PortraitV17Layout.backHeaderSide,
            right: _w * _PortraitV17Layout.backHeaderSide,
            child: Center(
              child: AutoSizeText(
                formatInstituteName(data.instituteName.trim().toUpperCase()),
                maxLines: _instituteMaxLines(data.instituteName),
                minFontSize: IdCardPortraitTypography.headerMinFontSize,
                textAlign: TextAlign.center,
                style: _ts(const TextStyle(
                  color: Colors.white,
                  fontSize: IdCardPortraitTypography.headerFontSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: 0.35,
                )),
              ),
            ),
          ),

        // Terms & Conditions list
        if (terms.isNotEmpty)
          Positioned(
            top: _h * _PortraitV17Layout.backTermsTop,
            left: _w * _PortraitV17Layout.backTermsLeft,
            right: _w * _PortraitV17Layout.backTermsRight,
            bottom: _h * _PortraitV17Layout.backTermsBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: terms
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: _ts(const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                t,
                                maxLines: 2,
                                minFontSize: 14,
                                style: _ts(const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

        // Back Signature
        if (data.hasSignature)
          Positioned(
            right: _w * 0.08,
            bottom: _h * 0.05,
            child: StudentPortraitSignatureCircle(
              size: _h * 0.09,
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
