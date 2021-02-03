import 'package:flutter/material.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;

class RegisterWithEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterWithEmailPageState();
}

class RegisterWithEmailPageState extends State<RegisterWithEmailPage> {
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
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('환영합니다\n기본정보를 설정해주세요',
                  style: Theme.of(context).textTheme.headline3),
            ),
            SizedBox(
              height: 24,
            ),
            emailField(),
            SizedBox(
              height: 20,
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아이디 (이메일)',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _emailController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(hintText: 'abc@iymy.com'),
          onChanged: (value) {
            if (value.length > 6) {
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
              return '이메일을 입력해주세요';
            } else if (!value.contains('@')) {
              return '올바른 이메일을 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _passwordController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(
              hintText: '8자리 이상',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: _isSecret ? gray200 : gray750_activated,
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
        ),
      ],
    );
  }

  Widget submitField(context) {
    return IYMYSubmitButton(
        context: context,
        isDone: _isIdFilled && _isPasswordFilled,
        textString: '이약모약 시작하기',
        onPressed: () async {
          if (_isIdFilled &&
              _isPasswordFilled &&
              _formKey.currentState.validate()) {
            dynamic result = await _auth.signUpWithEmail(
                _emailController.text, _passwordController.text);

            /* 오류 발생시 snackbar로 알려줌 */
            if (result is String) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result)));
            }
            /* 정상적으로 넘어간 경우 로그인도 동시에 진행해줌 */
            else {
              dynamic result = await _auth.signInWithEmail(
                  _emailController.text, _passwordController.text);

              if (result == null) {
                print('알 수 없는 오류 발생');
              }
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start', (Route<dynamic> route) => false);
            }
          } else {
            // 바로바로?
          }
        });
  }
}
