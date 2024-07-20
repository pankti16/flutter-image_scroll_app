import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  //Light theme
  static ThemeData lightThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        error: Color(0xffba1a1a),
        errorContainer: Color(0xffffdad6),
        inversePrimary: Color(0xff82d5c8),
        inverseSurface: Color(0xff2b3230),
        onError: Color(0xffffffff),
        onErrorContainer: Color(0xff410002),
        onInverseSurface: Color(0xffecf2ef),
        onPrimary: Color(0xffffffff),
        onPrimaryContainer: Color(0xff00201c),
        onSecondary: Color(0xffffffff),
        onSecondaryContainer: Color(0xff05201c),
        onSurface: Color(0xff161d1c),
        onSurfaceVariant: Color(0xff3f4947),
        onTertiary: Color(0xffffffff),
        onTertiaryContainer: Color(0xff001e31),
        outline: Color(0xff6f7977),
        outlineVariant: Color(0xffbec9c6),
        primary: Color(0xff006a60),
        primaryContainer: Color(0xff9ef2e4),
        scrim: Color(0xff000000),
        secondary: Color(0xff4a635f),
        secondaryContainer: Color(0xffcce8e2),
        shadow: Color(0xff000000),
        surface: Color(0xfff4fbf8),
        surfaceContainerHighest: Color(0xffdde4e1),
        surfaceTint: Color(0xff006a60),
        tertiary: Color(0xff456179),
        tertiaryContainer: Color(0xffcce5ff),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xfff4fbf8),
        foregroundColor: Color(0xff161d1c),
      ),
      hoverColor: const Color(0x0a000000),
      textTheme : GoogleFonts.robotoTextTheme(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xff82d5c8),
      ),
    );
  }

  //Dark theme
  static ThemeData darkThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        error: Color(0xffffb4ab),
        errorContainer: Color(0xff93000a),
        inversePrimary: Color(0xff006a60),
        inverseSurface: Color(0xffdde4e1),
        onError: Color(0xff690005),
        onErrorContainer: Color(0xffffdad6),
        onInverseSurface: Color(0xff2b3230),
        onPrimary: Color(0xff003731),
        onPrimaryContainer: Color(0xff9ef2e4),
        onSecondary: Color(0xff1c3531),
        onSecondaryContainer: Color(0xffcce8e2),
        onSurface: Color(0xffdde4e1),
        onSurfaceVariant: Color(0xffbec9c6),
        onTertiary: Color(0xff153349),
        onTertiaryContainer: Color(0xffcce5ff),
        outline: Color(0xff899390),
        outlineVariant: Color(0xff3f4947),
        primary: Color(0xff82d5c8),
        primaryContainer: Color(0xff005048),
        scrim: Color(0xff000000),
        secondary: Color(0xffb1ccc6),
        secondaryContainer: Color(0xff334b47),
        shadow: Color(0xff000000),
        surface: Color(0xff0e1513),
        surfaceContainerHighest: Color(0xff303635),
        surfaceTint: Color(0xff82d5c8),
        tertiary: Color(0xffadcae6),
        tertiaryContainer: Color(0xff2d4961),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xff0e1513),
        foregroundColor: Color(0xffdde4e1),
      ),
      hoverColor: const Color(0x0a000000),
      textTheme : GoogleFonts.robotoTextTheme(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xff006a60),
      ),
    );
  }
}

//Our own theme enum fo ease in saving to and getting from shared_preferences
enum ThemePreference {
  light,
  dark,
  system,
}

//Key to save active theme in shared_preferences
const String themeKey = 'theme_key';
