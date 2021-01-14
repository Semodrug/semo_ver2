import 'package:flutter/material.dart';
import 'package:semo_ver2/login/register0_policy_privacy.dart';
import 'package:semo_ver2/login/register0_policy_terms.dart';
import 'package:semo_ver2/login/register1_email.dart';

bool _isTermsAgreed = false;
bool _isPrivacyAgreed = false;

class RegisterPolicy extends StatefulWidget {
  @override
  _RegisterPolicyState createState() => _RegisterPolicyState();
}

class _RegisterPolicyState extends State<RegisterPolicy> {
  @override
  Widget build(BuildContext context) {
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
            submitField()
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
                  MaterialPageRoute(builder: (context) => PolicyTerms()),
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
                  MaterialPageRoute(builder: (context) => PolicyPrivacy()),
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

  Widget submitField() {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          child: const Text(
            '확인',
            style: TextStyle(color: Colors.white),
          ),
          color: _isTermsAgreed && _isPrivacyAgreed
              ? Colors.teal[400]
              : Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () async {
            if (_isTermsAgreed && _isPrivacyAgreed) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterFirstPage()),
              );
            }
          },
        ),
      ),
    );
  }
}
