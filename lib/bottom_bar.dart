import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/camera/camera.dart';
import 'package:semo_ver2/home/home.dart';
import 'package:semo_ver2/ranking/ranking.dart';
import 'package:semo_ver2/shared/appbar.dart';
import 'package:semo_ver2/theme/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 2 ? IYMYAppBar('home') : IYMYAppBar('카테고리'),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/bottom_home.png'),
                ),
                iconSize: 36,
                color: _selectedIndex == 0
                    ? gray750_activated
                    : gray300_inactivated,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                }),
            SizedBox(width: 70, height: 36),
            IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/bottom_category.png'),
                ),
                iconSize: 36,
                color: _selectedIndex == 2
                    ? gray750_activated
                    : gray300_inactivated,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          backgroundColor: primary400_line,
          elevation: 0,
          child: Image.asset('assets/icons/bottom_camera.png'),
          onPressed: () async {
            // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
            final cameras = await availableCameras();

            // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
            final firstCamera = cameras.first;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraPage(
                  camera: firstCamera,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
