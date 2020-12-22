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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text('환영합니다\n기본정보를 입력해 주세요',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.teal[400],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: '이메일',
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.teal[400],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: '비밀번호',
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        // filled: true,
                        // fillColor: Colors.white,
                        // hintText: '8자리 이상',
                      ),
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '8자리 이상 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordCheckController,
                      cursorColor: Colors.teal[400],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: '비밀번호 확인',
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        // filled: true,
                        // fillColor: Colors.white,
                        // hintText: '8자리 이상',
                      ),
                      obscureText: true,
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
                        width: 400.0,
                        height: 45.0,
                        //padding: const EdgeInsets.symmetric(vertical: 16.0),
                        //alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _register();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterSecondPage()),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: const Text(
                            '확인',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal[400],
                        ),
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: Text(_success == null
                    //       ? ''
                    //       : (_success
                    //           ? '로그인 정보가 입력되었습니다.' + _userEmail
                    //           : 'Registration failed')),
                    // ),

                    /* 로그인 뛰어넘기 */
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      color: Colors.redAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterSecondPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
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
