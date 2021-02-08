import 'package:flutter/material.dart';
import 'package:semo_ver2/mypage/7-2_withdrawal_done.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

bool _isAgree = false;

class WithdrawalPage extends StatefulWidget {
  final String userId;

  const WithdrawalPage({Key key, this.userId}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final AuthService _auth = AuthService();

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
            '회원 탈퇴',
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
            SizedBox(height: 24),
            _topWarning(),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            _checkAgreement(),
            SizedBox(height: 40),
            _submitButton(context)
          ],
        ));
  }

  Widget _topWarning() {
    String str1 = '- 탈퇴 시, 이약모약에서 저장한 내역이 모두 삭제되며 탈퇴 이후 복구가 불가능합니다.';
    String str2 = '- 작성된 리뷰는 삭제되지 않으며, 이를 원치 않을 경우 작성한 리뷰를 모두 삭제하신 후 탈퇴해주세요.';
    String str3 = '- 서비스 탈퇴 후, 땡땡정보는 어쩌구에 의하여 몇년간 보관됩니다.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            str1,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
          SizedBox(height: 10),
          Text(
            str2,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
          SizedBox(height: 10),
          Text(
            str3,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
        ],
      ),
    );
  }

  Widget _checkAgreement() {
    return InkWell(
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: gray300_inactivated),
            child: Checkbox(
              value: _isAgree,
              activeColor: primary300_main,
              onChanged: (value) {
                setState(() {
                  _isAgree = !_isAgree;
                });
              },
            ),
          ),
          Text(
            '위 사실을 확인하였습니다.',
            style:
                Theme.of(context).textTheme.bodyText2.copyWith(color: gray900),
          )
        ],
      ),
      onTap: () {
        setState(() {
          _isAgree = !_isAgree;
        });
      },
    );
  }

  Widget _submitButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IYMYSubmitButton(
          context: context,
          isDone: _isAgree,
          textString: '탈퇴하기',
          onPressed: () async {
            if (_isAgree) {
              await DatabaseService().deleteUser(widget.userId);

              dynamic result = await _auth.withdrawalAccount();

              if (result is String) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result)));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WithdrawalDonePage()),
                );
              }
            }
          }),
    );
  }
}
