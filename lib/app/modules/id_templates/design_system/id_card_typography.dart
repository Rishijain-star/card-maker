import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../create_flow/controllers/create_flow_controller.dart';

/// Applies the selected card font to any [TextStyle] (all template text uses this).
abstract final class IdCardTypography {
  /// Stylish fonts curated for ID cards, lanyards & badges.
  static const List<String> fontOptions = <String>[
    'Merienda',
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
    'Times New Roman',
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
    final applier = _appliers[fontFamily];
    if (applier != null) {
      return applier(textStyle: style);
    }
    return GoogleFonts.poppins(textStyle: style);
  }

  /// Default font for Student Name, Father Name, Course/Subject is Lobster when no custom font is selected.
  static TextStyle applyPrimary(TextStyle base, String fontFamily, {double? scale}) {
    final effectiveFont = (fontFamily.isEmpty || fontFamily == 'Poppins') ? 'Lobster' : fontFamily;
    return apply(base, effectiveFont, scale: scale);
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
