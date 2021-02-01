import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/drug_info/expiration_g.dart';
import 'package:semo_ver2/drug_info/expiration_s.dart';
import 'package:semo_ver2/review/drug_info.dart';

import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/home/search_screen.dart';
//import 'package:semo_ver2/home/_past_search_screen.dart';

import 'package:semo_ver2/home/home_add_button_stack.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

/*약들의 개수를 length 만큼 보여주고 싶은데 그 length의 인덱스를 어떻게 넘겨주지..?*/
int num = 0;

class HomePage extends StatefulWidget {
  String appBarForSearch;

  HomePage({this.appBarForSearch});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //widget.appBarForSearch = false;

    if (widget.appBarForSearch == 'search') {
      return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            '이약모약',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.teal[200],
              ),
            ),
            //for test home
          ],

          backgroundColor: Colors.white,
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
        body: _buildBody(context),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(context),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<SavedDrug>>(
        stream: DatabaseService(uid: user.uid).savedDrugs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          return _buildList(context, snapshot.data);
        });
  }

  Widget _buildList(BuildContext context, List<SavedDrug> snapshot) {
    num = 0;

    int count = snapshot.length;
    if (count == 0) {
      return _noDrugPage();
    }

    return Column(
      children: [
        SearchBar(),
        Container(
          height: 45,
          margin: EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Text('나의 약 보관함',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(width: 8),
                  // theme 추가
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primary300_main, // background
                    ),
                    //padding: EdgeInsets.only(left: 10),
                    child: Text('+ 추가하기',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddButton()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
        ),
        Expanded(
          child: ListView(
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, SavedDrug data) {
    TheUser user = Provider.of<TheUser>(context);
    num++;
    double mw = MediaQuery.of(context).size.width;

    String _checkLongName(SavedDrug data) {
      String newName = data.itemName;
      List splitName = [];

      if (data.itemName.contains('(수출') || data.itemName.contains('(군납')) {
        if (newName.contains('')) {
          splitName = newName.split('(');
          newName = splitName[0];
        }
      }
      //미디어 쿼리 기준 width가 370이하면
      if (newName.length > 15) {
        if (mw < 375) {
          newName = newName.substring(0, 9);
          newName = newName + '...';
        } else {
          newName = newName.substring(0, 12);
          newName = newName + '...';
        }
      }
      return newName;
    }

    //TODO: 지금 클라우드에 적히지가 않아서 이따 적어야함
    String _checkCategoryName(String data) {
      String newName = '';

      if (data.length > 10) {
        newName = data.substring(0, 9);
        newName = newName + '...';
      }

      return newName;
    }

    //TODO: 시간 계산하기 위한 코드 시작
    String dateOfUserDrug = '';
    List<String> getOnlyDate = data.expiration.split('.');

    for (int i = 0; i < getOnlyDate.length; i++) {
      dateOfUserDrug = dateOfUserDrug + getOnlyDate[i];
    }

    String dateWithT = dateOfUserDrug.substring(0, 8) + 'T' + '000000';
    DateTime expirationTime = DateTime.parse(dateWithT);

    String dateNow = DateFormat('yyyyMMdd').format(DateTime.now());
    List<String> getOnlyDateOfNow = dateNow.split('.');

    for (int i = 0; i < getOnlyDateOfNow.length; i++) {
      dateNow = dateNow + getOnlyDateOfNow[i];
    }

    String dateNowWithT = dateNow.substring(0, 8) + 'T' + '000000';
    DateTime rightNowTime = DateTime.parse(dateNowWithT);

    final difference = expirationTime.difference(rightNowTime).inDays;

    //print('difference==> $difference');
    //시간 계산하기 위한 코드 끝

    //사용기한 7일 남음
    if (difference < 8 && difference > 0) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0),
                width: double.infinity,
                height: 90,
                child: Material(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              num.toString(),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          //이미지는 고정값
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                              width: 80,
                              child: AspectRatio(
                                  aspectRatio: 3.5 / 2,
                                  child:
                                      DrugImage(drugItemSeq: data.itemSeq)))),
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(_checkLongName(data),
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Color(0xFF2C2C2C)))),
                              //SizedBox(height: 2,),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                    height: 20,
                                    child: CategoryButton(
                                        str: data.category, fromHome: 'home')),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                data.expiration,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 11),
                              )
                            ],
                          )),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xFF898989),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                      child: Container(
                                          child: Wrap(
                                    children: <Widget>[
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) {
                                                      if (data.etcOtcCode ==
                                                          '일반의약품') {
                                                        return ExpirationG(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      } else {
                                                        return ExpirationS(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      }
                                                    }));
                                          },
                                          child: Center(
                                              child: Text("사용기한 수정하기",
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showDeleteDialog(
                                              context,
                                              data.itemSeq,
                                              user.uid,
                                            );
//
                                          },
                                          child: Center(
                                              child: Text("삭제하기",
                                                  style: TextStyle(
                                                      color: Colors.red[600],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                              child: Text("취소",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16))))
                                    ],
                                  )));
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningRemainMessage(context, difference),
                ),
              )
            ],
          ),
        ),
      );
    }
    //사용기한 지남
    else if (difference < 0) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0),
                width: double.infinity,
                height: 90,
                child: Material(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              num.toString(),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          //이미지는 고정값
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                              width: 80,
                              child: AspectRatio(
                                  aspectRatio: 3.5 / 2,
                                  child:
                                      DrugImage(drugItemSeq: data.itemSeq)))),
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(_checkLongName(data),
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Color(0xFF2C2C2C)))),
                              //SizedBox(height: 2,),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                    height: 20,
                                    child: CategoryButton(
                                        str: data.category, fromHome: 'home')),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                data.expiration,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 11),
                              )
                            ],
                          )),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xFF898989),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                      child: Container(
                                          child: Wrap(
                                    children: <Widget>[
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) {
                                                      if (data.etcOtcCode ==
                                                          '일반의약품') {
                                                        return ExpirationG(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      } else {
                                                        return ExpirationS(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      }
                                                    }));
                                          },
                                          child: Center(
                                              child: Text("사용기한 수정하기",
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showDeleteDialog(
                                              context,
                                              data.itemSeq,
                                              user.uid,
                                            );
//
                                          },
                                          child: Center(
                                              child: Text("삭제하기",
                                                  style: TextStyle(
                                                      color: Colors.red[600],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                              child: Text("취소",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16))))
                                    ],
                                  )));
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: warning),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningOverDayMessage(context, difference),
                ),
              )
            ],
          ),
        ),
      );
    }
    //사용기한 아직 넉넉함
    else
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0),
                width: double.infinity,
                height: 90,
                child: Material(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              num.toString(),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          //이미지는 고정값
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                              width: 80,
                              child: AspectRatio(
                                  aspectRatio: 3.5 / 2,
                                  child:
                                      DrugImage(drugItemSeq: data.itemSeq)))),
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(_checkLongName(data),
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Color(0xFF2C2C2C)))),
                              //SizedBox(height: 2,),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                    height: 20,
                                    child: CategoryButton(
                                        str: data.category, fromHome: 'home')),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                data.expiration,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 11),
                              )
                            ],
                          )),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xFF898989),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                      child: Container(
                                          child: Wrap(
                                    children: <Widget>[
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) {
                                                      if (data.etcOtcCode ==
                                                          '일반의약품') {
                                                        return ExpirationG(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      } else {
                                                        return ExpirationS(
                                                          drugItemSeq:
                                                              data.itemSeq,
                                                        );
                                                      }
                                                    }));
                                          },
                                          child: Center(
                                              child: Text("사용기한 수정하기",
                                                  style: TextStyle(
                                                      color: Colors.blue[700],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showDeleteDialog(
                                              context,
                                              data.itemSeq,
                                              user.uid,
                                            );
//
                                          },
                                          child: Center(
                                              child: Text("삭제하기",
                                                  style: TextStyle(
                                                      color: Colors.red[600],
                                                      fontSize: 16)))),
                                      MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                              child: Text("취소",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16))))
                                    ],
                                  )));
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showDeleteDialog(context, record, uid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Center(child: Text('AlertDialog Title')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text('정말 삭제하시겠습니까?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('삭제',
                          style: TextStyle(
                              color: primary500_light_text,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _showDeletedWell(context);
                        await DatabaseService(uid: uid)
                            .deleteSavedDrugData(record);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeletedWell(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          // Navigator.pushReplacementNamed(context, '/bottom_bar');
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
                          text: '약 보관함에서 ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '삭제 되었습니다.'),
                    ],
                  ),
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

  Widget _warningRemainMessage(context, dayRemain) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_yellow.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                  TextSpan(text: '사용기한이 '),
                    TextSpan(
                        text: '$dayRemain일',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' 남았습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _warningOverDayMessage(context, difference) {
    List<String> dayOver = difference.toString().split('-');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_red.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '사용기한이 '),
                    TextSpan(
                        text: '${dayOver[1]}일',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' 지났습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noDrugPage() {
    return Column(children: [
      SearchBar(),
      Container(
        height: 45,
        margin: EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Text('나의 약 보관함',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Color(0xFF1F1F1F))),
                SizedBox(width: 8),
                // theme 추가
                Spacer(),
                Container(
                  // width: 63,
                  // height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primary300_main, // background
                    ),
                    //padding: EdgeInsets.only(left: 10),
                    child: Text('+ 추가하기',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddButton()));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Divider(
        thickness: 0.5,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 46),
        child: Center(
          child: Column(
            children: [
              Text('상비약 목록이 비었어요',
                  style: Theme.of(context).textTheme.headline5),
              Text(
                '\'+ 추가하기\' 버튼으로 약을 추가해보세요',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      )
    ]);
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //이 search bar에서 바로 검색을 하게 할 것인가?
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
          //width: searchWidth,
          height: 35,
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.search, size: 20)),
                SizedBox(
                  width: 10,
                ),
                Text("어떤 약을 찾고 계세요? "),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen(),
                  //builder: (BuildContext context) => SearchScreenByProvider()
                ),
              );
            },
            textColor: Colors.grey[500],
            color: Colors.grey[200],
            shape: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, width: 1.0, color: Colors.white),
                borderRadius: new BorderRadius.circular(8.0)),
          )),
    );
  }
}
