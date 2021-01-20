// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//
// class BarcodeResult extends StatefulWidget {
//   final String barcodeNum;
//
//   const BarcodeResult({Key key, this.barcodeNum}) : super(key: key);
//
//   @override
//   _BarcodeResultState createState() => _BarcodeResultState();
// }
//
// class _BarcodeResultState extends State<BarcodeResult> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text("Face Detection",
//               style: Theme.of(context).textTheme.headline1)),
//       body: Column(
//         children: <Widget>[
//           imageLoaded
//               ? Center(
//                   child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: const [
//                           BoxShadow(blurRadius: 20),
//                         ],
//                       ),
//                       margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
//                       height: 250,
//                       child: Image.file(
//                         pickedImage,
//                         // fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ))
//               : Container(),
//           SizedBox(height: 20.0),
//           Row(children: [
//             SizedBox(width: 10),
//             InkWell(
//               child: Container(
//                 height: 100,
//                 width: 100,
// //                  color: Colors.grey,
//                 child: Column(
//                   children: [
//                     Icon(Icons.photo_camera, size: 60),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       '바코드 인식',
//                       style: TextStyle(color: Colors.blue, fontSize: 15),
//                     ),
//                   ],
//                 ),
//               ),
//               onTap: () async {
//                 pickImage();
//               },
//             ),
//             SizedBox(width: 10),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("결과"),
//                 SizedBox(height: 10.0),
//                 Text("Barcode Number:  " + text),
//                 SizedBox(height: 30.0),
//               ],
//             )
//           ]),
//         ],
//       ),
//     );
//   }
// }
//
// /*import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//
//
// class ReadBarcode extends StatefulWidget {
// */ /*  @override
//   _ReadBarcodeState createState() => _ReadBarcodeState();*/ /*
//
// */ /*  final File image;
//   const ReadBarcode({Key key, this.image}) : super(key: key);
//   @override
//   _ReadBarcodeState createState() => _ReadBarcodeState(image);*/ /*
//
//   final String text;
//   const ReadBarcode({Key key, this.text}) : super(key: key);
//   @override
//   _ReadBarcodeState createState() => _ReadBarcodeState(text);
// }
//
// class _ReadBarcodeState extends State<ReadBarcode> {
// */ /*  final File image;
//   _ReadBarcodeState(this.image);*/ /*
//
//   final String text;
//   _ReadBarcodeState(this.text);
//
//
//
//   File pickedImage;
// //  var text = '';
// //  bool imageLoaded = false;
//
// */ /*  Future pickImage() async {
// //    var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);
//
// //    setState(() {
// //      pickedImage = awaitImage;
// //      imageLoaded = true;
// //    });
//
//     FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
//     VisionText readedText;
//
//     final BarcodeDetector barcodeDetector =
//     FirebaseVision.instance.barcodeDetector();
//
//     final List<Barcode> barcodes =
//     await barcodeDetector.detectInImage(visionImage);
//
//     for (Barcode barcode in barcodes) {
//
//       final String rawValue = barcode.rawValue;
//       final BarcodeValueType valueType = barcode.valueType;
//
//       setState(() {
//         text ="$rawValue";
// //        text ="$rawValue\nType: $valueType";
//       });
//
//     }
//     barcodeDetector.close();
//   }*/ /*
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 100.0),
//           text == '' ?
//               Center()
//           :
//           Text("pick image: "+ text),
//           */ /*Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(blurRadius: 20),
//                   ],
//                 ),
//                 margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
//                 height: 250,
// //                child: Image.file(
// //                  pickedImage,
// //                  fit: BoxFit.cover,
// //                ),
//               )),*/ /*
//           SizedBox(height: 30.0),
//           Text("pick image: "+ text),
//           SizedBox(height: 30.0),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Text(
//                 text,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }*/
