import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/image.dart';

class Expiration extends StatefulWidget {
  final String drugItemSeq;

  const Expiration({Key key, this.drugItemSeq}) : super(key: key);

  @override
  _ExpirationState createState() => _ExpirationState();
}

class _ExpirationState extends State<Expiration> {
  DateTime myDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '상비약 추가하기',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color(0xFFE9FFFB),
                Color(0xFFE9FFFB),
                Color(0xFFFFFFFF),
              ])),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _topInfo(context, widget.drugItemSeq),
            SizedBox(
              height: 20,
            ),
            _okButton(context)
          ],
        ),
      ),
    );
  }

  Widget _topInfo(
    BuildContext context,
    String drugItemSeq,
  ) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: drugItemSeq).drugData,
        builder: (context, snapshot) {
          Drug drug = snapshot.data;
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  child: AspectRatio(
                      aspectRatio: 3.5 / 2,
                      child: DrugImage(drugItemSeq: drugItemSeq)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  drug.entpName,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  drug.itemName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                _categoryButton(drug.category),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '처방일',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // print(time);
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2100, 12, 31),
                              onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) async {
                            print('confirm $date');

                            setState(() {
                              myDate = date;
                            });

                            print("myDate $myDate");

                            String expirationTime =
                                DateFormat('yyyy.MM.dd').format(date);

                            await DatabaseService(uid: user.uid).addSavedList(
                                drug.itemName,
                                drug.itemSeq,
                                drug.category,
                                expirationTime);
                          },
                              currentTime: myDate,
                              locale:
                                  LocaleType.ko); // need currentTime setting?
                        },
                        child: Container(
                          //TODO: set padding, width with each device
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          width: 380,
                          height: 44,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormat('yyyy').format(myDate)}년 ${DateFormat('MM').format(myDate)}월 ${DateFormat('dd').format(myDate)}일',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        ))
                  ],
                )
              ],
            );
          } else {
            return Loading();
          }
        });
  }

  Widget _okButton(context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () async {
            _showSaveWell(context);
            // Navigator.pop(context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            '추가하기',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal[400],
        ),
      ),
    );
  }

  void _showSaveWell(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
        }); // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 17,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '약 보관함',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '에 추가되었습니다.'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '홈에서 확인하실 수 있습니다',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/* 카테고리전용 buttion */
Widget _categoryButton(str) {
  return Container(
    width: 24 + str.length.toDouble() * 10,
    padding: EdgeInsets.symmetric(horizontal: 2),
    child: ButtonTheme(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      minWidth: 10,
      height: 20,
      child: FlatButton(
        child: Text(
          '#$str',
          style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
        ),
        //padding: EdgeInsets.all(0),
        onPressed: () => print('$str!'),
        color: Colors.grey[200],
      ),
    ),
  );
}
