import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/drug_info/detail_info.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/drug_info/set_expiration.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';

import '../review/review_page.dart';
import '../review/write_review.dart';

final fireInstance = FirebaseFirestore.instance;
// TODO: drug도 provider 필요!!!
// TODO: appbar 통일. 한군데 있는 거 계속 불러오게? fontsize: 16

class PhilInfoPage extends StatefulWidget {
  final String drugItemSeq;

  PhilInfoPage({Key key, @required this.drugItemSeq}) : super(key: key);

  @override
  _PhilInfoPageState createState() => _PhilInfoPageState();
}

class _PhilInfoPageState extends State<PhilInfoPage> {
  @override
  Widget build(BuildContext context) {
    downloadURLExample(widget.drugItemSeq);

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
            '약 정보',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Colors.teal[200],
            elevation: 0.0,
            onPressed: () {
//            rating();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WriteReview(widget.drugItemSeq)));
            }),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                child: _topInfo(context, widget.drugItemSeq),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 10.0,
                child: Container(
                  color: Colors.grey[200],
                ),
              ),
            ),
//             FROM HERE: TAB
            SliverToBoxAdapter(
              child: _myTab(context, widget.drugItemSeq),
            )
          ],
        )
    );
  }
}

// 약 이름, 회사 등 위쪽에 위치한 정보들
Widget _topInfo(BuildContext context, String drugItemSeq,
    ) {
  TheUser user = Provider.of<TheUser>(context);

  //TODO: how to control the state management better?
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;

          // print('SUMI's TEST: ${drug.item_name}')
          return StreamBuilder<Lists>(
              stream: DatabaseService(uid: user.uid).lists,
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List favoriteLists = snapshot2.data.favoriteLists;
                  bool isFavorite = favoriteLists.contains(drugItemSeq);

                  return StreamBuilder<List<SavedDrug>>(
                    stream: DatabaseService(uid: user.uid).savedDrugs,
                    builder: (context, snapshot3) {
                      if (snapshot3.hasData) {
                        List<SavedDrug> savedDrugs = snapshot3.data;
                        bool isSaved;

                        for (SavedDrug savedDrug in savedDrugs) {
                          isSaved = savedDrug.itemSeq.contains(drugItemSeq);
                          if (isSaved == true) break;
                        }

                        return Stack(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.0,
                                ),
                                Center(
                                  child: SizedBox(
                                    child: DrugImage(drugItemSeq: drugItemSeq),
                                    width: 200.0,
                                    height: 100.0,
                                  ),
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
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(children: <Widget>[
                                  // TODO: firebase connection
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // TODO: firebase connection
                                  Text(
                                    ' (305개)',
                                    style: TextStyle(color: Colors.grey[600]),
                                  )
                                ]),
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _categoryButton(drug.category)
                                    ]),
                              ]),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                padding: EdgeInsets.all(2.0),
                                icon: Icon(
                                  Icons.announcement,
                                  color: Colors.amber[700],
                                ),
                                onPressed: () => _showWarning(context)),
                          ),
                          Positioned(
                              bottom: 70,
                              right: 0,
                              child: IconButton(
                                  padding: EdgeInsets.all(2.0),
                                  icon: Icon(
                                    // Icons.favorite_border,
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.redAccent : null,
                                  ),
                                  onPressed: () async {
                                    isFavorite
                                        ? favoriteLists.remove(drugItemSeq)
                                        : favoriteLists.add(drugItemSeq);
                                    await DatabaseService(uid: user.uid)
                                        .updateLists(favoriteLists);
                                  })),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: ButtonTheme(
                              minWidth: 20,
                              height: 30,
                              child: FlatButton(
                                color: Colors.teal[300],
                                child: Text(
                                  '+ 담기',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (isSaved) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => Expiration(
                                              drugItemSeq: drugItemSeq,
                                            )));

//                                     _myDialog(context, '약 보관함',
//                                         '이미 보관함에 저장되어있습니다.', '', '확인');

                                    // MyDialog(
                                    //     contents: '이미 보관함에 저장되어있습니다.',
                                    //     tail1: '확인');
                                  } else {
                                    _myDialog(context, '약 보관함',
                                        '나의 보관함에 저장하시겠습니까?', '예', '아니요');
                                  }
                                },
                              ),
                            ),
                          ),
                        ]);
                      } else {
                        return Loading();
                      }
                    },
                  );
                } else {
                  return Loading();
                }
              });
        } else {
          return Loading();
        }
      });
}

Future<void> _myDialog(
    context, dialogTitle, dialogContent, tail1, tail2) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text(
          dialogTitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.teal[400]),
        ),
        content: Text(dialogContent),
        actions: <Widget>[
          FlatButton(
            child: Text(
              tail1,
              style: TextStyle(color: Colors.teal[200]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              tail2,
              style: TextStyle(color: Colors.teal[200]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// warning
void _showWarning(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: new Text(
          "질병주의",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.teal[400]),
        ),
        content: new Text("신장질환이 있는 환자는 반드시 의사와 상의할 것"),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "닫기",
              style: TextStyle(color: Colors.teal[200]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// add favorite list
void _question(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: new Text(
          "질병주의",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.teal[400]),
        ),
        content: new Text("신장질환이 있는 환자는 반드시 의사와 상의할 것"),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "닫기",
              style: TextStyle(color: Colors.teal[200]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// 카테고리전용 buttion
Widget _categoryButton(str) {
  return Container(
    width: 24 + str.length.toDouble() * 10,
    padding: EdgeInsets.symmetric(horizontal: 2),
    child: ButtonTheme(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      minWidth: 10,
      height: 22,
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

// tab 구현
Widget _myTab(BuildContext context, String drugItemSeq) {
  return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
            TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
            tabs: [
              Tab(child: Text('약 정보', style: TextStyle(color: Colors.black))),
              Tab(child: Text('리뷰', style: TextStyle(color: Colors.black))),
            ],
            indicatorColor: Colors.teal[400],
          ),
          //TODO: height 없이 괜찮게
          Container(
            padding: EdgeInsets.all(0.0),
            width: double.infinity,
            height: 6000.0,
            child: TabBarView(
//               여기에 은영학우님 page 넣기!
              children: [
                _underInfo(context, drugItemSeq),
                ReviewPage(drugItemSeq)
              ],
            ),
          )
        ],
      ));
}

//TODO: After controller data, I have to re-touch this widget
// 약의 자세한 정보들
Widget _underInfo(BuildContext context, String drugItemSeq) {
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '효능효과',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _drugInfo(context, drugItemSeq, 'EE'),
                  Container(
                    height: 10,
                  ),
                  Text(
                    '용법용량',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _drugInfo(context, drugItemSeq, 'UD'),
                  Container(
                    height: 10,
                  ),
                  Text(
                    '저장방법',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(drug.storageMethod),
                  Container(
                    height: 10,
                  ),
                  FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailInfo(
                                  drugItemSeq: drugItemSeq,
                                )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('자세히 보기'),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      )),
                ]
            ),
          );
        } else {
          return Loading();
        }
      });
}

// 약의 자세한 정보들
Widget _drugInfo(BuildContext context, String drugItemSeq, String type) {
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          // print("SUMI's TEST: ${specInfo.eeDataList}");
          if (type == 'EE') {
            return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: drug.eeDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.eeDocData[index].toString(),
                  );
                });
          } else if (type == 'NB') {
            return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: drug.nbDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.nbDocData[index].toString(),
                  );
                });
          } else if (type == 'UD') {
            return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: drug.udDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.udDocData[index].toString(),
                  );
                });
          } else {
            return Container();
          }
        } else {
          return Loading();
        }
      });
}