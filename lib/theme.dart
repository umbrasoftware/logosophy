import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The "Aurora" visual identity: deep indigo (the night of the unexamined
/// mind) warmed by an amber sun — the dawn of consciousness.
abstract final class AuroraTheme {
  // Light palette.
  static const Color indigo = Color(0xFF3A4776);
  static const Color indigoContainer = Color(0xFFE4E8F6);
  static const Color amber = Color(0xFFD98E32);
  static const Color amberContainer = Color(0xFFF6E3C8);

  // Dark palette.
  static const Color indigoDark = Color(0xFF9FACE4);
  static const Color indigoContainerDark = Color(0xFF2E3757);
  static const Color amberDark = Color(0xFFE8A94E);
  static const Color amberContainerDark = Color(0xFF5A4118);

  static const FlexSchemeColor _lightScheme = FlexSchemeColor(
    primary: indigo,
    primaryContainer: indigoContainer,
    secondary: amber,
    secondaryContainer: amberContainer,
    tertiary: Color(0xFF8790B4),
    tertiaryContainer: Color(0xFFDEE4F5),
  );

  static const FlexSchemeColor _darkScheme = FlexSchemeColor(
    primary: indigoDark,
    primaryContainer: indigoContainerDark,
    secondary: amberDark,
    secondaryContainer: amberContainerDark,
    tertiary: Color(0xFF6E77A0),
    tertiaryContainer: Color(0xFF232A45),
  );

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    defaultRadius: 16,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: 28,
    navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
    navigationBarSelectedIconSchemeColor: SchemeColor.primary,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
  );

  static ThemeData get light => FlexThemeData.light(
    colors: _lightScheme,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 4,
    subThemesData: _subThemes,
    fontFamily: GoogleFonts.albertSans().fontFamily,
  );

  static ThemeData get dark => FlexThemeData.dark(
    colors: _darkScheme,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 12,
    subThemesData: _subThemes,
    fontFamily: GoogleFonts.albertSans().fontFamily,
  );

  /// Serif italic style for passages quoted from the books.
  static TextStyle passage({required double fontSize, required Color color}) {
    return GoogleFonts.lora(fontStyle: FontStyle.italic, fontSize: fontSize, height: 1.5, color: color);
  }
}
