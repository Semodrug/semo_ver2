import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'bottom_bar.dart';
import 'camera/camera.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'ranking/ranking.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/wrapper.dart';
import 'package:semo_ver2/theme/theme_data.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser>(
      create: (_) => AuthService().user,
      child: MaterialApp(
          title: '이약모약 ver2',
          home: Wrapper(),
          debugShowCheckedModeBanner: false,
          routes: {
            // TODO: Add route
            '/start': (context) => Wrapper(),
            '/login': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/camera': (context) => CameraPage(),
            '/ranking': (context) => RankingPage(),
            '/bottom_bar': (context) => BottomBar(),
            '/search': (context) => SearchScreen(),

          },
          theme: _IYMYTheme
          /*
          ThemeData(
              // TODO: Add Theme Data
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline2: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline3: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline4: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline5: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              headline6: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),

              bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),

              subtitle1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              subtitle2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),

              caption: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              button: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              overline: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//              TextStyle? caption,
//              TextStyle? button,
//              TextStyle? overline,
            ),
          )
          */
      ),
    );
  }
}

//여기부터 그냥 넣어둔거!

final ThemeData _IYMYTheme = _buildIYMYTheme();

ThemeData _buildIYMYTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
//    accentColor: kShrineBrown900,
    primaryColor: primary300_main,
    buttonColor: primary300_main,
//    scaffoldBackgroundColor: kShrineBackgroundWhite,
//    cardColor: kShrineBackgroundWhite,
    textSelectionColor: primary500_light_text,
    errorColor: warning,

    textTheme: _buildTextTheme(base.textTheme),
    //primaryTextTheme: _buildTextTheme(base.primaryTextTheme), //이건 필요한가?
    //accentTextTheme: _buildTextTheme(base.accentTextTheme), //필요할ㄲㅏ?
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline1: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF0D0D0D)),
    headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF666666)),
    headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xFF666666)),
    headline4: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
    headline5: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1F1F1F)), //0D0D0D
    headline6: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F1F1F)),

    subtitle1: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F1F1F)),
    subtitle2: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[900]),

    bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF666666)),

    // headline1: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
    // headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    // headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    // headline4: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    // headline5: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    // headline6: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    //
    // subtitle1: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    // subtitle2: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    //
    // bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    // bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  )
      .apply(
    fontFamily: 'NotoSansKR',
    displayColor: black87,


//    bodyColor: kShrineBrown900,
  );
}
