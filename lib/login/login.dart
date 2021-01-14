import 'package:flutter/material.dart';

import 'package:semo_ver2/login/register.dart';
import 'package:semo_ver2/login/find_password.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/constants.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                '이약모약',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            _emailField(),
            SizedBox(
              height: 10,
            ),
            _passwordField(),
            SizedBox(height: 40.0),
            _submitButton(),
            _findPasswordButton(),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.teal[400],
      decoration: textInputDecoration.copyWith(hintText: '이메일'),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isIdFilled = true;
          });
        } else {
          setState(() {
            _isIdFilled = false;
          });
        }
      },
      validator: (String value) {
        if (value.isEmpty) {
          return '아이디(이메일)을 입력해주세요';
        } else if (!value.contains('@')) {
          return '올바른 이메일을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.teal[400],
      decoration: textInputDecoration.copyWith(
          hintText: '비밀번호',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.visibility,
              color: _isSecret ? Colors.grey : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _isSecret = !_isSecret;
              });
            },
          )),
      obscureText: _isSecret ? true : false,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isPasswordFilled = true;
          });
        } else {
          setState(() {
            _isPasswordFilled = false;
          });
        }
      },
      validator: (value) => value.isEmpty ? '비밀번호를 입력해주세요' : null,
    );
  }

  Widget _submitButton() {
    return SizedBox(
      //padding: const EdgeInsets.symmetric(vertical: 16.0),
      //alignment: Alignment.center,
      width: 400.0,
      height: 45.0,
      child: RaisedButton(
        child: Text(
          '로그인',
          style: TextStyle(color: Colors.white),
        ),
        color:
            _isIdFilled && _isPasswordFilled ? Colors.teal[400] : Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () async {
          if (_isIdFilled &&
              _isPasswordFilled &&
              _formKey.currentState.validate()) {
            // setState(() => loading = true);
            dynamic result = await _auth.signInWithEmail(
                _emailController.text, _passwordController.text);

            if (result is String) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result)));
            } else if (result == null) {
              setState(() {
                // loading = false;
                error = 'Could not sign in with those credentials';
              });
            }
          }
        },
      ),
    );
  }

  Widget _findPasswordButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '비밀번호를 잊으셨나요? ',
        style: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
      ),
      FlatButton(
        padding: EdgeInsets.zero,
        child: Text(
          '비밀번호 재설정',
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
    ]);
  }

  Widget _registerButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    ]);
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _googleLoginButton(),
            _kakaoLoginButton(),
            _appleLoginButton(),
          ]),
        ),
      ],
    );
  }

  Widget _googleLoginButton() {
    return FlatButton(
      onPressed: () async {
        // setState(() => loading = true);
        dynamic result = await _auth.signInWithGoogle();
        if (result == null) {
          // setState(() {
          //   // loading = false;
          //   // error = 'Could not sign in with those credentials';
          print('Could not sign in with those credentials');
          //   }
          // );
        }
      },
      child: SizedBox(
        child: Image.asset('assets/login/google.png'),
        width: 42,
        height: 42,
      ),
    );
  }

  Widget _kakaoLoginButton() {
    return FlatButton(
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
    );
  }

  Widget _appleLoginButton() {
    return FlatButton(
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
    );
  }
}

/* 로그인 뛰어넘기 */
// IconButton(
// icon: Icon(Icons.skip_next),
// color: Colors.redAccent,
// onPressed: () {
// Navigator.pushNamed(context, '/bottom_bar');
// },
// ),
