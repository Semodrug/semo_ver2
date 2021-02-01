import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/mypage/7-1_withdrawal.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/theme/colors.dart';

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
                      Text('회원 탈퇴',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: gray900, fontWeight: FontWeight.normal)),
                      IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: primary400_line,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WithdrawalPage(userId: user.uid)),
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
                  padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('로그아웃',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: gray900, fontWeight: FontWeight.normal)),
                      IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: primary400_line,
                          ),
                          onPressed: () async {
                            _showWarning(context);
                          }),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[50],
                  height: 2,
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
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Text('정말 로그아웃하시겠어요?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      '취소',
                      style: TextStyle(fontSize: 12, color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 12, color: gray0_white),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: primary300_main,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () async {
                      await _auth.signOut();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/start', (Route<dynamic> route) => false);
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
