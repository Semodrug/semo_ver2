import 'package:flutter/material.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('1:1 문의', Icon(Icons.arrow_back), 3),
      backgroundColor: Colors.white,
      body: Text('1:1 문의 페이지 입니다.'),
    );
  }
}
