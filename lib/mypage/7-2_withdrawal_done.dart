import 'package:flutter/material.dart';

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
    String str1 = '탈퇴가 완료되었습니다.';
    String str2 = '더 좋은 이약모약이 되기 위해 노력하겠습니다.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          str1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(str2),
        SizedBox(height: 5),
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
              '첫 화면으로',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.teal[300],
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start', (Route<dynamic> route) => false);
            }),
      ),
    );
  }
}
