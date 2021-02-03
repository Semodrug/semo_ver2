import 'package:flutter/material.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

bool _isFilled = false;
final AuthService _auth = AuthService();

class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
          '비밀번호 재설정',
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
                padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '비밀번호 재설정\n이메일을 보내드려요',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '가입 시 입력한 이메일 주소를 입력해주세요.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      '아이디 (이메일)',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: primary400_line,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'abc@iymy.com'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _isFilled = true;
                          });
                        } else {
                          setState(() {
                            _isFilled = false;
                          });
                        }
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    IYMYSubmitButton(
                      context: context,
                      isDone: _isFilled,
                      textString: '전송하기',
                      onPressed: () async {
                        if (_isFilled && _formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .sendPasswordResetEmail(_emailController.text);
                          if (result is String) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(result)));
                          }
                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('이메일이 전송되었습니다.')));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/start', (Route<dynamic> route) => false);
                          }
                        }
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
}
