import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData _IYMYTheme = _buildIYMYTheme();

ThemeData _buildIYMYTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
//    accentColor: kShrineBrown900,
//    primaryColor: kShrinePink100,
//    buttonColor: kShrinePink100,
//    scaffoldBackgroundColor: kShrineBackgroundWhite,
//    cardColor: kShrineBackgroundWhite,
//    textSelectionColor: kShrinePink100,
//    errorColor: kShrineErrorRed,
//    buttonTheme: base.buttonTheme.copyWith(
//      buttonColor: kShrinePink100,
//      colorScheme: base.colorScheme.copyWith(
//        secondary: kShrineBrown900,
//      ),
//    ),
//    buttonBarTheme: base.buttonBarTheme.copyWith(
//      buttonTextTheme: ButtonTextTheme.accent,
//    ),
//    primaryIconTheme: base.iconTheme.copyWith(
//        color: kShrineBrown900
//    ),
//    inputDecorationTheme: InputDecorationTheme(
//      focusedBorder: CutCornersBorder(
//        borderSide: BorderSide(
//          width: 2.0,
//          color: kShrineBrown900,
//        ),
//      ),
//      border: CutCornersBorder(),
//    ),
    textTheme: _buildTextTheme(base.textTheme),
//    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
//    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: TextStyle(fontSize: 28,  fontWeight: FontWeight.w500),
    headline2: TextStyle(fontSize: 24,  fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),
    headline4: TextStyle(fontSize: 20,  fontWeight: FontWeight.normal),
    headline5: TextStyle(fontSize: 16,  fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 16,  fontWeight: FontWeight.w500),

    subtitle1: TextStyle(fontSize: 14,  fontWeight: FontWeight.bold),
    subtitle2: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),

    body1: TextStyle(fontSize: 16,  fontWeight: FontWeight.normal),
    body2: TextStyle(fontSize: 14,  fontWeight: FontWeight.normal),
  ).apply(
    fontFamily: 'NotoSansKR',
    displayColor: black87,
//    bodyColor: kShrineBrown900,
  );
}