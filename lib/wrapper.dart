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
    // final TheUser user = Provider.of<TheUser>(context);
    // if (user == null) {
    //   return LoginPage();
    // } else {
    //   return BottomBar();
    // }

    // return either the Home or Authenticate widget
    return StreamBuilder<TheUser>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        TheUser user = snapshot.data;
        return (user == null) ? LoginPage() : BottomBar();
      },
    );
  }
}
