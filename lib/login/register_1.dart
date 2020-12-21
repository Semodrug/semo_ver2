import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_2.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterFirstPage extends StatefulWidget {
  final String title = '회원가입';

  @override
  State<StatefulWidget> createState() => RegisterFirstPageState();
}

class RegisterFirstPageState extends State<RegisterFirstPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
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
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text('환영합니다\n기본정보를 입력해 주세요',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '이메일 입력',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '이메일을 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '8자리 이상',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '8자리 이상 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordCheckController,
                decoration: const InputDecoration(
                  labelText: '비밀번호 확인',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '8자리 이상',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '8자리 이상 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50.0),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350.0,
                  height: 45.0,
                  //padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _register();
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal[400],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(_success == null
                    ? ''
                    : (_success
                        ? '로그인 정보가 입력되었습니다.' + _userEmail
                        : 'Registration failed')),
              ),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350.0,
                  height: 45.0,
                  //padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //alignment: Alignment.center,
                  child: RaisedButton(
                    //개인정보 페이지 넘어가

                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterSecondPage()),
                      );
                    },
                    //onPressed :() => print('get personal info'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: const Text(
                      '개인정보 입력',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    final user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordCheckController.text,
      //email: 'an email',
      //password: 'a password',
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
