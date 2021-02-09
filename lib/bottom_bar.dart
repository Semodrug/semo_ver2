import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:semo_ver2/camera/no_result.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/appbar.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:semo_ver2/camera/camera.dart';
import 'package:semo_ver2/home/home.dart';
import 'package:semo_ver2/ranking/ranking.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  bool isHome = true;

  File file;
  String barcodeNum;
  bool imageLoaded = false;
  final _picker = ImagePicker();

  Future<void> pickImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      file = File(pickedFile.path);
      imageLoaded = true;
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(file);

    final BarcodeDetector barcodeDetector =
        FirebaseVision.instance.barcodeDetector();

    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(visionImage);

    for (Barcode barcode in barcodes) {
      final String rawValue = barcode.rawValue;
      final BarcodeValueType valueType = barcode.valueType;

      setState(() {
        barcodeNum = "$rawValue";
      });
    }

    barcodeDetector.close();
  }

  final List<Widget> _widgetOptions = [
    HomePage(),
    Container(),
    RankingPage(),
  ];

  Future<void> _onItemTapped(int index) async {
    //app bar 다르게 하기 위함//
    if (index != 0) {
      isHome = false;
    } else
      isHome = true;
    ///////////////////////

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
      appBar: isHome
          ? IYMYAppBar('home')
          : IYMYAppBar('카테고리'), //CustomAppBarWithArrowBack('customTitle'),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
                // color: gray100,
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/bottom_camera.png'),
                  color: gray0_white,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Image.asset('assets/icons/bottom_camera.png'),
        onPressed: () async {
          await pickImage();

          var data = await DatabaseService().itemSeqFromBarcode(barcodeNum);

          (barcodeNum != null && data != null)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(data),
                  ))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoResult(),
                  ));
        },
      ),
    );
  }
}
