import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../assets/student_id_template_assets.dart';
import '../design_system/id_card_portrait_typography.dart';
import '../design_system/id_card_typography.dart';
import 'student_id_card_side.dart';
import 'student_profile_photo.dart';

/// Standardized Image-Only widget for all 40 Student ID Card templates.
/// Renders the background template image in an identical, standardized canvas ratio.
/// Optionally overlays Institute Name on the front face — same position on every template.
class StudentIdTemplateImageOnly extends StatelessWidget {
  const StudentIdTemplateImageOnly({
    super.key,
    required this.templateIndex,
    required this.side,
    this.instituteName = '',
    this.fontFamily = 'Merienda',
    this.photoPath = '',
    this.studentName = '',
    this.fatherName = '',
    this.className = '',
    this.section = '',
    this.rollNo = '',
    this.mobileNumber = '',
    this.bloodGroup = '',
    this.address = '',
    this.signaturePath = '',
    this.signatureBytes,
    this.term1 = '',
    this.term2 = '',
    this.term3 = '',
    this.validFrom = '',
    this.validTo = '',
    this.isPreview = false,
    this.customHeaderColor,
    this.customTextColor,
  });

  final int templateIndex;
  final StudentIdCardSide side;

  /// Institute name to display on front face (empty → no overlay).
  final String instituteName;

  /// Font family for Institute Name text (Merienda by default).
  final String fontFamily;

  /// Path to the student's profile photo.
  final String photoPath;

  final String studentName;
  final String fatherName;
  final String className;
  
  final String section;
  final String rollNo;
  final String mobileNumber;
  final String bloodGroup;
  final String address;
  final String signaturePath;
  final Uint8List? signatureBytes;
  
  final String term1;
  final String term2;
  final String term3;
  final String validFrom;
  final String validTo;
  final bool isPreview;
  final Color? customHeaderColor;
  final Color? customTextColor;

  /// Standard portrait ID card aspect ratio (53.98mm / 85.60mm)
  static const double cardAspectRatio = 53.98 / 85.60;

  /// Top safe gap — 3.5% of card height. Same on ALL 40 templates.
  static const double _topSafeGapFraction = 0.035;

  /// Horizontal padding — 4% from each side.
  static const double _horizontalPaddingFraction = 0.07;

