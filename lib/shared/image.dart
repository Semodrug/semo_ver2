import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:semo_ver2/theme/colors.dart';

class DrugImage extends StatefulWidget {
  final String drugItemSeq;

  const DrugImage({Key key, this.drugItemSeq}) : super(key: key);

  @override
  _DrugImageState createState() => _DrugImageState();
}

class _DrugImageState extends State<DrugImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadURLExample(widget.drugItemSeq),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'null') {
            return Container(
              decoration: BoxDecoration(border: Border.all(color: gray75)),
              child: Image.asset('assets/images/null.png'),
            );
          } else {
            return Container(
                decoration: BoxDecoration(border: Border.all(color: gray75)),
                child: Image.network(snapshot.data));
          }
        } else {
          return Container();
        }
      },
    );
  }
}

Future<String> _downloadURLExample(String itemSeq) async {
  try {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('Image/$itemSeq.png')
        .getDownloadURL();

    return downloadURL;
  } on firebase_storage.FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      // String downloadURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('null.png')
      //     // .ref('Image/195900043.png')
      //     .getDownloadURL();

      return 'null';
    }
  }
}
