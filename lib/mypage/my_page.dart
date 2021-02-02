import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/mypage/1_edit_privacy.dart';
import 'package:semo_ver2/mypage/2_edit_health.dart';
import 'package:semo_ver2/mypage/3_notice.dart';
import 'package:semo_ver2/mypage/4_inquiry.dart';
import 'package:semo_ver2/mypage/5_policy_terms.dart';
import 'package:semo_ver2/mypage/6_policy_privacy.dart';
import 'package:semo_ver2/mypage/7_others.dart';
import 'package:semo_ver2/mypage/my_reviews.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return (user == null)
        ? Loading()
        : Scaffold(
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
                '마이페이지',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
            body: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _topMyInfo(userData),
                        Container(
                          color: Colors.grey[50],
                          height: 10,
                        ),
                        _myPageMenu('회원정보 수정', context,
                            EditPrivacyPage(userData: userData)),
                        Container(
                          color: Colors.grey[50],
                          height: 2,
                        ),
                        _myPageMenu('나의 건강정보 관리', context,
                            EditHealthPage(userData: userData)),
                        Container(
                          color: Colors.grey[50],
                          height: 10,
                        ),
                        // TODO: 공지사항, 1:1문의, 이용약관, 환경설정 페이지
                        _myPageMenu('공지사항', context, NoticePage()),
                        Container(
                          color: Colors.grey[50],
                          height: 2,
                        ),
                        _myPageMenu('1:1 문의', context, InquiryPage()),
                        Container(
                          color: Colors.grey[50],
                          height: 2,
                        ),
                        _myPageMenu('이용약관', context, PolicyTermPage()),
                        Container(
                          color: Colors.grey[50],
                          height: 2,
                        ),
                        _myPageMenu('개인정보 처리방침', context, PolicyPrivacyPage()),
                        Container(
                          color: Colors.grey[50],
                          height: 10,
                        ),
                        _myPageMenu('기타', context, Others()),
                        Container(
                          color: Colors.grey[50],
                          height: 2,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Loading();
                }
              },
            ),
          );
  }

  Widget _topMyInfo(userData) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: gray900),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${userData.nickname}',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: gray900),
                          ),
                          TextSpan(
                            text: '님, \n오늘도 건강하세요!',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(_auth.userEmail,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
                // TODO: image picker
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: primary300_main,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TODO: 리뷰 갯수
                  Container(
                      width: 136,
                      child: _myMenu('리뷰', '0', context, MyReviews())),
                  Container(
                    height: 44,
                    child: VerticalDivider(
                      color: gray75,
                    ),
                  ),
                  Container(
                      width: 136,
                      child: _myMenu('찜', '0', context, MyReviews())),
                  //_myMenu('1:1 문의', '0', context, MyReviews())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _myMenu(String name, String count, BuildContext context, var nextPage) {
  return InkWell(
    child: Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: gray500)),
          Text(count,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: primary500_light_text)),
        ],
      ),
    ),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    ),
  );
}

Widget _myPageMenu(String name, BuildContext context, var nextPage) {
  return InkWell(
      child: Container(
        height: 48,
        padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900, fontWeight: FontWeight.normal)),
            Icon(
              Icons.navigate_next,
              color: gray100,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      });
}
