import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:semo_ver2/home/home.dart';

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
                      Navigator.pushNamed(context, '/bottom_bar');
                    }),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 48, 0, 0),
                child: Text("검색해서 약 추가하기",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            Align(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(330, 10, 0, 0),
                    child: FlatButton(
                      child: Text(
                          "X",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                      onPressed: () {
                        print('눌렸나확인해보자');
                        Navigator.pushNamed(context, '/bottom_bar');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: _goToSearchBar(context),
                  ),
                ],
              ),
            ),
            //스낵바처럼 왔따갔따 만들어주는 친구 제스처 디텍트 함
            AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
                left: 0,
                bottom: (showBottomMenu) ? -60 : -(height / 3),
                child: MenuWidget()),
          ],
        ),
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
          child:
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.search, size: 20),
                Text("어떤 약을 찾고 계세요? "),
              ],
            ),
            onPressed: () {
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

class MenuWidget extends StatelessWidget {
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
        Center(
          child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: height / 8),
                  Row(children: [
                    Container(
                      //margin: const EdgeInsets.all(15.0),
                      width: width / 4,
                      height: height / 5,
                      child: FlatButton(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                    'assets/icons/barcode_icon.png'),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: Text(
                                "바코드 인식",
                                style: TextStyle(
                                    fontSize: 17, color: Color(0XFF327A70)),
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
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      width: width / 4,
                      height: height / 5,
                      child: FlatButton(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/icons/case_icon.png'),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: Text(
                                "케이스 인식",
                                style: TextStyle(
                                    fontSize: 17, color: Color(0XFF327A70)),
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
                      //margin: const EdgeInsets.all(15.0),
                      width: width / 4,
                      height: height / 5,
                      child: FlatButton(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                    'assets/icons/one_drug_icon.png'),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: Text(
                                "한 알   인식",
                                style: TextStyle(
                                    fontSize: 17, color: Color(0XFF327A70)),
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: 330,
                    height: height / 7,
                    child: FlatButton(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('assets/icons/camera_icon.png'),
                          ),
                          Container(
                            child: Text(
                              "촬영해서 약 추가하기",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0XFFA4A4A4)),
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
              )),
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

    path.moveTo(0, size.height * 0.15); //A
    path.quadraticBezierTo((size.width / 4) * 0.8, 0, size.width / 2, 0); //BC

    path.quadraticBezierTo(
      //DE
        (size.width / 4) * 3.2,
        0, //size.height / 2,
        size.width,
        size.height * 0.15);

    path.lineTo(size.width, size.height); //F
    path.lineTo(0, size.height); //G

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