  @override
  Widget build(BuildContext context) {
    final isFront = (side == StudentIdCardSide.front);
    final bgAsset = isFront
        ? StudentIdTemplateAssets.getFrontAsset(templateIndex)
        : StudentIdTemplateAssets.getBackAsset(templateIndex);

    final showInstitute = isFront && instituteName.trim().isNotEmpty;
    final showPhoto = isFront; // We show photo placeholder even if path is empty, unless instructed otherwise. Actually, let's keep it consistent.
    
    final sName = studentName.trim();
    final fName = fatherName.trim();
    final cName = className.trim();
    
    final sec = section.trim();
    final roll = rollNo.trim();
    final mob = mobileNumber.trim();
    final bg = bloodGroup.trim();
    final addr = address.trim();
    
    final t1 = term1.trim();
    final t2 = term2.trim();
    final t3 = term3.trim();
    final vFrom = validFrom.trim();
    final vTo = validTo.trim();

    // Determine if overlay should be rendered
    final hasFrontContent = isFront && (showInstitute || showPhoto || sName.isNotEmpty || fName.isNotEmpty || cName.isNotEmpty);
    final hasBackContent = !isFront && (t1.isNotEmpty || t2.isNotEmpty || t3.isNotEmpty || vFrom.isNotEmpty || vTo.isNotEmpty);
    final hasOverlayContent = hasFrontContent || hasBackContent;

    return AspectRatio(
      aspectRatio: cardAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardH = constraints.maxHeight;
            final cardW = constraints.maxWidth;
            final topGap = cardH * _topSafeGapFraction;
            final hPad = cardW * _horizontalPaddingFraction;

            Widget? photoWidget;
            if (showPhoto) {
              // 0-indexed mapping
              final squareIndices = const [9, 11, 12, 17, 19, 34];
              final hexagonIndices = const [3, 6, 28, 31, 39];

              if (squareIndices.contains(templateIndex)) {
                photoWidget = StudentSquarePhoto(photoPath: photoPath, cardWidth: cardW);
              } else if (hexagonIndices.contains(templateIndex)) {
                photoWidget = StudentHexagonPhoto(photoPath: photoPath, cardWidth: cardW);
              } else {
                photoWidget = StudentCirclePhoto(photoPath: photoPath, cardWidth: cardW);
              }
            }

            Color instituteNameColor = Colors.white;
            final blackInstituteIndices = const [9, 12, 13, 19, 20]; // 1-indexed: 10, 13, 14, 20, 21
            final greenInstituteIndices = const [24]; // 1-indexed: 25
            
            if (customHeaderColor != null) {
              instituteNameColor = customHeaderColor!;
            } else if (blackInstituteIndices.contains(templateIndex)) {
              instituteNameColor = Colors.black;
            } else if (greenInstituteIndices.contains(templateIndex)) {
              instituteNameColor = Colors.green;
            }
            
            Color detailsTextColor = Colors.black;
            final whiteDetailsIndices = const [19, 29, 30]; // 1-indexed: 20, 30, 31
            
            if (customTextColor != null) {
              detailsTextColor = customTextColor!;
            } else if (whiteDetailsIndices.contains(templateIndex)) {
              detailsTextColor = Colors.white;
            }

            // Create a list of text fields dynamically based on availability
            // (text, isAddress flag)
            final textFieldsToRender = <MapEntry<String, bool>>[];
            if (isFront) {
              if (sName.isNotEmpty) textFieldsToRender.add(MapEntry(sName, false));
              if (fName.isNotEmpty) textFieldsToRender.add(MapEntry(fName, false));
              if (cName.isNotEmpty) textFieldsToRender.add(MapEntry(cName, false));
              
              // Add the extra 5 fields for ALL 40 templates
              if (sec.isNotEmpty) textFieldsToRender.add(MapEntry(sec, false));
              if (roll.isNotEmpty) textFieldsToRender.add(MapEntry(roll, false));
              if (mob.isNotEmpty) textFieldsToRender.add(MapEntry(mob, false));
              if (bg.isNotEmpty) textFieldsToRender.add(MapEntry(bg, false));
              if (addr.isNotEmpty) textFieldsToRender.add(MapEntry(addr, true));
            } else {
              if (t1.isNotEmpty) textFieldsToRender.add(MapEntry(t1, false));
              if (t2.isNotEmpty) textFieldsToRender.add(MapEntry(t2, false));
              if (t3.isNotEmpty) textFieldsToRender.add(MapEntry(t3, false));
              if (vFrom.isNotEmpty) textFieldsToRender.add(MapEntry('Validity From: $vFrom', false));
              if (vTo.isNotEmpty) textFieldsToRender.add(MapEntry('Validity To: $vTo', false));
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // ── Layer 1: Background template image ────────────────────
                Image.asset(
                  bgAsset,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),

                // ── Layer 2: Overlay ─────
                if (hasOverlayContent)
                  if (isFront)
                    Positioned(
                      top: topGap,
                      left: hPad,
                      right: hPad,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showInstitute)
                            _HeaderStyleText(
                              text: IdCardTypography.formatInstituteName(instituteName.trim()),
                              fontFamily: fontFamily,
                              textColor: instituteNameColor,
                              isPreview: isPreview,
                            ),
                            
                          // Consistent visual gap between Institute Name and Photo
                          if (showInstitute && showPhoto)
                            SizedBox(height: cardH * 0.02),
                            
                          if (photoWidget != null)
                            photoWidget,
                            
                          // Clear gap between Photo and the first text field
                          if (showPhoto && textFieldsToRender.isNotEmpty)
                            SizedBox(height: cardH * 0.035),
                            
                          // Dynamically render all text fields with consistent spacing
                          for (int i = 0; i < textFieldsToRender.length; i++) ...[
                            if (i > 0) SizedBox(height: cardH * 0.012),
                            _HeaderStyleText(
                              text: textFieldsToRender[i].key,
                              fontFamily: fontFamily,
                              textColor: detailsTextColor,
                              isPreview: isPreview,
                              // Reduce font size slightly for address
                              fontSizeOverride: textFieldsToRender[i].value 
                                  ? IdCardPortraitTypography.headerFontSize * 0.82 
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: hPad,
                      right: hPad,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < textFieldsToRender.length; i++) ...[
                              if (i > 0) SizedBox(height: cardH * 0.015),
                              _HeaderStyleText(
                                text: textFieldsToRender[i].key,
                                fontFamily: fontFamily,
                                textColor: detailsTextColor,
                                isPreview: isPreview,
                                // Smaller approved text size for back side
                                fontSizeOverride: IdCardPortraitTypography.headerFontSize * 0.45,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                // ── Layer 3: Signature / Stamp (Bottom Right Ellipse) ─────
                if (isFront && (signaturePath.isNotEmpty || signatureBytes != null))
                  Positioned(
                    bottom: cardH * 0.03, // Safe spacing from bottom edge
                    right: cardW * 0.05,  // Safe spacing from right edge
                    child: SizedBox(
                      width: cardW * 0.22,  // Width > Height for Ellipse
                      height: cardH * 0.08, 
                      child: ClipOval(
                        child: signatureBytes != null
                            ? Image.memory(
                                signatureBytes!,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(signaturePath),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Reusable generic text widget — exactly identical styling for Institute, Student, Father, and Class.
///
/// • Horizontally center aligned (every line)
/// • Word-based wrapping only (no mid-word breaks)
/// • Merienda (or user-selected) font, italic, w700 bold
/// • Compact line spacing (height: 1.18)
/// • Subtle drop-shadow for readability on any background
class _HeaderStyleText extends StatelessWidget {
  const _HeaderStyleText({
    required this.text,
    required this.fontFamily,
    this.fontSizeOverride,
    this.textColor = Colors.white,
    this.isPreview = false,
  });

  final String text;
  final String fontFamily;
  final double? fontSizeOverride;
  final Color textColor;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: fontSizeOverride ?? IdCardPortraitTypography.headerFontSize, // 38px — consistent
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: textColor,
      height: 1.18,
      letterSpacing: 0.3,
      shadows: isPreview ? null : const <Shadow>[
        Shadow(
          color: Color(0xAA000000),
          offset: Offset(0, 1.5),
          blurRadius: 4,
        ),
      ],
    );

    // Apply selected font (Merienda default). scale: 1.0 — fixed size.
    final resolvedStyle = IdCardTypography.apply(baseStyle, fontFamily, scale: 1.0);

    return Text(
      text,
      style: resolvedStyle,
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
