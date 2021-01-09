import 'package:flutter/material.dart';
import 'package:semo_ver2/login/register0_policy.dart';
import 'package:semo_ver2/login/register1_email.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
            '회원가입',
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
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text('내 약이 궁금할 땐'),
              Text(
                '이약모약',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_email.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPolicy()),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey,
                indent: 40,
                endIndent: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset('assets/login/with_google.png'),
              SizedBox(
                height: 10,
              ),
              Image.asset('assets/login/with_kakao.png'),
              SizedBox(
                height: 10,
              ),
              Image.asset('assets/login/with_apple.png'),
            ],
          ),
        ));
  }
}
