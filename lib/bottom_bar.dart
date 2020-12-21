import 'package:flutter/material.dart';

import 'camera/camera.dart';
import 'home/home.dart';
import 'ranking/ranking.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    CameraPage(),
    RankingPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
//        title: Text("Face U", style: Theme.of(context).textTheme.headline1),

      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'camera'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'ranking'
            ),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Theme.of(context).bottomAppBarColor,
          onTap: _onItemTapped
      ),
    );
  }
}