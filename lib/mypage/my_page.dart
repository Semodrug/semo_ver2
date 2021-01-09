import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/login/register_step2.dart';
import 'package:semo_ver2/login/register_step3.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/mypage/my_reviews.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthService _auth = AuthService();

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
          '마이페이지',
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
      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData.name}님, \n오늘도 건강하세요!',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _auth.userEmail,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                            // TODO: image picker
                            IconButton(
                              icon: Icon(
                                Icons.person,
                                color: Colors.teal[200],
                              ),
                              onPressed: () {
                                null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // TODO: 리뷰 갯수
                            _myMenu('리뷰', '0', context, MyReviews()),
                            _myMenu('찜', '0', context, MyReviews()),
                            _myMenu('1:1 문의', '0', context, MyReviews())
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // TODO: 회원정보 수정페이지==> 읽어와서 보여줘야함(기말 add page 처럼), 나의 건강정보 관리 페이지
                SizedBox(
                  height: 10,
                ),
                _myPageMenu('회원정보 수정', context, RegisterSecondPage()),
                SizedBox(
                  height: 2,
                ),
                _myPageMenu('나의 건강정보 관리', context, RegisterThirdPage()),
                SizedBox(
                  height: 10,
                ),
                // TODO: 공지사항, 1:1문의, 이용약관, 환경설정 페이지
                _myPageMenu('공지사항', context, RegisterSecondPage()),
                SizedBox(
                  height: 2,
                ),
                _myPageMenu('1:1 문의', context, RegisterThirdPage()),
                SizedBox(
                  height: 2,
                ),
                _myPageMenu('이용약관', context, RegisterThirdPage()),
                SizedBox(
                  height: 10,
                ),
                _myPageMenu('환경설정', context, RegisterSecondPage()),
                SizedBox(
                  height: 2,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(20.0, 0, 10.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '로그아웃',
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.teal[200],
                          ),
                          onPressed: () async {
                            // TODO: when log-out, we should go to login page by Wrapper
                            await _auth.signOut();
                            Navigator.pop(context);
                            // Navigator.pushReplacementNamed(context, '/login');
                          }),
                    ],
                  ),
                ),
                // _myPageMenu('로그아웃', context, RegisterThirdPage()),
              ],
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}

Widget _myMenu(String name, String count, BuildContext context, var nextPage) {
  return Column(
    children: [
      Text(
        name,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      TextButton(
        child: Text(
          count,
          style: TextStyle(
            color: Colors.teal[300],
            fontSize: 20,
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        ),
      )
    ],
  );
}

Widget _myPageMenu(String name, BuildContext context, var nextPage) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.fromLTRB(20.0, 0, 10.0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
        ),
        IconButton(
          icon: Icon(
            Icons.navigate_next,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          ),
        ),
      ],
    ),
  );
}
