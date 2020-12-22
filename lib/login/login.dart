import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/login/register_1.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn _googleSignIn = GoogleSignIn();

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
            //_GoogleSignInSection(),
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
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
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                '이약모약',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                labelText: '아이디',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                labelText: '비밀번호',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 50.0),
            SizedBox(
              //padding: const EdgeInsets.symmetric(vertical: 16.0),
              //alignment: Alignment.center,
              width: 400.0,
              height: 45.0,
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signInWithEmailAndPassword();
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
            Container(
              child: FlatButton(
                child: Text(
                  '아이디/비밀번호 찾기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 13.0,
                      color: Colors.grey[400]),
                ),
                onPressed: () {}, //아이디 비밀번호 찾기 페이지로 이동
              ),
            ),
            Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '혹시 이약모약 사용이 처음이신가요?',
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                ),
                FlatButton(
                  onPressed: () => _pushPage(
                      context, RegisterFirstPage()), //register page로 이동
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12.0,
                        color: Colors.black),
                  ),
                ),
              ]),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _success == null
                    ? ''
                    : (_success
                        ? 'Successfully signed in ' + _userEmail
                        : 'Sign in failed'),
                style: TextStyle(color: Colors.red),
              ),
            ),

            /* 로그인 뛰어넘기 */
            IconButton(
              icon: Icon(Icons.skip_next),
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
