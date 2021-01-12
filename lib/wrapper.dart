import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/login/login.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: check an auto-login
    // final AuthService _auth = AuthService();
    // _auth.signOut();

    final TheUser user = Provider.of<TheUser>(context);

    if (user == null) {
      print('user is null!');
      return LoginPage();
    } else {
      print('user is not null!');
      return BottomBar();
    }
  }
}
