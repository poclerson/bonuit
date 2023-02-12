import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const DarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFCA1B),
  onPrimary: Colors.black,
  secondary: Color(0xFFBFBFBF),
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.black,
  background: Color(0xFF131313),
  onBackground: Color(0xFFE6E6E6),
  surface: Color(0xFF5E5E5E),
  onSurface: Colors.white,
);

const LightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFF52F21),
    onPrimary: Color(0xFF222222),
    secondary: Color(0xFF525252),
    onSecondary: Colors.white,
    error: Color(0xFFFF004C),
    onError: Colors.white,
    surface: Color(0xFFA7A7A7),
    onSurface: Colors.black,
    background: Color(0xFFE0E0E0),
    onBackground: Color(0xFF202020));

class AppTheme {
  static ThemeData themeBuilder(ColorScheme colorScheme) => ThemeData(

      /// THEME ///
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      dividerColor: colorScheme.secondary,

      /// DIALOGUE ///
      dialogTheme: DialogTheme(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 2, color: colorScheme.onBackground))),

      /// NAVIGATION ///
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.w900)),
      bottomAppBarTheme: BottomAppBarTheme(color: colorScheme.background),

      /// BOUTONS ///
      // Text button
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.primary),
              backgroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.onPrimary),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))))),
      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.secondary),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.onSecondary),
              side: MaterialStatePropertyAll<BorderSide>(
                  BorderSide(color: colorScheme.onBackground)),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),

      /// TEXTES ///
      textTheme: TextTheme(

          /// DISPLAY
          displayLarge: GoogleFonts.karla(letterSpacing: -5, fontWeight: FontWeight.w900, fontSize: 100, color: colorScheme.onBackground),
          displayMedium: GoogleFonts.familjenGrotesk(letterSpacing: -2, fontWeight: FontWeight.w900, fontSize: 80, color: colorScheme.onBackground),
          displaySmall: GoogleFonts.familjenGrotesk(fontWeight: FontWeight.w900, fontSize: 60, color: colorScheme.onBackground),

          /// LABEL
          labelLarge: GoogleFonts.familjenGrotesk(fontWeight: FontWeight.w500, fontSize: 20, color: colorScheme.background),

          /// TITLE
          headlineLarge: GoogleFonts.karla(fontWeight: FontWeight.w700, fontSize: 30, color: colorScheme.onBackground),
          titleMedium: GoogleFonts.karla(fontWeight: FontWeight.w900, color: colorScheme.background, fontSize: 25),
          // BODY
          bodyMedium: GoogleFonts.familjenGrotesk(fontWeight: FontWeight.w300, color: colorScheme.background)));

  static ThemeData light = themeBuilder(LightColorScheme);
  static ThemeData dark = themeBuilder(DarkColorScheme);
}
