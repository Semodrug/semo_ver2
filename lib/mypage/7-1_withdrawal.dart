import 'package:flutter/material.dart';
import 'package:semo_ver2/mypage/7-2_withdrawal_done.dart';
import 'package:semo_ver2/services/auth.dart';

class WithdrawalPage extends StatefulWidget {
  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final AuthService _auth = AuthService();
  bool _isAgree = false;

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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _topWarning(),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              _checkAgreement(),
              SizedBox(height: 20),
              _submitButton(context)
            ],
          ),
        ));
  }

  Widget _topWarning() {
    String str1 = '- 탈퇴 시, 이약모약에서 저장한 내역이 모두 삭제되며 탈퇴 이후 복구가 불가능합니다.';
    String str2 = '- 작성된 리뷰는 삭제되지 않으며, 이를 원치 않을 경우 작성한 리뷰를 모두 삭제하신 후 탈퇴해주세요.';
    String str3 = '- 서비스 탈퇴 후, 땡땡정보는 어쩌구에 의하여 몇년간 보관됩니다.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(str1),
        SizedBox(height: 5),
        Text(str2),
        SizedBox(height: 5),
        Text(str3),
      ],
    );
  }

  Widget _checkAgreement() {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.teal[300],
          value: _isAgree,
          onChanged: (value) {
            setState(() {
              _isAgree = !_isAgree;
            });
          },
        ),
        Text('위 사실을 확인하였습니다.')
      ],
    );
  }

  Widget _submitButton(context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        child: RaisedButton(
            child: Text(
              '탈퇴하기',
              style: TextStyle(color: Colors.white),
            ),
            color: _isAgree ? Colors.teal[300] : Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () async {
              if (_isAgree) {
                dynamic result = await _auth.withdrawalAccount();
                if (result is String) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WithdrawalDonePage()),
                  );
                }
              }
            }),
      ),
    );
  }
}
