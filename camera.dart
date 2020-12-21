import 'package:flutter/material.dart';

CameraState pageState;

class Camera extends StatefulWidget {
  @override
  CameraState createState() {
    pageState = CameraState();
    return pageState;
  }
}

class CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          child: Text('얼굴 인식하기'),
          onPressed: () {
            Navigator.pushNamed(context, '/face_detection');
          },
        ),
        SimpleDialogOption(
          child: Text('바코드 인식하기'),
          onPressed: () {
            Navigator.pushNamed(context, '/barcode');
          },
        ),
        SimpleDialogOption(child: Text('취소'), onPressed: () {}),
      ],
    );
  }
}
