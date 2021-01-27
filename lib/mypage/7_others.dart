import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/mypage/7-1_withdrawal.dart';
import 'package:semo_ver2/services/auth.dart';

class Others extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return (user == null)
        ? LinearProgressIndicator()
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
                '기타',
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
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '회원탈퇴',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: Colors.teal[200],
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WithdrawalPage()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[50],
                  height: 2,
                ),
                Container(
                  // color: Colors.white,
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
                            _showWarning(context);
                          }),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[50],
                  height: 10,
                ),
              ],
            ));
  }

  void _showWarning(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text(
            '정말 로그아웃하시겠어요?',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(color: Colors.teal[200]),
                    ),
                    onPressed: () async {
                      await _auth.signOut();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/start', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
