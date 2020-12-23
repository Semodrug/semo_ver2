import 'package:flutter/material.dart';

import 'camera/camera.dart';
import 'home/home.dart';
import 'ranking/ranking.dart';
import 'review/phil_info.dart';
import 'review/review_page.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    CameraPage(),
    RankingPage(),
    PhilInfoPage()
//    ReviewPage(),
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
          type : BottomNavigationBarType.fixed,
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
            BottomNavigationBarItem(
                icon: Icon(Icons.create),
                label: 'review'
            ),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Theme.of(context).bottomAppBarColor,
          onTap: _onItemTapped
      ),
    );
  }
}