import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/initial/policy_agree.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/login/login.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final AuthService _auth = AuthService();
    // _auth.signOut();

    // TODO: check an auto-login
    final TheUser user = Provider.of<TheUser>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return FutureBuilder<bool>(
          future: DatabaseService(uid: user.uid).checkIfDocExists(user.uid),
          builder: (context, snapshot) {
            return BottomBar();
            // if (snapshot.data == true) {
            //   return BottomBar();
            // } else {
            //   return PolicyAgreePage();
            // }
          });
    }
  }
}

// return StreamBuilder<UserData>(
// stream: DatabaseService(uid: user.uid).userData,
// builder: (context, snapshot) {
// UserData userData = snapshot.data;
//
// if (userData.agreeDate == null)
// return PolicyAgreePage();
// else if (userData.nickname == null)
// return GetPrivacyPage();
// else if (userData.isPregnant == null) return GetHealthPage();
//
// return BottomBar();
// });
