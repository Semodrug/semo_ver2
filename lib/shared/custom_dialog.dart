import 'package:flutter/material.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/theme/colors.dart';

class CustomDialog {
  void showWarning(BuildContext context, String bodyString, String actionName1,
      String actionName2, String actionCode, Function action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      actionName1,
                      style: TextStyle(fontSize: 12, color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text(
                      actionName2,
                      style: TextStyle(fontSize: 12, color: gray0_white),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: primary300_main,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () async {
                      if (actionCode == 'logout') {
                        action(context);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
