import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/services/auth.dart';

import 'bottom_bar.dart';
import 'camera/camera.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'ranking/ranking.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/wrapper.dart';

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
          },
          theme: ThemeData(
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
          )),
    );
  }
}
