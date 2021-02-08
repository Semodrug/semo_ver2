import 'package:flutter/material.dart';
import 'package:semo_ver2/login/register_withEmail.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('회원가입', Icon(Icons.arrow_back), 0.5),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text('내 약이 궁금할 땐'),
              Container(
                child: SizedBox(
                  child: Image.asset('assets/login/login_logo.png'),
                  width: 120,
                  height: 60,
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_email.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterWithEmailPage()),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey,
                indent: 16,
                endIndent: 16,
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_google.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterWithEmailPage()),
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_kakao.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterWithEmailPage()),
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_apple.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterWithEmailPage()),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
