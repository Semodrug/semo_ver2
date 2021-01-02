import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String contents;
  final String tail1;
  final String tail2;

  const MyDialog({Key key, this.title, this.contents, this.tail1, this.tail2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: new Text(
        title ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.teal[400]),
      ),
      content: Text(contents),
      actions: <Widget>[
        (tail1 != null)
            ? FlatButton(
                child: Text(
                  tail1,
                  style: TextStyle(color: Colors.teal[200]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        (tail2 != null)
            ? FlatButton(
                child: Text(
                  tail2,
                  style: TextStyle(color: Colors.teal[200]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ],
    );
  }
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(StringProperty('tail2', tail2));
  // }
}
