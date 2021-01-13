import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/login/register2_name.dart';
import 'package:semo_ver2/services/auth.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;
bool _isLoginFailed = false;

class RegisterFirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterFirstPageState();
}

class RegisterFirstPageState extends State<RegisterFirstPage> {
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
            child: RegisterForm(),
          ),
        );
      }),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('환영합니다\n기본정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            emailField(),
            SizedBox(
              height: 10,
            ),
            passwordField(),
            SizedBox(height: 50.0),
            submitField(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget emailField() {
    String _emailErrorMsg;

    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        hintText: '아이디 (이메일)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
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

  Widget passwordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          hintText: '비밀번호 (8자리 이상)',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
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
        if (value.length >= 8) {
          setState(() {
            _isPasswordFilled = true;
          });
        } else {
          setState(() {
            _isPasswordFilled = false;
          });
        }
      },
      validator: (String value) {
        if (value.isEmpty || value.length < 8) {
          return '8자리 이상 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget submitField(context) {
    return Builder(builder: (BuildContext context) {
      return Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 400.0,
          height: 45.0,
          child: RaisedButton(
              child: Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
              color: _isIdFilled && _isPasswordFilled
                  ? Colors.teal[400]
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () async {
                if (_isIdFilled &&
                    _isPasswordFilled &&
                    _formKey.currentState.validate()) {
                  dynamic result = await _auth.signUpWithEmail(
                      _emailController.text, _passwordController.text);

                  if (result is String) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(result)));
                  } else {
                    dynamic result = await _auth.signInWithEmail(
                        _emailController.text, _passwordController.text);
                    if (result == null) {
                      print('알 수 없는 오류 발생');
                      // setState(() {
                      //   loading = false;
                      //   error = 'Could not sign in with those credentials';
                      // });
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterSecondPage()),
                    );
                  }
                } else {
                  // 바로바로?
                }
              }),
        ),
      );
    });
  }
}
