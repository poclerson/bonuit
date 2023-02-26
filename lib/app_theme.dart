import 'package:bonuit/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'models/simple_stream.dart';

const DarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFCA1B),
  onPrimary: Colors.black,
  secondary: Color(0xFFE4E4E4),
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.black,
  background: Color(0xFF131313),
  onBackground: Color(0xFFB6B6B6),
  onSurface: Color(0xFFC7C7C7),
  surface: Color(0xFF000000),
);

const LightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFF52F21),
    onPrimary: Color(0xFF222222),
    secondary: Color(0xFF202020),
    onSecondary: Colors.white,
    error: Color(0xFFFF004C),
    onError: Colors.white,
    onSurface: Color(0xFF313131),
    surface: Color(0xFFD8D8D8),
    background: Color(0xFFE0E0E0),
    onBackground: Color(0xFF313131));

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

        /// TEXTES ///
        textTheme: TextTheme(
          /// DISPLAY
          displayLarge: GoogleFonts.karla(
              letterSpacing: -5,
              height: .7,
              fontWeight: FontWeight.w900,
              fontSize: 120,
              color: colorScheme.secondary),
          displayMedium: GoogleFonts.familjenGrotesk(
              letterSpacing: -2,
              fontWeight: FontWeight.w900,
              fontSize: 80,
              color: colorScheme.secondary),
          displaySmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w900,
              fontSize: 60,
              color: colorScheme.secondary),

          /// HEADLINE
          headlineLarge: GoogleFonts.karla(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              color: colorScheme.secondary),
          headlineMedium: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: colorScheme.onBackground),
          headlineSmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: colorScheme.onBackground),

          /// TITLE
          titleLarge: GoogleFonts.karla(
              fontWeight: FontWeight.w700,
              color: colorScheme.secondary,
              fontSize: 28),
          titleMedium: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w500,
              color: colorScheme.onBackground,
              fontSize: 24),
          titleSmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w500,
              color: colorScheme.onBackground,
              fontSize: 22),

          /// LABEL
          labelLarge: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: colorScheme.secondary),
          labelMedium: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: colorScheme.onBackground),
          labelSmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: colorScheme.onBackground),

          // BODY
          bodyLarge: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w500,
              color: colorScheme.secondary,
              fontSize: 16),
          bodyMedium: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w300,
              color: colorScheme.onBackground,
              fontSize: 14),
          bodySmall: GoogleFonts.familjenGrotesk(
              fontWeight: FontWeight.w300,
              color: colorScheme.onBackground,
              fontSize: 12),
        ),

        /// BOUTONS ///
        // Elevated button
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.primary),
                foregroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.background),
                fixedSize: MaterialStatePropertyAll<Size>(Size(75, 65)),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                maximumSize: MaterialStatePropertyAll<Size>(Size(100, 100)))),

        // Toggle button
        toggleButtonsTheme: ToggleButtonsThemeData(
            borderWidth: 2,
            color: colorScheme.primary,
            selectedColor: colorScheme.onPrimary,
            fillColor: colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(15))),

        /// Outlined button
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.secondary),
                foregroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.onSecondary),
                side: MaterialStatePropertyAll<BorderSide>(
                    BorderSide(color: colorScheme.onBackground)),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))))),

        // Text button
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                maximumSize: MaterialStatePropertyAll<Size>(Size(600, 500)),
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                foregroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.onSurface),
                backgroundColor:
                    MaterialStatePropertyAll<Color>(colorScheme.surface),
                overlayColor:
                    MaterialStatePropertyAll<Color>(colorScheme.surface),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))))),
      );

  static SimpleStream<ThemeMode> themeMode = SimpleStream();
}
