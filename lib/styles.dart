import 'package:flutter/material.dart';

const String DefaultFont = 'Roboto';

const DisplayTextSize = 96.0;
const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const AppBarTextStyle = TextStyle(
    fontFamily: DefaultFont,
    fontWeight: FontWeight.w600,
    fontSize: LargeTextSize,
    color: Colors.white);

const DisplayTextStyle = TextStyle(
    fontFamily: DefaultFont,
    fontWeight: FontWeight.w900,
    fontSize: DisplayTextSize,
    color: Colors.black);

const TitleTextStyle = TextStyle(
    fontFamily: DefaultFont,
    fontWeight: FontWeight.w600,
    fontSize: LargeTextSize,
    color: Colors.black);

const BodyTextStyle = TextStyle(
    fontFamily: DefaultFont,
    fontWeight: FontWeight.w300,
    fontSize: BodyTextSize,
    color: Colors.black);

const ButtonTextStyle = ButtonStyle(
    foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
    backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
    minimumSize: MaterialStatePropertyAll<Size>(Size(40.0, 100.0)),
    maximumSize: MaterialStatePropertyAll<Size>(Size(40.0, 100.0)),
    shape: MaterialStatePropertyAll<OutlinedBorder>(BeveledRectangleBorder()));

ThemeData appThemeData = ThemeData(
    appBarTheme: AppBarTheme(toolbarTextStyle: AppBarTextStyle),
    primaryColor: Colors.white,
    buttonTheme: ButtonThemeData(buttonColor: Colors.black),
    textTheme: TextTheme(
        titleMedium: TitleTextStyle,
        bodyMedium: BodyTextStyle,
        displayMedium: DisplayTextStyle));
