import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'models/simple_stream.dart';

const DarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFCA1B),
  onPrimary: Colors.black,
  secondary: Color(0xFFBFBFBF),
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.black,
  background: Color(0xFF131313),
  onBackground: Color(0xFFC7C7C7),
  onSurface: Color(0xFFC7C7C7),
  surface: Color(0xFF050505),
);

const LightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFF52F21),
    onPrimary: Color(0xFF222222),
    secondary: Color(0xFF525252),
    onSecondary: Colors.white,
    error: Color(0xFFFF004C),
    onError: Colors.white,
    onSurface: Color(0xFF0F0F0F),
    surface: Color(0xFFD8D8D8),
    background: Color(0xFFE0E0E0),
    onBackground: Color(0xFF2B2B2B));

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
                  MaterialStatePropertyAll<Color>(colorScheme.onSurface),
              backgroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.surface),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))))),
      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.secondary),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(colorScheme.onSecondary),
              side:
                  MaterialStatePropertyAll<BorderSide>(BorderSide(color: colorScheme.onBackground)),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(colorScheme.primary), foregroundColor: MaterialStatePropertyAll<Color>(colorScheme.background), fixedSize: MaterialStatePropertyAll<Size>(Size(50, 50)), shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),

      /// TEXTES ///
      textTheme: TextTheme(
        /// DISPLAY
        displayLarge: GoogleFonts.karla(
            letterSpacing: -5,
            fontWeight: FontWeight.w900,
            fontSize: 100,
            color: colorScheme.onBackground),
        displayMedium: GoogleFonts.familjenGrotesk(
            letterSpacing: -2,
            fontWeight: FontWeight.w900,
            fontSize: 80,
            color: colorScheme.onBackground),
        displaySmall: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w900,
            fontSize: 60,
            color: colorScheme.onBackground),

        /// LABEL
        labelLarge: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: colorScheme.onBackground),
        labelMedium: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: colorScheme.background),
        labelSmall: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: colorScheme.background),

        /// TITLE
        titleMedium: GoogleFonts.karla(
            fontWeight: FontWeight.w900,
            color: colorScheme.background,
            fontSize: 25),

        /// HEADLINE
        headlineLarge: GoogleFonts.karla(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: colorScheme.onBackground),

        // BODY
        bodyMedium: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w300, color: colorScheme.onBackground),
        bodyLarge: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w300, color: colorScheme.onBackground),
        bodySmall: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.w300, color: colorScheme.onBackground),
      ));

  static SimpleStream<ThemeMode> themeMode = SimpleStream();
}
