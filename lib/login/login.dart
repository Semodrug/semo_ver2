import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/login/register.dart';
import 'package:semo_ver2/shared/loading.dart';

import 'package:semo_ver2/login/find_id.dart';
import 'package:semo_ver2/login/find_password.dart';
import 'package:semo_ver2/login/register1_email.dart';
// import 'package:semo_ver2/login/login_provider.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/constants.dart';

// TODO: find id, passwd
// TODO: kakao login
// TODO: theme style

// TODO: 확인 버튼이 키보드 바로 위에 위치하면 좋겠다
// TODO: Page route를 무조건 push pull 아니고 아예 reset 할때도 필요

// TODO: 구글 로그인 후, 개인 정보 받아야한다

final AuthService _auth = AuthService();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
            _GoogleSignInSection(),
            /* 로그인 뛰어넘기 */
            IconButton(
              icon: Icon(Icons.skip_next),
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');
              },
            ),
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        // left, right : 16, top: 60
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                '이약모약',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              cursorColor: Colors.teal[400],
              decoration: textInputDecoration.copyWith(hintText: '아이디(이메일)'),
              validator: (value) => value.isEmpty ? '아이디(이메일)을 입력해주세요' : null,
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              cursorColor: Colors.teal[400],
              decoration: textInputDecoration.copyWith(hintText: '비밀번호'),
              obscureText: true,
              validator: (value) => value.isEmpty ? '비밀번호를 입력해주세요' : null,
              onChanged: (value) {
                setState(() => password = value);
              },
            ),
            SizedBox(height: 40.0),
            SizedBox(
              //padding: const EdgeInsets.symmetric(vertical: 16.0),
              //alignment: Alignment.center,
              width: 400.0,
              height: 45.0,
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    // setState(() => loading = true);
                    dynamic result =
                        await _auth.signInWithEmail(email, password);
                    if (result == null) {
                      setState(() {
                        // loading = false;
                        error = 'Could not sign in with those credentials';
                      });
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: const Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.teal[400],
              ),
            ),
            // SizedB
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '아이디 찾기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 13.0,
                      color: Colors.grey[400]),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindId()),
                  );
                },
              ),
              Text(
                ' |  ',
                style: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '비밀번호 찾기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 13.0,
                      color: Colors.grey[400]),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindPassword()),
                  );
                },
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '혹시, 이약모약 사용이 처음이신가요?',
                style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
              ),
              FlatButton(
                child: Text(
                  '회원가입',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12.0,
                      color: Colors.black),
                ),
                onPressed: () {
                  // register page로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  @override
  Widget build(BuildContext context) {
    String error = '';

    return Column(
      children: <Widget>[
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlatButton(
              onPressed: () async {
                // setState(() => loading = true);
                dynamic result = await _auth.signInWithGoogle();
                if (result == null) {
                  setState(() {
                    // loading = false;
                    error = 'Could not sign in with those credentials';
                  });
                }
              },
              child: SizedBox(
                child: Image.asset('assets/login/google.png'),
                width: 42,
                height: 42,
              ),
            ),
            FlatButton(
              onPressed: () async {
                // setState(() => loading = true);
                dynamic result = await _auth.signInWithGoogle();
                if (result == null) {
                  setState(() {
                    // loading = false;
                    error = 'Could not sign in with those credentials';
                  });
                }
              },
              child: SizedBox(
                child: Image.asset('assets/login/kakao.png'),
                width: 42,
                height: 42,
              ),
            ),
            FlatButton(
              onPressed: () async {
                // setState(() => loading = true);
                dynamic result = await _auth.signInWithGoogle();
                if (result == null) {
                  setState(() {
                    // loading = false;
                    error = 'Could not sign in with those credentials';
                  });
                }
              },
              child: SizedBox(
                child: Image.asset('assets/login/apple.png'),
                width: 42,
                height: 42,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
