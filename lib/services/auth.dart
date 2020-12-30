import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semo_ver2/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // sign up with email and password
  Future signUpWithEmail(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      // TODO: add to database
      // await DatabaseService(uid: user.uid)
      //     .updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // login with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
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

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // // 사용자에게 비밀번호 재설정 메일을 전송
  // void sendPasswordResetEmail() async {
  //   _auth.sendPasswordResetEmail(email: getUser().email);
  // }
  //
  // // Firebase로부터 회원 탈퇴
  // void withdrawalAccount() async {
  //   await getUser().delete();
  //   setUser(null);
  // }
  //
  // // Firebase로부터 수신한 메시지 설정
  // void setLastFBMessage(String msg) {
  //   _lastFirebaseResponse = msg;
  // }
  //
  // // Firebase로부터 수신한 메시지를 반환하고 삭제
  // String getLastFBMessage() {
  //   String returnValue = _lastFirebaseResponse;
  //   _lastFirebaseResponse = null;
  //   return returnValue;
  // }
}
