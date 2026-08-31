import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_flow/controllers/create_flow_controller.dart';
import 'id_card_portrait_typography.dart';
import 'id_card_typography.dart';

/// The single source of truth for **every** piece of text on an ID card.
///
/// Templates must not build their own [TextStyle]s. They ask for a *role*
/// here, so font family, size, weight, letter spacing, line height and colour
/// stay identical across every design. A template only varies its **artwork**
/// — background image, shapes, photo frame, positioning.
///
/// Colour comes from two user-facing pickers, applied by role:
///  * **Header Color** drives [instituteHeader] (the school / company name).
///  * **Text Color** drives every other role.
///
/// A template may pass [onBanner] when its text sits on a coloured strip or
/// pill, which only changes the *default* (light instead of dark). A `color`
/// argument likewise only sets a default — the user's picker always wins, so
/// no design can opt out of being recoloured.
///
/// Sizes come from [IdCardPortraitTypography] and are multiplied by the
/// user's font-size slider inside [IdCardTypography.apply], so every role
/// scales together.
abstract final class IdCardTextStyles {
  static CreateFlowController? get _flow =>
      Get.isRegistered<CreateFlowController>()
          ? Get.find<CreateFlowController>()
          : null;

  /// Resolves the final colour: the user's picker for this role if set,
  /// otherwise the template's default, otherwise the shared default.
  static Color _resolveColor({
    required bool isHeader,
    required bool onBanner,
    Color? templateDefault,
    Color? mutedDefault,
  }) {
    int? custom;
    final isEmployee = _flow?.isEmployeeService ?? false;

    if (isEmployee) {
      final empEditingIdx = _flow?.employeeEditingTemplateIndex.value ?? -1;
      final empActiveIdx = _flow?.employeeSelectedTemplate.value ?? -1;
      if (empEditingIdx != -1) {
        custom = isHeader
            ? _flow?.empCustomHeaderColorHex.value
            : _flow?.empCustomTextColorHex.value;
      } else if (empActiveIdx != -1) {
        // Fallback to flow if we wanted to get from saved settings
        // But getCustomHeaderColorForTemplate handles isEmployeeService branching internally now!
        custom = isHeader
            ? _flow?.getCustomHeaderColorForTemplate(empActiveIdx)
            : _flow?.getCustomTextColorForTemplate(empActiveIdx);
      }
    } else {
      final editingIdx = _flow?.editingTemplateIndex.value ?? -1;
      final activeIdx = _flow?.selectedTemplate.value ?? -1;

      if (editingIdx != -1) {
        custom = isHeader
            ? _flow?.idCardCustomHeaderColorHex.value
            : _flow?.idCardCustomTextColorHex.value;
      } else if (activeIdx != -1) {
        custom = isHeader
            ? _flow?.getCustomHeaderColorForTemplate(activeIdx)
            : _flow?.getCustomTextColorForTemplate(activeIdx);
      }
    }

    if (custom != null) return Color(custom);
    if (templateDefault != null) return templateDefault;
    if (mutedDefault != null) return mutedDefault;
    return onBanner
        ? IdCardPortraitTypography.onBannerColor
        : IdCardPortraitTypography.nameColor;
  }

  static TextStyle _build(
    String fontFamily, {
    required double fontSize,
    required FontWeight fontWeight,
    required bool onBanner,
    bool isHeader = false,
    Color? color,
    Color? mutedDefault,
    double? letterSpacing,
    double? height,
  }) {
    final resolvedColor = _resolveColor(
      isHeader: isHeader,
      onBanner: onBanner,
      templateDefault: color,
      mutedDefault: mutedDefault,
    );

    final baseStyle = TextStyle(
      color: resolvedColor,
      fontSize: fontSize,
      fontWeight: isHeader ? FontWeight.w900 : fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      shadows: isHeader
          ? [
              Shadow(color: resolvedColor, offset: const Offset(0.5, 0.5)),
              Shadow(color: resolvedColor, offset: const Offset(-0.5, -0.5)),
              Shadow(color: resolvedColor, offset: const Offset(0.5, -0.5)),
              Shadow(color: resolvedColor, offset: const Offset(-0.5, 0.5)),
            ]
          : null,
    );

    return IdCardTypography.apply(
      baseStyle,
      fontFamily,
    );
  }

