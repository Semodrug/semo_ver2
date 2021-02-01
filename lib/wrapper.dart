import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/initial/1_policy_agree.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/login/login.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/services/db.dart';

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
            // return BottomBar();

            if (snapshot.data == false) {
              return PolicyAgreePage();
            } else {
              return BottomBar();
            }
          });
    }
  }
}
