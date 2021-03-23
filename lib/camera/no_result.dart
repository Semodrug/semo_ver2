import 'package:flutter/material.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class NoResult extends StatefulWidget {
  @override
  _NoResultState createState() => _NoResultState();
}

class _NoResultState extends State<NoResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResultAppBarBarcode(type: 1),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 32,
                height: 32,
                child: Image.asset('assets/icons/no_result.png')),
            SizedBox(
              height: 10,
            ),
            Text(
              '검색결과가 없습니다',
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
