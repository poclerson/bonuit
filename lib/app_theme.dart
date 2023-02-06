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

class AppTheme {
  static ThemeData light = ThemeData(brightness: Brightness.light);
  static ThemeData dark = ThemeData(

      /// THEME ///
      colorScheme: DarkColorScheme,
      scaffoldBackgroundColor: DarkColorScheme.background,
      dividerColor: DarkColorScheme.secondary,

      /// DIALOGUE ///
      dialogTheme: DialogTheme(
          backgroundColor: DarkColorScheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 2, color: DarkColorScheme.onBackground))),

      /// NAVIGATION ///
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: DarkColorScheme.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.w900)),
      bottomAppBarTheme: BottomAppBarTheme(color: DarkColorScheme.background),

      /// BOUTONS ///
      // Text button
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStatePropertyAll<Color>(DarkColorScheme.primary),
              backgroundColor:
                  MaterialStatePropertyAll<Color>(DarkColorScheme.onPrimary),
              shape: MaterialStatePropertyAll<OutlinedBorder>(
                  BeveledRectangleBorder()))),
      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(DarkColorScheme.secondary),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(DarkColorScheme.onSecondary),
              side: MaterialStatePropertyAll<BorderSide>(
                  BorderSide(color: DarkColorScheme.onBackground)),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))))),

      /// TEXTES ///
      textTheme: TextTheme(

          /// DISPLAY
          displayLarge: GoogleFonts.karla(
              letterSpacing: -5,
              fontWeight: FontWeight.w900,
              fontSize: 100,
              color: DarkColorScheme.onBackground),
          displaySmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w900,
              fontSize: 80,
              color: DarkColorScheme.onBackground),

          /// LABEL
          labelLarge: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: DarkColorScheme.background),

          /// TITLE
          titleMedium: GoogleFonts.karla(fontWeight: FontWeight.w900, color: DarkColorScheme.background, fontSize: 25),
          // BODY
          bodyMedium: GoogleFonts.familjenGrotesk(fontWeight: FontWeight.w300, color: DarkColorScheme.background)));
}