  /// How many lines the institute name should be allowed to occupy.
  ///
  /// [IdCardTypography.formatInstituteName] already inserts explicit line
  /// breaks for long names, so the answer is simply how many lines it
  /// produced. Short names like "CITY PUBLIC SCHOOL" therefore get a single
  /// line and shrink to fit, instead of wrapping in some templates and not
  /// others depending on how wide that design's header happens to be.
  static int instituteMaxLines(String rawName) {
    final formatted = IdCardTypography.formatInstituteName(rawName);
    final lines =
        formatted.split('\n').where((s) => s.trim().isNotEmpty).length;
    return lines.clamp(1, 4);
  }

  /// School / company name — the big title, front and back.
  /// Driven by the user's **Header Color** picker.
  /// Defaults to on-banner white, since that is where it usually sits.
  static TextStyle instituteHeader(
    String fontFamily, {
    bool onBanner = true,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.headerFontSize,
        fontWeight: FontWeight.w900,
        onBanner: onBanner,
        isHeader: true,
        color: color,
        letterSpacing: 1.2,
        height: 1.08,
      );

  /// The cardholder's name — student or employee.
  static TextStyle personName(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.nameFontSize,
        fontWeight: FontWeight.w900,
        onBanner: onBanner,
        color: color,
        letterSpacing: 0.5,
        height: 1.05,
      );

  /// Father's / guardian's name — same treatment as the cardholder's name.
  static TextStyle fatherName(String fontFamily, {bool onBanner = false, Color? color}) =>
      personName(fontFamily, onBanner: onBanner, color: color);

  /// Course / class / section.
  static TextStyle course(String fontFamily, {bool onBanner = false, Color? color}) =>
      personName(fontFamily, onBanner: onBanner, color: color);

  /// Job title or designation — de-emphasised sub-line under the name.
  static TextStyle position(String fontFamily) => _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.nameFontSize,
        fontWeight: FontWeight.w900,
        onBanner: false,
        mutedDefault: IdCardPortraitTypography.mutedColor,
        height: 1.15,
      );

  /// Front detail lines — ID number, phone, blood group, address…
  static TextStyle detail(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.bodyFontSize,
        fontWeight: FontWeight.w900,
        onBanner: onBanner,
        color: color,
        letterSpacing: 0.5,
        height: 1.05,
      );

  /// Back-of-card body lines.
  static TextStyle backBody(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.backBodyFontSize,
        fontWeight: FontWeight.w600,
        onBanner: onBanner,
        color: color,
        height: 1.3,
      );

  /// Section heading on the back, e.g. "Terms And Conditions :".
  static TextStyle sectionHeading(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.sectionHeadingFontSize,
        fontWeight: FontWeight.w800,
        onBanner: onBanner,
        color: color,
        height: 1.1,
      );

  /// Terms & conditions / instruction bullets on the back.
  static TextStyle terms(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.termsFontSize,
        fontWeight: FontWeight.w400,
        onBanner: onBanner,
        color: color,
        height: 1.38,
      );

  /// Contact rows on the back (phone / email / website).
  static TextStyle contact(
    String fontFamily, {
    bool onBanner = false,
    Color? color,
  }) =>
      _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.termsFontSize,
        fontWeight: FontWeight.w500,
        onBanner: onBanner,
        color: color,
        height: 1.25,
      );

  /// "Valid From" / "Valid To" caption.
  static TextStyle validityLabel(String fontFamily) => _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.validityLabelFontSize,
        fontWeight: FontWeight.w900,
        onBanner: false,
        letterSpacing: 0.35,
      );

  /// The date next to a validity caption.
  static TextStyle validityValue(String fontFamily) => _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.validityLabelFontSize,
        fontWeight: FontWeight.w700,
        onBanner: false,
        letterSpacing: 0.35,
      );

  /// Small footer strip (validity line, issued-on note).
  static TextStyle footer(String fontFamily) => _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.validityFontSize,
        fontWeight: FontWeight.w800,
        onBanner: false,
        height: 1.2,
      );

  /// Small pill / badge text (session, category) — sits on a coloured chip.
  static TextStyle badge(String fontFamily, {bool onBanner = true}) => _build(
        fontFamily,
        fontSize: IdCardPortraitTypography.badgeFontSize,
        fontWeight: FontWeight.w800,
        onBanner: onBanner,
        height: 1.0,
      );
}
