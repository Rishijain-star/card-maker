import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../create_flow/controllers/create_flow_controller.dart';

/// Applies the selected card font to any [TextStyle] (all template text uses this).
abstract final class IdCardTypography {
  /// Global default font family across all ID card templates.
  static const String defaultFontFamily = 'Merienda';

  /// Stylish fonts curated for ID cards, lanyards & badges.
  static const List<String> fontOptions = <String>[
    'Merienda',
    'Times New Roman',
    'Lobster',
    'Poppins',
    'Montserrat',
    'Rubik',
    'Raleway',
    'Oswald',
    'Bebas Neue',
    'Anton',
    'Cinzel',
    'Playfair Display',
    'Abril Fatface',
    'Righteous',
    'Teko',
    'Alfa Slab One',
    'Great Vibes',
    'Dancing Script',
    'Sacramento',
    'Orbitron',
    'Arial Black',
    'Berlin Sans',
    'Cooper Black',
    'Elephant',
    'Forte',
    'Jokerman',
    'Lucida Calligraphy',
  ];

  static TextStyle apply(TextStyle base, String fontFamily, {double? scale}) {
    double activeScale = scale ?? 1.0;
    if (scale == null && Get.isRegistered<CreateFlowController>()) {
      activeScale = Get.find<CreateFlowController>().fontSizeScale.value;
    }
    var style = base;
    if (activeScale != 1.0 && style.fontSize != null) {
      final newSize = (style.fontSize! * activeScale).clamp(6.0, 120.0);
      style = style.copyWith(fontSize: newSize);
    }

    // NOTE: colour is deliberately NOT handled here. The user's Header/Text
    // colour pickers are applied per-role in IdCardTextStyles, which knows
    // whether a style is a header or body text. Doing it here would also
    // recolour things that merely share a colour value — the font-picker
    // preview chips and the lanyard templates both call this method.
    final fontToUse = (fontFamily.isEmpty || fontFamily == 'Poppins')
        ? defaultFontFamily
        : fontFamily;

    TextStyle result;
    final applier = _appliers[fontToUse];
    if (applier != null) {
      result = applier(textStyle: style);
    } else {
      result = GoogleFonts.tinos(textStyle: style);
    }

    if (style.fontWeight != null && result.fontWeight != style.fontWeight) {
      result = result.copyWith(fontWeight: style.fontWeight);
    }
    if (style.shadows != null && result.shadows != style.shadows) {
      result = result.copyWith(shadows: style.shadows);
    }
    return result;
  }

  /// Formats institute name for consistent multi-line wrapping across all ID card templates.
  /// Rule: Maximize words on top line (Line 1), minimize words on bottom line (Line 2).
  /// 4 words: 3 top + 1 bottom (e.g. "MIDDLE SCHOOL SUDIYARI\nPRATAPGANJ")
  /// 5 words: 3 top + 2 bottom (e.g. "SRI CHAITANYA TECHNO\nSCHOOL INDORE")
  static String formatInstituteName(String raw) {
    return raw.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Dynamic font applier for primary fields (uses defaultFontFamily by default).
  static TextStyle applyPrimary(TextStyle base, String fontFamily, {double? scale}) {
    return apply(base, fontFamily, scale: scale);
  }

  static final Map<String, TextStyle Function({TextStyle? textStyle})> _appliers =
      <String, TextStyle Function({TextStyle? textStyle})>{
        'Merienda': GoogleFonts.merienda,
        'Lobster': GoogleFonts.lobster,
        'Bebas Neue': GoogleFonts.bebasNeue,
        'Oswald': GoogleFonts.oswald,
        'Anton': GoogleFonts.anton,
        'Cinzel': GoogleFonts.cinzel,
        'Playfair Display': GoogleFonts.playfairDisplay,
        'Abril Fatface': GoogleFonts.abrilFatface,
        'Righteous': GoogleFonts.righteous,
        'Teko': GoogleFonts.teko,
        'Alfa Slab One': GoogleFonts.alfaSlabOne,
        'Great Vibes': GoogleFonts.greatVibes,
        'Dancing Script': GoogleFonts.dancingScript,
        'Sacramento': GoogleFonts.sacramento,
        'Orbitron': GoogleFonts.orbitron,
        'Montserrat': GoogleFonts.montserrat,
        'Raleway': GoogleFonts.raleway,
        'Rubik': GoogleFonts.rubik,
        'Poppins': GoogleFonts.poppins,
        'Times New Roman': GoogleFonts.tinos,
        'Arial Black': GoogleFonts.archivoBlack,
        'Berlin Sans': GoogleFonts.changa,
        'Cooper Black': GoogleFonts.patuaOne,
        'Elephant': GoogleFonts.cormorantGaramond,
        'Forte': GoogleFonts.caveat,
        'Jokerman': GoogleFonts.creepster,
        'Lucida Calligraphy': GoogleFonts.alexBrush,
      };
}
