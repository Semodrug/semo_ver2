import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import 'package:semo_ver2/home/home_add_button_stack.dart';
//import 'package:semo_ver2/ranking/past_dart_file/test_ranking.dart';

import 'camera/camera.dart';
import 'home/home.dart';
import 'mypage/my_page.dart';
import 'ranking/ranking.dart';
import 'drug_info/phil_info.dart';
import 'review/drug_info.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    // AddButton(),
    CameraPage(),
    RankingPage(),
//    PhilInfoPage(
//      drugItemSeq: '199303108',
//    )
//     ReviewPage("199303108")
//    ReviewPage(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index != 1) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      if (await checkIfPermissionGranted()) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CameraPage()),
        );
      } else {
        print('권한을 허용해주세요');
        AppSettings.openAppSettings();
        // Navigator.of(context).pop();
      }
    }
  }

  Future<bool> checkIfPermissionGranted() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();

    bool permitted = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) permitted = false;
    });

    return permitted;
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt), label: 'camera'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '카테고리'),
            // BottomNavigationBarItem(icon: Icon(Icons.create), label: 'review'),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Theme.of(context).bottomAppBarColor,
          onTap: _onItemTapped),
    );
  }
}
