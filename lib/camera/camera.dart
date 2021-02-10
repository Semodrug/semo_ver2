// /*
// import 'package:flutter/material.dart';
// import 'package:semo_ver2/home/home.dart';
// import 'package:semo_ver2/home/search_screen.dart';
// import 'package:semo_ver2/bottom_bar.dart';
//
// class CameraPage extends StatefulWidget {
//   @override
//   _CameraState createState() => _CameraState();
// }
//
// class _CameraState extends State<CameraPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _getEContent(context));
//   }
//
//   Widget _getEContent(BuildContext context) {
//     return Stack(children: <Widget>[
//       BottomBar(),
//       _getColorFilteredOverlay(context),
//       _getButtons()
//     ]);
//   }
//
//   Widget _getColorFilteredOverlay(BuildContext context) {
//     return ColorFiltered(
//       colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOut),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(15, 48, 0, 0),
//               child: Text("검색해서 약 추가하기",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//               //)
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//             ),
//             child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.fromLTRB(330, 10, 0, 0),
//                       child: FlatButton(
//                         child: Text(
//                           "X",
//                           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
// //                          Navigator.push(context,
// //                              MaterialPageRoute(builder: (context) => BottomBar()));
// //                          print('XXXXXX');
//                         },
//                       ),
//                     ),
//                     _goToSearchBar(context),
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _goToSearchBar(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           margin: const EdgeInsets.only(top: 11, bottom: 4),
//           height: 36,
//           width: 400,
//           decoration: BoxDecoration(
//             // Color does not matter but must not be transparent
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: FlatButton(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(Icons.search, size: 20),
//                 Text("어떤 약을 찾고 계세요? "),
//               ],
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => SearchScreen(),
//                 ),
//               );
//             },
//             textColor: Colors.grey[500],
//             color: Colors.grey[200],
//             shape: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     style: BorderStyle.solid, width: 1.0, color: Colors.white),
//                 borderRadius: new BorderRadius.circular(8.0)),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _getButtons() {
//     return Positioned(
//         bottom: 0,
//         child: Container(
//             height: 350,
//             width: 410,
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//                 color: Colors.white60,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(120),
//                   topRight: Radius.circular(120),
//                 )),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(height: 55),
//                 Row(children: [
//                   Container(
//                     margin: const EdgeInsets.all(15.0),
//                     width: 100,
//                     height: 130,
//                     child: FlatButton(
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 10),
//                           Icon(Icons.content_paste),
//                           SizedBox(height: 15),
//                           Container(
//                             child: Text(
//                               "바코드 인식",
//                               style: TextStyle(fontSize: 17),
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         print(
//                             "바코드 인식 페이지로!!"); // 여기는 바코드 인식 페이지가 어떤 약인지 알려주는 바코드 페이지
//                       },
//                     ),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Colors.white60,
//                         borderRadius: BorderRadius.all(Radius.circular(4))),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(15.0),
//                     width: 100,
//                     height: 130,
//                     child: FlatButton(
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 10),
//                           Icon(Icons.content_paste),
//                           SizedBox(height: 15),
//                           Container(
//                             child: Text(
//                               "케이스 인식",
//                               style: TextStyle(fontSize: 17),
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         print("CASE 인식");
//                       },
//                     ),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Colors.white60,
//                         borderRadius: BorderRadius.all(Radius.circular(4))),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(15.0),
//                     width: 100,
//                     height: 130,
//                     child: FlatButton(
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 10),
//                           Icon(Icons.content_paste),
//                           SizedBox(height: 15),
//                           Container(
//                             child: Text(
//                               "한 알   인식",
//                               style: TextStyle(fontSize: 17),
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         print("한 알 인식 페이지로!!");
//                       },
//                     ),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: Colors.white60,
//                         borderRadius: BorderRadius.all(Radius.circular(4))),
//                   ),
//                 ]),
//                 Container(
//                   margin: const EdgeInsets.all(15.0),
//                   width: 350,
//                   height: 70,
//                   child: FlatButton(
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         Icon(Icons.camera_alt),
//                         Container(
//                           child: Text(
//                             "촬영해서 약 추가하기",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                       ],
//                     ),
//                     onPressed: () {
//                       print('약을 추가하는 페이지!! 인식이 아님!!');
//                     },
//                   ),
//                 ),
//                 // ),
//               ],
//             )));
//   }
// }
//
// class HolePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.black54;
//
//     canvas.drawPath(
//         Path.combine(
//           PathOperation.difference,
//           Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
//           Path()
//             ..addOval(Rect.fromCircle(
//                 center: Offset(size.width - 44, size.height - 44), radius: 40))
//             ..close(),
//         ),
//         paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class InvertedClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     return Path.combine(
//       PathOperation.difference,
//       Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
//       Path()
//         ..addOval(Rect.fromCircle(
//             center: Offset(size.width - 44, size.height - 44), radius: 40))
//         ..close(),
//     );
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
// */
//
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:semo_ver2/camera/no_result.dart';
// import 'package:semo_ver2/home/home.dart';
// import 'package:semo_ver2/review/drug_info.dart';
// import 'package:semo_ver2/services/db.dart';
// import 'package:semo_ver2/home/case_recognition.dart';
//
// class CameraPage extends StatefulWidget {
//   @override
//   _AddButtonState createState() => _AddButtonState();
// }
//
// class _AddButtonState extends State<CameraPage> {
//   bool showBottomMenu = true;
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: <Widget>[
//             //Home page가 제일 뒤로 가게끔 해둔 것!
//             // HomePage(
//             //   appBarForSearch: 'search',
//             // ),
//
//             //이친구가 뒤에 배경 블러처리 해주는 친구
//             AnimatedOpacity(
//               duration: Duration(milliseconds: 200),
//               opacity: (showBottomMenu) ? 1.0 : 0.0,
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                 child: GestureDetector(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.7),
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                       //Navigator.pushNamed(context, '/bottom_bar');
//                     }),
//               ),
//             ),
//             Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Container(
//                           //이부분은 핸드폰 마다 건드릴 수 있는 부분!!
//                           //color: Colors.redAccent,
//                           padding: EdgeInsets.fromLTRB(0, (height / 11), 0, 0),
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               height: 25,
//                               child: Text("검색해서 약 추가하기",
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Container(
//                       height: 30,
//                       child: FlatButton(
//                         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                         ),
//                         // Text(
//                         //     "X",
//                         //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
//                         onPressed: () {
//                           print('눌렸나확인해보자');
//                           Navigator.pushNamed(context, '/bottom_bar');
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
// //            Row(
// //              mainAxisAlignment: MainAxisAlignment.start,
// //              children: [
// //                Container(
// //                  padding: EdgeInsets.symmetric(horizontal: 16),
// //                  height: 25,
// //                  child: Text("검색해서 약 추가하기",
// //                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //                ),
// //              ],
// //            ),
//                 _goToSearchBar(context),
//               ],
//             ),
//
//             //스낵바처럼 왔따갔따 만들어주는 친구 제스처 디텍트 함
//             AnimatedPositioned(
//                 curve: Curves.easeInOut,
//                 duration: Duration(milliseconds: 200),
//                 left: 0,
//                 bottom: (showBottomMenu) ? -60 : -(height / 3),
//                 child: MenuWidget()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _goToSearchBar(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           height: 35,
//           decoration: BoxDecoration(
//             // Color does not matter but must not be transparent
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: FlatButton(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(Icons.search, size: 20),
//                 Text("어떤 약을 찾고 계세요? "),
//               ],
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/search');
//             },
//             textColor: Colors.grey[500],
//             color: Colors.grey[200],
//             shape: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     style: BorderStyle.solid, width: 1.0, color: Colors.white),
//                 borderRadius: new BorderRadius.circular(8.0)),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MenuWidget extends StatefulWidget {
//   @override
//   _MenuWidgetState createState() => _MenuWidgetState();
// }
//
// class _MenuWidgetState extends State<MenuWidget> {
//   File pickedImage;
//   String barcodeNum;
//   bool imageLoaded = false;
//
//   Future<void> pickImage() async {
//     var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       pickedImage = awaitImage;
//       imageLoaded = true;
//     });
//
//     FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
//     VisionText readedText;
//
//     final BarcodeDetector barcodeDetector =
//         FirebaseVision.instance.barcodeDetector();
//
//     final List<Barcode> barcodes =
//         await barcodeDetector.detectInImage(visionImage);
//
//     for (Barcode barcode in barcodes) {
//       final String rawValue = barcode.rawValue;
//       final BarcodeValueType valueType = barcode.valueType;
//
//       setState(() {
//         barcodeNum = "$rawValue";
//       });
//     }
//
//     barcodeDetector.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Stack(
//       children: [
//         Container(
//           width: width,
//           height: height / 3 + 230,
//           child: CustomPaint(
//             painter: CurvePainter(),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: height / 4.5),
//               Row(children: [
//                 Container(
//                   width: width / 4,
//                   height: height / 5,
//                   child: FlatButton(
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: Image.asset('assets/icons/barcode_icon.png'),
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Container(
//                           child: Text(
//                             "바코드\n인식",
//                             style: TextStyle(
//                                 fontSize: 15, color: Color(0XFF327A70)),
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                       ],
//                     ),
//                     onPressed: () async {
//                       await pickImage();
//
//                       var data = await DatabaseService()
//                           .itemSeqFromBarcode(barcodeNum);
//
//                       (barcodeNum != null && data != null)
//                           ? Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ReviewPage(data),
//                               ))
//                           : Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => NoResult(),
//                               ));
//                     },
//                   ),
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                       color: Colors.white60,
//                       borderRadius: BorderRadius.all(Radius.circular(4))),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(left: 22, right: 22),
//                   width: width / 4,
//                   height: height / 5,
//                   child: FlatButton(
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         SizedBox(
//                           height: 35,
//                           width: 35,
//                           child: Image.asset('assets/icons/case_icon.png'),
//                         ),
//                         SizedBox(height: 15),
//                         Container(
//                           child: Text(
//                             "케이스\n인식",
//                             style: TextStyle(
//                                 fontSize: 15, color: Color(0XFF327A70)),
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                       ],
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => CaseRecognition()));
//                     },
//                   ),
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                       color: Colors.white60,
//                       borderRadius: BorderRadius.all(Radius.circular(4))),
//                 ),
//                 Container(
//                   width: width / 4,
//                   height: height / 5,
//                   child: FlatButton(
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: SizedBox(
//                             height: 24,
//                             width: 24,
//                             child:
//                                 Image.asset('assets/icons/one_drug_icon.png'),
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Container(
//                           child: Text(
//                             "한 알\n인식",
//                             style: TextStyle(
//                                 fontSize: 15, color: Color(0XFF327A70)),
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                       ],
//                     ),
//                     onPressed: () {
//                       print("한 알 인식 페이지로!!");
//                     },
//                   ),
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                       color: Colors.white60,
//                       borderRadius: BorderRadius.all(Radius.circular(4))),
//                 ),
//               ]),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 width: width / 4 * 3.8,
//                 height: height / 7,
//                 child: FlatButton(
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(height: 10),
//                       SizedBox(
//                         height: 35,
//                         width: 35,
//                         child: Image.asset('assets/icons/camera_icon.png'),
//                       ),
//                       Container(
//                         child: Text(
//                           "촬영해서 약 추가하기",
//                           style:
//                               TextStyle(fontSize: 14, color: Color(0XFFA4A4A4)),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     ],
//                   ),
//                   onPressed: () {
//                     print('약을 추가하는 페이지!! 인식이 아님!!');
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
//
// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = Color(0XFFEEF0F0);
//     paint.style = PaintingStyle.fill; // Change this to fill
//
//     var path = Path();
//
//     path.moveTo(0, size.height * 0.3); //A
//     path.quadraticBezierTo((size.width / 4) * 0.8, size.height / 6,
//         size.width / 2, size.height / 6); //BC
//
//     path.quadraticBezierTo(
//         //DE
//         (size.width / 4) * 3.2,
//         size.height / 6, //size.height / 2,
//         size.width,
//         size.height * 0.3);
//
//     path.lineTo(size.width, size.height); //F
//     path.lineTo(0, size.height); //G
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
