import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

import 'package:semo_ver2/home/home_add_button_stack.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'camera/camera.dart';
import 'home/home.dart';
import 'mypage/my_page.dart';
import 'ranking/ranking.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    Container(),
    RankingPage(),
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
          backgroundColor: gray0_white,
          selectedItemColor: gray750_activated,
          unselectedItemColor: gray300_inactivated,
          iconSize: 40,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/bottom_home.png'),
                // color: Color(0xFF3A5A98),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/bottom_camera.png'),
                  // color: primary400_line,
                ),
                label: '카메라'),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/bottom_category.png'),
                  // color: Color(0xFF3A5A98),
                ),
                label: '카테고리'),
          ],
          onTap: _onItemTapped),
    );
  }
}
