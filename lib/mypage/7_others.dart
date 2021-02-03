import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/mypage/7-1_withdrawal.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/custom_dialog.dart';
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
                InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('회원 탈퇴',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: gray900,
                                    fontWeight: FontWeight.normal)),
                        IconButton(
                            icon: Icon(
                              Icons.navigate_next,
                              color: gray100,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WithdrawalPage(userId: user.uid)),
                  ),
                ),
                Container(
                  color: gray50,
                  height: 2,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('로그아웃',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: gray900,
                                    fontWeight: FontWeight.normal)),
                        IconButton(
                            icon: Icon(
                              Icons.navigate_next,
                              color: gray100,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                  onTap: () {
                    CustomDialog(
                        context: context,
                        bodyString: '정말 로그아웃하시겠어요?',
                        leftButtonName: '취소',
                        rightButtonName: '로그아웃',
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/start', (Route<dynamic> route) => false);
                        }).showWarning();
                  },
                ),
                Container(
                  color: gray50,
                  height: 2,
                ),
              ],
            ));
  }

  // Future<void> _onPressed(context) async {}
}
