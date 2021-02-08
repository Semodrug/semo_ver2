import 'package:flutter/material.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class PolicyTermPage extends StatefulWidget {
  @override
  _PolicyTermPageState createState() => _PolicyTermPageState();
}

class _PolicyTermPageState extends State<PolicyTermPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('이용약관', Icon(Icons.arrow_back), 3),
        backgroundColor: Colors.white,
        body: Text('이용약관 페이지'));
  }
}
