import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String get userEmail {
    return _auth.currentUser.email;
  }

  // create user obj based on firebase user
  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
    // .map(_userFromFirebaseUser);
  }

  // register with email and password
  Future signUpWithEmail(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return '이미 사용 중인 이메일 입니다';
      } else if (e.code == 'invalid-email') {
        return '유효한 이메일 형식이 아닙니다';
      } else if (e.code == 'weak-password') {
        return '입력한 비밀번호가 너무 약합니다';
      }
    }
  }

  // login with email and password
  Future signInWithEmail(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '회원이 아니시거나 아이디를 잘못입력하셨습니다';
      } else if (e.code == 'invalid-email') {
        return '잘못된 이메일 형식입니다';
      } else if (e.code == 'wrong-password') {
        return '비밀번호를 잘못입력하셨습니다';
      }
    }
  }

  // login with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final User user = (await _auth.signInWithCredential(credential)).user;

      print("signed in " + user.displayName);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // login with kakao
  // Future signInWithKakao() async {
  //   try {
  //     final FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
  //     final result = await kakaoSignIn.logIn();
  //     print(result);
  //     // To-do Someting ...
  //   } catch (e) {
  //     print("${e.code} ${e.message}");
  //   }
  // }
  //
  // Future signOutWithKakao() async {
  //   try {
  //     final FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
  //     final result = await kakaoSignIn.logOut();
  //     // To-do Someting ...
  //   } catch (e) {
  //     print("${e.code} ${e.message}");
  //   }
  // }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  Future sendPasswordResetEmail(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '회원이 아니시거나 아이디를 잘못입력하셨습니다';
      } else if (e.code == 'invalid-email') {
        return '잘못된 이메일 형식입니다';
      } else if (e.code == 'wrong-password') {
        return '비밀번호를 잘못입력하셨습니다';
      }
    }
  }

  // Firebase로부터 회원 탈퇴
  Future withdrawalAccount() async {
    try {
      return await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return '로그인을 다시 하신 후 시도해주시기 바랍니다.';
      } else
        return e.toString();
    }

    // catch (error) {
    //   print(error.toString());
    //   return error.toString();
    // }
  }

  // // Firebase로부터 수신한 메시지 설정
  // void setLastFBMessage(String msg) {
  //   _lastFirebaseResponse = msg;
  // }

  // // Firebase로부터 수신한 메시지를 반환하고 삭제
  // String getLastFBMessage() {
  //   String returnValue = _lastFirebaseResponse;
  //   _lastFirebaseResponse = null;
  //   return returnValue;
  // }
}
