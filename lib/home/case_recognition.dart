//import 'package:flutter/material.dart';
//class CaseRecognition extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
////          child: Image.asset('assets/images/pill.png', width:100, height: 100,)
//        child: SizedBox(
//          child: Image.asset('assets/images/pill.png'),
//          width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
//        ),
//      )
//    );
//  }
//}


import 'package:flutter/material.dart';
class CaseRecognition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mqheight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/images/pill.png', width:10, height: 10,)
//            child: AspectRatio(
//              aspectRatio: 16/10,
//                child: FittedBox(
//                  fit: BoxFit.contain,
//                  child: Image.asset('assets/images/pill.png'),
//                ),
//            )
        )
    );
  }
}
