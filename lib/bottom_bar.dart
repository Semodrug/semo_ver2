import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:semo_ver2/camera/no_result.dart';
import 'package:semo_ver2/home/home.dart';
import 'package:semo_ver2/ranking/ranking.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
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

  File pickedImage;
  String barcodeNum;
  bool imageLoaded = false;

  Future<bool> checkIfPermissionGranted() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();

    bool permitted = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) permitted = false;
    });

    return permitted;
  }

  Future<void> pickImage() async {
    if (await checkIfPermissionGranted()) {
      var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        pickedImage = awaitImage;
        imageLoaded = true;
      });

      FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(pickedImage);
      VisionText readedText;

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
    } else {
      print('권한을 허용해주세요');
      AppSettings.openAppSettings();
      // Navigator.of(context).pop();
    }
  }

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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          backgroundColor: primary400_line,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
