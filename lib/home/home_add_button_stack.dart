import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'package:semo_ver2/bottom_bar.dart';

class AddButton extends StatefulWidget {
  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getEContent(context));
  }

  Widget _getEContent(BuildContext context) {
    return Stack(children: <Widget>[
      BottomBar(),
      _getColorFilteredOverlay(context),
      _getButtons()
    ]);
  }

  Widget _getColorFilteredOverlay(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOut),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 48, 0, 0),
              child: Text("검색해서 약 추가하기",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child:
            Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(330, 10, 0, 0),
                    child: FlatButton(
                        child: Text(
                          "X",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          print('BACK to home');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => BottomBar()));
                          print('XXXXXX');
                        },
                      ),
                    ),
                    _goToSearchBar(context),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _goToSearchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 11, bottom: 4),
          height: 36,
          width: 400,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen(),
                ),
              );
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

  Widget _getButtons() {
    return Positioned(
        bottom: 0,
        child: Container(
            height: 350,
            width: 410,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white60,
                //color: Color(0xEBEDED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                )),
            child: Column(
              children: <Widget>[
                SizedBox(height: 55),
                Row(children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 100,
                    height: 130,
                    child: FlatButton(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            child: Text(
                              "바코드 인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print(
                            "바코드 인식 페이지로!!"); // 여기는 바코드 인식 페이지가 어떤 약인지 알려주는 바코드 페이지
                      },
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 100,
                    height: 130,
                    child: FlatButton(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            child: Text(
                              "케이스 인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print("CASE 인식");
                      },
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 100,
                    height: 130,
                    child: FlatButton(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            child: Text(
                              "한 알   인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print("한 알 인식 페이지로!!");
                      },
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                ]),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  width: 350,
                  height: 70,
                  child: FlatButton(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Icon(Icons.camera_alt),
                        Container(
                          child: Text(
                            "촬영해서 약 추가하기",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      print('약을 추가하는 페이지!! 인식이 아님!!');
                    },
                  ),
                ),
              ],
            )));
  }
}

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.height - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class InvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addOval(Rect.fromCircle(
            center: Offset(size.width - 44, size.height - 44), radius: 40))
        ..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
