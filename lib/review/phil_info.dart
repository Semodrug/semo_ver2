import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'review_page.dart';
import 'write_review.dart';
import 'durg_provider.dart';

final fireInstance = FirebaseFirestore.instance;

// TODO: drug도 provider 필요!!!
// TODO: appbar 통일. 한군데 있는 거 계속 불러오게? fontsize: 16
// TODO: image

class PhilInfoPage extends StatefulWidget {
  final String drugItemSeq; //추가

  PhilInfoPage({Key key, @required this.drugItemSeq})
      : super(key: key); //약의 item seq 받아

  @override
  _PhilInfoPageState createState() => _PhilInfoPageState();
}

class _PhilInfoPageState extends State<PhilInfoPage> {
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
                  MaterialPageRoute(builder: (context) => WriteReview()));
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
            /* FROM HERE: TAB */
            SliverToBoxAdapter(
              child: _myTab(context, widget.drugItemSeq),
            )
          ],
        ));
  }
}

/* 약 이름, 회사 등 위쪽에 위치한 정보들 */
Widget _topInfo(
  BuildContext context,
  String drugItemSeq,
) {
  return StreamBuilder(
      stream: fireInstance.collection('drug').doc(drugItemSeq).snapshots(),
      builder: (context, snapshot) {
        return Stack(children: [
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
                    Icons.favorite_border,
                    //alreadySaved ? Icons.favorite : Icons.favorite_border,
                    //              //color: alreadySaved ? Colors.redAccent : null,
                  ),
                  onPressed: () => print('좋아요!'))),
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
                onPressed: () => print('보관함 추가!'),
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    child: Image.asset('images/01.png'),
                    width: 200.0,
                    height: 100.0,
                  ),
                ),
                Text(
                  snapshot.data['ENTP_NAME'],
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  snapshot.data['ITEM_NAME'],
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
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  // TODO: firebase connection
                  Text(
                    ' (305개)',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  _categoryButton(snapshot.data['category'])
                ]),
              ]),
        ]);
      });
}

/* warning */
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

/* add favorite list */
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

/* 카테고리전용 buttion*/
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

/* tab 구현 */
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
              /* 여기에 은영학우님 page 넣기! */
              children: [_specificInfo(context, drugItemSeq), ReviewPage()],
            ),
          )
        ],
      ));
}

//TODO:
/* 약의 자세한 정보들 */
Widget _specificInfo(BuildContext context, String drugItemSeq) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
    child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        '효능효과',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      _drugInfo(context, drugItemSeq, 'EE_DOC_DATA'),
      Container(
        height: 10,
      ),
      Text(
        '용법용량',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      _drugInfo(context, drugItemSeq, 'UD_DOC_DATA'),
      Container(
        height: 10,
      ),
      Text(
        '주의사항',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      _drugInfo(context, drugItemSeq, 'NB_DOC_DATA'),
      Container(
        height: 10,
      ),
    ]),
  );
}

Widget _drugInfo(BuildContext context, String drugItemSeq, String docName) {
  // String name;
  //
  // if (docName == 'EE_DOC_DATA')
  //   name = '효능효과';
  // else if (docName == 'NB_DOC_DATA')
  //   name = '주의사항';
  // else if (docName == 'UD_DOC_DATA') name = '용법용량';

  //TODO: The method '[]' was called on null. error 해결하기
  return StreamBuilder(
      stream: fireInstance
          .collection('drug')
          .doc(drugItemSeq)
          .collection('DOCS')
          .doc(docName)
          .snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data['paragraph'].length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                snapshot.data['paragraph'][index].toString(),
              );
            });
      });
}
