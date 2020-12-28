import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bottom_bar.dart';
import 'camera/camera.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'ranking/ranking.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(IYMYApp());
}

class IYMYApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IYMY',
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/login',
        routes: {
          // TODO
          // Add route
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/camera': (context) => CameraPage(),
          '/ranking': (context) => RankingPage(),
          '/bottom_bar': (context) => BottomBar(),
        },
        theme: ThemeData(
            // TODO
            // Add Theme Data
            ));
  }
}
