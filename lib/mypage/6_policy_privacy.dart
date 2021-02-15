import 'package:flutter/material.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class PolicyPrivacyPage extends StatefulWidget {
  @override
  _PolicyPrivacyPageState createState() => _PolicyPrivacyPageState();
}

class _PolicyPrivacyPageState extends State<PolicyPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack('개인정보 처리방침', Icon(Icons.arrow_back), 0.5),
        backgroundColor: Colors.white,
        body: Text('개인정보 처리방침 페이지'));
  }
}
