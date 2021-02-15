import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:semo_ver2/home/home.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'case_recognition.dart';

class AddButton extends StatefulWidget {
  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool showBottomMenu = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            //Home page가 제일 뒤로 가게끔 해둔 것!
            HomePage(
              appBarForSearch: 'search',
            ),

            //이친구가 뒤에 배경 블러처리 해주는 친구
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: (showBottomMenu) ? 1.0 : 0.0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: GestureDetector(
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      //Navigator.pushNamed(context, '/bottom_bar');
                    }),
              ),
            ),
            /*
            //이부분은 검색해서 약 추가하기에지 UI 대한 부분
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          //이부분은 핸드폰 마다 건드릴 수 있는 부분!!
                          //color: Colors.redAccent,
                          padding: EdgeInsets.fromLTRB(0, (height / 11), 0, 0),
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 25,
                              child: Text("검색해서 약 추가하기",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 30,
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/bottom_bar');
                        },
                      ),
                    ),
                  ],
                ),
                _goToSearchBar(context),
              ],

              //여기까지
            ),
            */
            //스낵바처럼 왔따갔따 만들어주는 친구 제스처 디텍트 함
            AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
                left: 0,
                bottom: (showBottomMenu) ? -60 : -(height / 3),
                child: FixMenuWidget()) // MenuWidget()),
          ],
        ),
      ),
    );
  }

  Widget _goToSearchBar(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            // Color does not matter but must not be transparent
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.search, size: 20),
                Text("어떤 약을 찾고 계세요? "),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/search');
            },
            textColor: Colors.grey[500],
            color: Colors.grey[200],
            shape: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, width: 1.0, color: Colors.white),
                borderRadius: new BorderRadius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}

class FixMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        color: Colors.white,
        width: width,
        height: height / 3 + 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                width: width / 4 * 3.8,
                height: height / 15,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              Image.asset('assets/icons/barcode_icon_grey.png'),
                        ),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
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
              Container(
                  height: 10,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: gray500)))),
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "닫기",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 14, color: gray500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  File pickedImage;
  String barcodeNum;
  bool imageLoaded = false;

  Future<void> pickImage() async {
    var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = awaitImage;
      imageLoaded = true;
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: width,
          height: height / 3 + 230,
          child: CustomPaint(
            painter: CurvePainter(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SizedBox(height: height / 4.3),
              /*
              Row(children: [
                Container(
                  width: width / 4,
                  height: height / 5,
                  child: FlatButton(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset('assets/icons/barcode_icon.png'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(
                            "바코드\n인식",
                            style: TextStyle(
                                fontSize: 15, color: Color(0XFF327A70)),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onPressed: () async {
                      await pickImage();

                      var data = await DatabaseService()
                          .itemSeqFromBarcode(barcodeNum);

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
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 22, right: 22),
                  width: width / 4,
                  height: height / 5,
                  child: FlatButton(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Image.asset('assets/icons/case_icon.png'),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(
                            "케이스\n인식",
                            style: TextStyle(
                                fontSize: 15, color: Color(0XFF327A70)),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CaseRecognition()));
                    },
                  ),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
                Container(
                  width: width / 4,
                  height: height / 5,
                  child: FlatButton(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child:
                                Image.asset('assets/icons/one_drug_icon.png'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(
                            "한 알\n인식",
                            style: TextStyle(
                                fontSize: 15, color: Color(0XFF327A70)),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      print("한 알 인식 페이지로!!");
                    },
                  ),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
              ]),
              */
              Container(
                width: width / 4 * 3.8,
                height: height / 15,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('assets/icons/barcode_icon.png'),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        child: Text(
                          "바코드 인식",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Color(0xFF0D0D0D)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        child: Text(
                          "약 이름 검색",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Color(0xFF0D0D0D)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(height: 10,decoration: BoxDecoration(
                border: Border(bottom:BorderSide(width: 0.6, color: Color(0XFFA4A4A4))))
              ),
              Container(
                width: width / 4 * 3.8,
                height: height / 10,
                child: FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "닫기",
                      style: TextStyle(fontSize: 14, color: Color(0XFFA4A4A4)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0XFFEEF0F0);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.3); //A
    path.quadraticBezierTo((size.width / 4) * 0.8, size.height / 6,
        size.width / 2, size.height / 6); //BC

    path.quadraticBezierTo(
        //DE
        (size.width / 4) * 3.2,
        size.height / 6, //size.height / 2,
        size.width,
        size.height * 0.3);

    path.lineTo(size.width, size.height); //F
    path.lineTo(0, size.height); //G

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

*/
