import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/login/login.dart';
import 'package:semo_ver2/bottom_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TheUser user = Provider.of<TheUser>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return LoginPage();
    } else {
      return BottomBar();
    }
  }
}
