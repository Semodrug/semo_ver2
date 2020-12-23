import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semo_ver2/login/find_id.dart';
import 'package:semo_ver2/login/find_password.dart';
import 'package:semo_ver2/login/register_step1.dart';

// TODO: find id, passwd page
// TODO: kakao login
// TODO: theme style

// TODO: 확인 버튼이 키보드 바로 위에 위치하면 좋겠다
// TODO: Page route를 무조건 push pull 아니고 아예 reset 할때도 필요

// TODO: 어떤건 private 변수/ public 변수 --> 언제 써야하는가
// TODO: 위젯과 클래스의 차이

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

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
            /* 로그인 뛰어넘기 */
            IconButton(
              icon: Icon(Icons.skip_next),
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');
              },
            ),
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
        // left, right : 16, top: 60
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                '이약모약',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
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
                hintText: '아이디(이메일)',
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '아이디(이메일)을 입력해주세요';
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
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                hintText: '비밀번호',
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return '비밀번호를 입력해주세요';
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
            // SizedB
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  '아이디 찾기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 13.0,
                      color: Colors.grey[400]),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindId()),
                  );
                },
              ),
              Text(
                ' |  ',
                style: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
              ),
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  '비밀번호 찾기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 13.0,
                      color: Colors.grey[400]),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindPassword()),
                  );
                },
              ),
            ]),
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
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     _success == null
            //         ? ''
            //         : (_success
            //             ? 'Successfully signed in ' + _userEmail
            //             : 'Sign in failed'),
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ),
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
      Navigator.pushReplacementNamed(context, '/bottom_bar');
    } else {
      _success = false;
    }
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '구글 아이디가 있으신가요?',
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
            ),
            FlatButton(
              onPressed: () async {
                _signInWithGoogle();
              },
              child: Text(
                '구글 아이디로 로그인',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12.0,
                    color: Colors.black),
              ),
            ),
          ]),
        ),
        // Container(
        //   alignment: Alignment.center,
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Text(
        //     _success == null
        //         ? ''
        //         : (_success
        //             ? 'Successfully signed in, uid: ' + _userID
        //             : 'Sign in failed'),
        //     style: TextStyle(color: Colors.red),
        //   ),
        // )
      ],
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        Navigator.pushNamed(context, '/bottom_bar');
      } else {
        _success = false;
      }
    });
  }
}
