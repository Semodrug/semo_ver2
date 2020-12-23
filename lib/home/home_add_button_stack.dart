

import 'package:flutter/material.dart';
import 'home.dart';
import 'search_screen.dart';
import 'package:semo_ver2/bottom_bar.dart';

class OverlayWithHole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getExperimentThree());
  }

  Stack _getExperimentThree() {
    return Stack(children: <Widget>[
      //HomePage(),
      BottomBar(),
      _getColorFilteredOverlay(),
      _getHint()
    ]);
  }

  ColorFiltered _getColorFilteredOverlay() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOut),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 55, 0, 0),
                child: Text("검색해서 약 추가하기",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 35, 0, 0),
                child: FlatButton(
                  child: Text("X", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeDrugPage()));*/
                    //Navigator.pop(context);
                  },
                )
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80, right: 4, bottom: 4),
                height: 48,
                width: 400,
                decoration: BoxDecoration(
                  // Color does not matter but must not be transparent
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.search, size: 20),
                      Text("어떤 약을 찾고 계세요? "),
                    ],
                  ),
                  onPressed: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (BuildContext context) => SearchScreen(),
//                      ),
//                    );
                  print("the button on pressed ");
                  },
                  textColor: Colors.grey[500],
                  color: Colors.grey[200],
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid, width: 1.0, color: Colors.white),
                      borderRadius: new BorderRadius.circular(8.0)),
                ),
                /*
                child:
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, size: 30),
                    hintText: "어떤 약을 찾고 계세요?",
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
//                        filled: true,
//                        fillColor: Colors.white
                    //contentPadding: EdgeInsets.only(left: 5)
                  ),
                ),
                */
              ),
            ),
          ),

        ],
      ),
    );
  }

  Positioned _getHint() {
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            //  padding: EdgeInsets.all(5),
                            child: Text(
                              "바코드 인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print("bar code");
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            //  padding: EdgeInsets.all(5),
                            child: Text(
                              "케이스 인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print("bar code");
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Icon(Icons.content_paste),
                          SizedBox(height: 15),
                          Container(
                            //  padding: EdgeInsets.all(5),
                            child: Text(
                              "한 알   인식",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        print("bar code");
                      },
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                  //Text("You can add news pages with a tap"),
                ]),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  width: 350,
                  height: 70,
                  child: FlatButton(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Icon(Icons.camera_alt),
                        Container(
                          //  padding: EdgeInsets.all(5),
                          child: Text(
                            "촬영해서 약 추가하기",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
                // ),
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
