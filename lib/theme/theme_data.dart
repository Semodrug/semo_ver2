import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData _IYMYTheme = _buildIYMYTheme();

ThemeData _buildIYMYTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
//    accentColor: kShrineBrown900,
    primaryColor: primary300_main,
    buttonColor: primary300_main,
//    scaffoldBackgroundColor: kShrineBackgroundWhite,
//    cardColor: kShrineBackgroundWhite,
    textSelectionColor: primary500_light_text,
    errorColor: warning,
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
//          color: primary700,
//        ),
//      ),
//      border: CutCornersBorder(),
//    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme), //이건 필요한가?
    accentTextTheme: _buildTextTheme(base.accentTextTheme), //필요할ㄲㅏ?
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[900]),
        headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[600]),
        headline4: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey[800],),
        headline5: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
        headline6: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[400]),

        subtitle1: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[750]),
        subtitle2: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[900]),

        bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[500]),
      )
      .apply(
        fontFamily: 'NotoSansKR',
        displayColor: black87,

//    bodyColor: kShrineBrown900,
      );
}
