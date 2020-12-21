import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home.dart';
import 'register_1.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* leading ==> 로그인 페이지 뛰어 넘을 수 있게 만들어놓은 버튼 */
        leading: IconButton(
          icon: Icon(Icons.android),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage() //
                    //CategoryMenu()
                    ));

            //Navigator.pushNamed(context, '/HomeDrug');
          },
        ),
        centerTitle: true,
        //title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.teal[100],
                //Colors.teal[50],
                Colors.teal[200]
              ])),
        ), //gradation
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Log out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                final User user = await _auth.currentUser;
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
            //_EmailLinkSignInSection(),
            //_AnonymouslySignInSection(),
            //_GoogleSignInSection(),
            // _PhoneSignInSection(Scaffold.of(context)),
            // _OtherProvidersSignInSection(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: const Text(
              '이약모약',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
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
          SizedBox(height: 30.0),
          SizedBox(
            //padding: const EdgeInsets.symmetric(vertical: 16.0),
            //alignment: Alignment.center,
            width: 350.0,
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
          /*new SizedBox(
            width: 200.0,
            height: 100.0,
            child: new RaisedButton(
              child: const Text('로그인', style: TextStyle(color: Colors.white),),
              color: Colors.teal[400],
              onPressed: (){},
            ),
          ),*/
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '혹시 이약모약 사용이 처음이신가요?',
                style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
              ),
              FlatButton(
                onPressed: () =>
                    _pushPage(context, RegisterFirstPage()), //register page로 이동
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
          )
        ],
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
