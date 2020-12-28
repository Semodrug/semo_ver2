import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 플러그인의 인스턴스
  User _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _lastFirebaseResponse = ""; // Firebase로부터 받은 최신 메시지(에러 처리용)

  FirebaseProvider() {
    // logger.d("init FirebaseProvider");
    _prepareUser();
  }

  // 최근 Firebase에 로그인한 사용자의 정보 획득
  _prepareUser() {
    setUser(_auth.currentUser);
  }

  User getUser() {
    return _user;
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        // TODO: 인증 메일 발송 FLOW
        // 인증 메일 발송
        result.user.sendEmailVerification();
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
        return true;
      }
    } on Exception catch (e) {
      // logger.e(e.toString());
      print(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  //  이메일/비밀번호로 Firebase에 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        setUser(result.user);
        // logger.d(getUser());
        return true;
      }
      return false;
    } on Exception catch (e) {
      print(e.toString());
      // logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 구글아이디로 Firebase에 로그인
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      if (user != null) {
        setUser(user);
        return true;
      }
      return false;
    } on Exception catch (e) {
      print(e.toString());
      // logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }

    //
    // setState(() {
    //   if (user != null) {
    //     _success = true;
    //     _userID = user.uid;
    //     Navigator.pushNamed(context, '/bottom_bar');
    //   } else {
    //     _success = false;
    //   }
    // });
  }

  // Firebase로부터 로그아웃
  void signOut() async {
    await _auth.signOut();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  void sendPasswordResetEmail() async {
    _auth.sendPasswordResetEmail(email: getUser().email);
  }

  // Firebase로부터 회원 탈퇴
  void withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  void setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  String getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}
