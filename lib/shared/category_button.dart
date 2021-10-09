import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

class CategoryButton extends StatelessWidget {
  final String str;
  String fromHome = '';
  String forRanking = '';
  final bool forsearch;
  final bool fromDrugInfo;

  //const
  CategoryButton(
      {this.str,
      this.fromHome,
      this.forsearch,
      this.forRanking,
      this.fromDrugInfo}); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;

    String _shortenCategory(String data) {
      String newName = '';

      if (data == '카테고리 없음')
        newName = '카테고리 없음';
      else
        newName = data.substring(7, (data.length));

      if (fromHome == 'home') {
        if (newName.length > 15) {
          newName = newName.substring(0, 13);
          newName = newName + '...';
        }
        if (newName.length > 10) {
          if (mw < 350) {
            newName = newName.substring(0, 9);
            newName = newName + '...';
          }
        }
      }

      if (forRanking == 'ranking') {
        if (newName.length > 15) {
          if (mw < 380) {
            newName = newName.substring(0, 13);
            newName = newName + '…';
          }
        }
      }

      if (fromDrugInfo == true) {
        if (newName.length > 15) {
          newName = newName.substring(0, 13);
          newName = newName + '...';
          if (mw < 350) {
            newName = newName.substring(0, 10);
            newName = newName + '...';
          }
        }
      }

      return newName;
    }

    if (forsearch == true) {
      return ElevatedButton(
        child: Text('${_shortenCategory(str)}',
            style:
                Theme.of(context).textTheme.caption.copyWith(color: gray500)),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(12, 23),
            padding: EdgeInsets.symmetric(horizontal: 10),
            elevation: 0,
            primary: gray50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: gray75))),
        onPressed: () {},
      );
    }

    return ElevatedButton(
      child: Text('${_shortenCategory(str)}',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: primary600_bold_text)),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(12, 23),
          padding: EdgeInsets.symmetric(horizontal: 10),
          elevation: 0,
          primary: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(color: gray75))),
      onPressed: () {},
    );
  }
}
