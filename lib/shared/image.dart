import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:semo_ver2/shared/loading.dart';

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
      future: downloadURLExample(widget.drugItemSeq),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data.toString());
        } else {
          return Loading();
        }
      },
    );
  }
}

Future<String> downloadURLExample(String itemSeq) async {
  try {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('Image/$itemSeq.png')
        .getDownloadURL();
    // print(downloadURL);

    return downloadURL;
  } catch (e) {
    print(e);
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('noImage.png')
        .getDownloadURL();
    // print(downloadURL);

    return downloadURL;
  }

  // String downloadURL = await firebase_storage.FirebaseStorage.instance
  //   //     .ref('Image/$itemSeq.png')
  //   //     .getDownloadURL();
  //   //
  //   // if (downloadURL == null) {
  //   //   downloadURL = await firebase_storage.FirebaseStorage.instance
  //   //       .ref('noImage.png')
  //   //       .getDownloadURL();
  //   // }
  //   //
  //   // return downloadURL;
}
