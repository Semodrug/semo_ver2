import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/login/register_step2.dart';
import 'package:semo_ver2/login/register_step3.dart';
import 'package:semo_ver2/login/login_provider.dart';

import 'my_reviews.dart';

//TODO: Q) auth는 한번만 선언하고 import 하나요/ dart 파일마다 하나요
// 아.. 한 파일에서 class 선언해서 넣어주고 계속 쓰나..?
// 이것이 setState 인가?

final FirebaseAuth _auth = FirebaseAuth.instance;
final User user = _auth.currentUser;

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    print(user.uid);
    DocumentReference curr_user =
        FirebaseFirestore.instance //user가 가지고 있는 약 data
            .collection('users')
            .doc(_auth.currentUser.uid);

    return ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(),
      child: Scaffold(
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
        body: FutureBuilder<DocumentSnapshot>(
          future: curr_user.get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              // TODO: show wait circle
              return Text(
                'loading...',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              );
            }
            // TODO 구글 로그인 이면
            var name = snapshot.data.get('name');
            if (name == null) name = user.displayName;

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
                                  '$name님, \n오늘도 건강하세요!',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                            //TODO: image picker
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
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .signOut();
                            Navigator.pushNamed(context, '/login');
                          }),
                    ],
                  ),
                ),
                // _myPageMenu('로그아웃', context, RegisterThirdPage()),
              ],
            );
          },
        ),
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