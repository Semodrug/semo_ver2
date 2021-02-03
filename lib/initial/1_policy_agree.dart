import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/initial/2_get_privacy.dart';
import 'package:semo_ver2/models/user.dart';

import 'package:semo_ver2/mypage/6_policy_privacy.dart';
import 'package:semo_ver2/mypage/5_policy_terms.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

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
        padding: EdgeInsets.fromLTRB(8, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topTitle(),
            SizedBox(
              height: 24,
            ),
            allCheckbox(),
            Divider(
              color: Colors.grey,
              indent: 8,
              endIndent: 8,
              // height: 30,
            ),
            termsCheckbox(),
            // SizedBox(
            //   height: 10,
            // ),
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

  Widget topTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Text(
        '서비스 이용을 위해\n이용약관에 동의해주세요 :)',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget allCheckbox() {
    return Row(
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: gray300_inactivated),
          child: Checkbox(
            value: _isTermsAgreed && _isPrivacyAgreed,
            activeColor: primary300_main,
            onChanged: (value) {
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
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          '전체동의',
          style: Theme.of(context).textTheme.subtitle1,
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
            Theme(
              data: ThemeData(unselectedWidgetColor: gray300_inactivated),
              child: Checkbox(
                onChanged: (bool value) {
                  setState(() {
                    _isTermsAgreed = !_isTermsAgreed;
                  });
                },
                value: _isTermsAgreed,
                activeColor: primary300_main,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text('(필수) 이용약관',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900))
          ],
        ),
        Row(
          children: [
            InkWell(
              child: Center(
                  child: Text(
                '보기',
                style: Theme.of(context).textTheme.caption,
              )),
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
            Theme(
              data: ThemeData(unselectedWidgetColor: gray300_inactivated),
              child: Checkbox(
                onChanged: (bool value) {
                  setState(() {
                    _isPrivacyAgreed = !_isPrivacyAgreed;
                  });
                },
                value: _isPrivacyAgreed,
                activeColor: primary300_main,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text('(필수) 개인정보 처리방침',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900)),
          ],
        ),
        Row(
          children: [
            InkWell(
              child: Center(
                  child: Text(
                '보기',
                style: Theme.of(context).textTheme.caption,
              )),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: IYMYSubmitButton(
        context: context,
        isDone: _isTermsAgreed && _isPrivacyAgreed,
        textString: '다음',
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
    );
  }
}
