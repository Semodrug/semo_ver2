import 'package:flutter/material.dart';
import 'package:semo_ver2/home/home_add_button_stack.dart';
//import 'package:semo_ver2/ranking/past_dart_file/test_ranking.dart';

import 'camera/camera.dart';
import 'home/home.dart';
import 'mypage/my_page.dart';
import 'ranking/ranking.dart';
import 'drug_info/phil_info.dart';
import 'review/review_page.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    AddButton(),
    RankingPage(),
//    PhilInfoPage(
//      drugItemSeq: '199303108',
//    )
//     ReviewPage("199303108")
//    ReviewPage(),
  ];

  void _onItemTapped(int index) {
    if(index != 1 ){
      setState(() {
        _selectedIndex = index;
      });
    }
    else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddButton()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          '이약모약',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.teal[200],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              ),
            ),
          ),
          //for test home
        ],

        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color(0xFFE9FFFB),
                Color(0xFFE9FFFB),
                Color(0xFFFFFFFF),
              ])),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
//        floatingActionButton: FloatingActionButton(
//          backgroundColor: Colors.teal[200],
//          child: Icon(Icons.camera_alt),
//          onPressed: (){
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => CameraPage()));
//          },
//        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt), label: 'camera'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'ranking'),
            // BottomNavigationBarItem(icon: Icon(Icons.create), label: 'review'),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Theme.of(context).bottomAppBarColor,
          onTap: _onItemTapped),
    );
  }
}
