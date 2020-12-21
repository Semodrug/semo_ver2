import 'package:flutter/material.dart';
import 'camera/camera.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'manage_page.dart';
import 'ranking/ranking.dart';


class IYMYApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IYMY',
      home: HomePage(),
      initialRoute: '/manage',
      routes : {
        // TODO
        // Add route
        '/manage': (context) => ManagePage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/camera': (context) => CameraPage(),
        '/ranking': (context) => RankingPage(),
      },
      theme: ThemeData(
        // TODO
        // Add Theme Data
      )
    );
  }
}