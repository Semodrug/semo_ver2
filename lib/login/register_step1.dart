import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/login/login_provider.dart';
import 'package:semo_ver2/login/register_step2.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;

class RegisterFirstPage extends StatefulWidget {
  final String title = '회원가입';

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
        return ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: RegisterForm(),
            ),
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
              child: Text('환영합니다\n기본정보를 입력해 주세요',
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
            submitField(),
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
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.teal[400],
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        hintText: '아이디(이메일)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
      onChanged: (text) {
        if (text.isNotEmpty) {
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
          hintText: '비밀번호',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
          suffixIcon: IconButton(
            icon: Icon(
              _isSecret ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isSecret = !_isSecret;
                print(_isSecret);
              });
            },
          )),
      obscureText: _isSecret ? true : false,
      onChanged: (text) {
        if (text.length > 8) {
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
        if (value.isEmpty) {
          return '8자리 이상 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget submitField() {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          child: const Text(
            '확인',
            style: TextStyle(color: Colors.white),
          ),
          color:
              _isIdFilled && _isPasswordFilled ? Colors.teal[400] : Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () async {
            if (_isIdFilled && _isPasswordFilled) {
              if (_formKey.currentState.validate()) {
                // _register();
                await Provider.of<UserProvider>(context, listen: false)
                        .signUpWithEmail(
                            _emailController.text, _passwordController.text)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterSecondPage()),
                      )
                    : Container();
              }
            }
          },
        ),
      ),
    );
  }
}
