import 'package:flutter/material.dart';

import 'colors.dart';

//final ThemeData _kShrineTheme = _buildShrineTheme();

//ThemeData _buildShrineTheme() {
//  final ThemeData base = ThemeData.light();
//  return base.copyWith(
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
//    textTheme: _buildShrineTextTheme(base.textTheme),
//    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
//    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
//  );
//}
//
//TextTheme _buildShrineTextTheme(TextTheme base) {
//  return base.copyWith(
//    headline5: base.headline5.copyWith(
//      fontWeight: FontWeight.w500,
//    ),
//    headline6: base.headline6.copyWith(
//        fontSize: 18.0
//    ),
//    caption: base.caption.copyWith(
//      fontWeight: FontWeight.w400,
//      fontSize: 14.0,
//    ),
//    bodyText1: base.bodyText1.copyWith(
//      fontWeight: FontWeight.w500,
//      fontSize: 16.0,
//    ),
//  ).apply(
//    fontFamily: 'Rubik',
//    displayColor: kShrineBrown900,
//    bodyColor: kShrineBrown900,
//  );
//}