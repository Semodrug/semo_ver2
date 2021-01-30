import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

class CategoryButton extends StatelessWidget {
  final String str;
  String fromHome = '';

  //const
  CategoryButton({this.str, this.fromHome}); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _shortenCategory(String data) {
      String newName = '';

      newName = data.substring(7, (data.length));

      if (fromHome == 'home') {
        if (newName.length > 12) {
          newName = newName.substring(0, 15);
          newName = newName + '...';
        }
      }

      return newName;
    }

    return ElevatedButton(
      child: Text(
        '${_shortenCategory(str)}',
        style: TextStyle(fontSize: 12, color: primary600_bold_text),
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(12, 23),
          padding: EdgeInsets.symmetric(horizontal: 10, ),
          elevation: 0,
          primary: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(color: gray75))),
      onPressed: () {},
    );
  }
}
