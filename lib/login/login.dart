import 'package:flutter/material.dart';

import 'package:semo_ver2/login/register.dart';
import 'package:semo_ver2/login/find_password.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

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
              child: SizedBox(
                child: Image.asset('assets/login/login_logo.png'),
                width: 120,
                height: 60,
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
            SizedBox(height: 30),
            _findPasswordButton(),
            SizedBox(height: 5),
            _registerButton(),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: primary400_line,
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
      cursorColor: primary400_line,
      decoration: textInputDecoration.copyWith(
          hintText: '비밀번호',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.visibility,
              color: _isSecret ? gray200 : Colors.black87,
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
    return IYMYSubmitButton(
      context: context,
      isDone: _isIdFilled && _isPasswordFilled,
      textString: '로그인',
      onPressed: () async {
        if (_isIdFilled &&
            _isPasswordFilled &&
            _formKey.currentState.validate()) {
          dynamic result = await _auth.signInWithEmail(
              _emailController.text, _passwordController.text);

          if (result is String) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  result,
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black.withOpacity(0.87)));
          } else if (result == null) {
            setState(() {
              // loading = false;
              error = 'Could not sign in with those credentials';
            });
          }
        }
      },
    );
  }

  Widget _findPasswordButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '비밀번호를 잊으셨나요? ',
        style: Theme.of(context).textTheme.caption,
      ),
      FlatButton(
        height: 20,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          '비밀번호 재설정',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(decoration: TextDecoration.underline),
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
        style: Theme.of(context).textTheme.caption,
      ),
      FlatButton(
        height: 20,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          '회원가입',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(decoration: TextDecoration.underline),
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
            _facebookLoginButton(),
            // _appleLoginButton(),
          ]),
        ),
      ],
    );
  }

  Widget _googleLoginButton() {
    return FlatButton(
      minWidth: 60,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
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

  Widget _facebookLoginButton() {
    return FlatButton(
      minWidth: 60,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: () async {
        // setState(() => loading = true);
        dynamic result = await _auth.signInWithFacebook();
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
      minWidth: 60,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
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
