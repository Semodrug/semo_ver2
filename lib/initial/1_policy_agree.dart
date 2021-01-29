import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/initial/2_get_privacy.dart';
import 'package:semo_ver2/models/user.dart';

import 'package:semo_ver2/mypage/6_policy_privacy.dart';
import 'package:semo_ver2/mypage/5_policy_terms.dart';
import 'package:semo_ver2/login/register_withEmail.dart';
import 'package:semo_ver2/services/db.dart';

bool _isTermsAgreed = false;
bool _isPrivacyAgreed = false;

class PolicyAgreePage extends StatefulWidget {
  @override
  _PolicyAgreePageState createState() => _PolicyAgreePageState();
}

class _PolicyAgreePageState extends State<PolicyAgreePage> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '이용약관',
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color(0xFFE9FFFB),
                Color(0xFFE9FFFB),
                Color(0xFFFFFFFF),
              ])),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            allCheckbox(),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            termsCheckbox(),
            SizedBox(
              height: 20,
            ),
            privacyCheckbox(),
            SizedBox(
              height: 50,
            ),
            submitField(user)
          ],
        ),
      ),
    );
  }

  Widget allCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_isTermsAgreed != _isPrivacyAgreed) {
                _isTermsAgreed = true;
                _isPrivacyAgreed = true;
              } else {
                _isTermsAgreed = !_isTermsAgreed;
                _isPrivacyAgreed = !_isPrivacyAgreed;
              }
            });
          },
          child: Container(
            child: Icon(
              Icons.check_circle_outline,
              color: _isTermsAgreed && _isPrivacyAgreed
                  ? Colors.teal[400]
                  : Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          '전체동의',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget termsCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isTermsAgreed = !_isTermsAgreed;
                });
              },
              child: Container(
                child: Icon(
                  Icons.check_circle_outline,
                  color: _isTermsAgreed ? Colors.teal[400] : Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text('(필수) 이용약관'),
          ],
        ),
        Row(
          children: [
            InkWell(
              child: Center(child: Text('보기')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PolicyTermPage()),
                );
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
        )
      ],
    );
  }

  Widget privacyCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPrivacyAgreed = !_isPrivacyAgreed;
                });
              },
              child: Container(
                child: Icon(
                  Icons.check_circle_outline,
                  color: _isPrivacyAgreed ? Colors.teal[400] : Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text('(필수) 개인정보 처리방침'),
          ],
        ),
        Row(
          children: [
            InkWell(
              child: Center(child: Text('보기')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PolicyPrivacyPage()),
                );
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
        )
      ],
    );
  }

  Widget submitField(user) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white),
          ),
          color: _isTermsAgreed && _isPrivacyAgreed
              ? Colors.teal[400]
              : Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () async {
            if (_isTermsAgreed && _isPrivacyAgreed) {
              // 이용약관 동의 날짜 저장
              String nowDT = DateFormat('yyyy.MM.dd').format(DateTime.now());
              await DatabaseService(uid: user.uid).addUser(nowDT);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetPrivacyPage()),
              );
            }
          },
        ),
      ),
    );
  }
}
