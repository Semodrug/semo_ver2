import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

class WithdrawalDonePage extends StatefulWidget {
  @override
  _WithdrawalDonePageState createState() => _WithdrawalDonePageState();
}

class _WithdrawalDonePageState extends State<WithdrawalDonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.teal[200],
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start', (Route<dynamic> route) => false);
            },
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _information(),
              SizedBox(height: 20),
              _submitButton(context)
            ],
          ),
        ));
  }

  Widget _information() {
    String str1 = '탈퇴가 완료되었습니다';
    String str2 = '더 좋은 이약모약 서비스를 위해 노력하겠습니다';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        Text(
          str1,
          style: Theme.of(context).textTheme.headline4.copyWith(color: gray700),
        ),
        SizedBox(height: 5),
        Text(
          str2,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 120),
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
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            child: Text(
              '첫 화면으로',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: gray0_white, fontSize: 15),
            ),
            color: primary400_line,
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start', (Route<dynamic> route) => false);
            }),
      ),
    );
  }
}
