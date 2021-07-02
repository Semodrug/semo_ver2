//원래 수미 코드

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

/*
//cahched image 쓴거 써도 크게 이미지 업로드 속도에 크게 차이가 없음 추후 알아보기!!
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:semo_ver2/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            //이부분에서 자꾸 업로드 하는데 [list들이 많을 때]
            // 에러 메세지가 뜨고 난 후에 올라오는 이미지의 속도가 지연이 되는 듯 함!
            //이미지가 없을 때 바로 처리해주는 부분 찾아보기
            return Container(
              decoration: BoxDecoration(border: Border.all(color: gray75)),
              child: Image.asset('assets/images/null.png'),
            );
          } else
            {
            return Container(
                decoration: BoxDecoration(border: Border.all(color: gray75)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  imageUrl: snapshot.data,
                )
            );
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
  } //on firebase_storage.FirebaseException
  catch (e) {
    if (e.code == 'object-not-found') {
      // String downloadURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('null.png')
      //     // .ref('Image/195900043.png')
      //     .getDownloadURL();

      return 'null';
    }
  }
}
*/

