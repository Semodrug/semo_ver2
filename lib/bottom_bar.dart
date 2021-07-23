import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/camera/camera_page.dart';
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
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return _popUpAddDrug(context);
                });
          },
        ),
      ),
    );
  }

  Widget _popUpAddDrug(context) {
    return Container(
      //color: yellow,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          )),
      child: Wrap(
        children: <Widget>[
          Container(
            height: 45,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    child: Text(
                      '약 추가하기',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: primary500_light_text),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () async {
                // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
                final cameras = await availableCameras();

                // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
                final firstCamera = cameras.first;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      camera: firstCamera,
                      initial: 0,
                    ),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/barcode_icon_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "바코드 인식",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () async {
                // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
                final cameras = await availableCameras();

                // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
                final firstCamera = cameras.first;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      camera: firstCamera,
                      initial: 1,
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/case_icon_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "케이스 인식",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Container(

                    height: 20,
                    width: 55,
                    child: Center(child: Text("Beta",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: primary600_bold_text,
                        fontSize: 13)),),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: gray50,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/search_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "약 이름 검색",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: gray100),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                    child: Text("닫기",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray300_inactivated)))),
          )
        ],
      ),
    );
  }
}
