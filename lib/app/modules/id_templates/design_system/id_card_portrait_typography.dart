import 'package:flutter/material.dart';

/// Shared portrait student ID font sizes (all student PNG templates, matching Card 1).
abstract final class IdCardPortraitTypography {
  static const double headerFontSize = 38.0;
  static const double headerMinFontSize = 38.0;

  static const double nameFontSize = 40;
  static const double nameMinFontSize = 22;

  /// The three colours every template's text is allowed to use. Never tie
  /// card text to a template's own accent colour — the design changes, the
  /// text styling does not. All three are swapped together by the user's
  /// "Font Color" picker (see [IdCardTypography.apply]).
  ///
  /// [nameColor] — default, for text on the plain card background.
  static const Color nameColor = Color(0xFF0F172A);

  /// For text sitting on a template's coloured header strip or pill.
  static const Color onBannerColor = Color(0xFFFFFFFF);

  /// De-emphasised sub-lines (e.g. a job title under the name).
  static const Color mutedColor = Color(0xFF6B7280);

  static const double bodyFontSize = 27;
  static const double bodyMinFontSize = 18;

  static const double validityFontSize = 17;
  static const double validityMinFontSize = 13;

  /// "Valid From / To" caption + its date value.
  static const double validityLabelFontSize = 18;

  /// Terms bullets and contact rows on the back.
  static const double termsFontSize = 19;
  static const double termsMinFontSize = 13;

  /// Back-of-card section heading, e.g. "Terms And Conditions :".
  static const double sectionHeadingFontSize = 22;

  /// Small pill / badge text (session, category).
  static const double badgeFontSize = 14;

  static const double addressFontSize = 20;
  static const double addressMinFontSize = 15;

  static const double backHeaderFontSize = 38.0;
  static const double backBodyFontSize = 27;
  static const double backBodyMinFontSize = 18;

  static const double frontGapMin = 15;
  static const double frontGapMax = 25;
  static const double frontGapSpread = 0.96;
  static const double frontGapRelaxedMin = 22;
  static const double frontGapRelaxedMax = 34;
  static const double frontGapRelaxedSpread = 1.05;

  static const double backGapMin = 14;
  static const double backGapMax = 24;
  static const double backGapSpread = 0.96;
}

