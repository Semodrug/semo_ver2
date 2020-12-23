import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semo_ver2/login/find_id_result.dart';

class FindId extends StatefulWidget {
  @override
  _FindIdState createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phoneCheckController = TextEditingController();

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
          '아이디 찾기',
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
                    TextFormField(
                      controller: _nameController,
                      cursorColor: Colors.teal[400],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        hintText: '이름',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      cursorColor: Colors.teal[400],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        hintText: '휴대폰 번호 (-제외)',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        suffixIcon: ButtonTheme(
                          // TODO: height 조절ㅠㅠ
                          // TODO: 이 부분은 눌렸을 때 텍스트 필드로 인식되면 안되는데 인식이 된다!
                          // TODO: 인증번호 발송 눌렀을 때 인증보내 보내고, '재전송'으로 내용이 바뀌게 해야한다
                          height: 10,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(
                                    // TODO: 전화번호가 채워지면 색깔이 바뀌게
                                    color: Colors.teal[200])),
                            // color: isPressed[index] ? Colors.teal[200] : Colors.grey)),
                            color: Colors.white,
                            textColor: Colors.teal[200],
                            // textColor: isPressed[index] ? Colors.teal[200] : Colors.grey,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 12.0),
                            padding: EdgeInsets.all(1),
                            child: Text(
                              '인증번호 발송',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                            onPressed: () {
                              null;
                            },
                          ),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '전화번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneCheckController,
                      cursorColor: Colors.teal[400],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        hintText: '인증번호',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.0),
                        // filled: true,
                        // fillColor: Colors.white,
                        // hintText: '8자리 이상',
                      ),
                      obscureText: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '인증번호를 입력해주세요';
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
                              // _register();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FindIdResult()),
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
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
