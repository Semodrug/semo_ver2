import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'review_page.dart';

final fireInstance = Firestore.instance;

class PhilInfoPage extends StatefulWidget {
  String drug_item_seq;//추가

  PhilInfoPage({Key key, @required this.drug_item_seq}) : super(key: key);//약의 item seq받아오

  @override
  _PhilInfoPageState createState() => _PhilInfoPageState();
}

class _PhilInfoPageState extends State<PhilInfoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text(
//            '약정보',
//            style: TextStyle(
//                color: Colors.black, letterSpacing: 2.0, fontSize: 18),
//          ),
//          centerTitle: true,
//          backgroundColor: Colors.white,
//          elevation: 1.0,
////          leading: Icon(
////            Icons.arrow_back,
////            color: Colors.teal[400],
////          ),
//          actions: [
//            IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () => {},
//              color: Colors.teal[400],
//            ),
//          ],
//        ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                child: _topInfo(context),
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
              child: _myTab(),
            )
          ],
        )
    );
  }
}

/* 약 이름, 회사 등 위쪽에 위치한 정보들 */
Widget _topInfo(context) {
  return StreamBuilder(
      stream: fireInstance.collection('drug').snapshots(),
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
                  snapshot.data.documents[0]['ENTP_NAME'],
                  //'동아제약',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  snapshot.data.documents[0]['ITEM_NAME'],
//                  '타이레놀',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                Row(children: <Widget>[
                  Text(
                    '4.5',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' (305개)',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  _categoryButton('두통'),
                  _categoryButton('치통'),
                  _categoryButton('생리통'),
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
Widget _myTab() {
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
          Container(
            padding: EdgeInsets.all(0.0),
            width: double.infinity,
            height: 500.0,
            child: TabBarView(
              /* 여기에 은영학우님 page 넣기! */
              children: [_specificInfo(), ReviewPage()],
            ),
          )
        ],
      ));
}

/* 약의 자세한 정보들 */
Widget _specificInfo() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
    child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        "효능효과",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "1. 주효능효과\n감기로 인한 발열 및 통증, 두통, 신경통, 근육통, 월경통, 염좌통",
      ),
      Text(
        "2. 다음 질환에도 사용할 수 있다.\n치통, 관절통, 류마티양 통증",
      ),
      SizedBox(
        child: Divider(color: Colors.grey),
      ),
      Text(
        "용법용량",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "1회 400g",
      ),
      SizedBox(
        child: Divider(color: Colors.grey),
      ),
      Text(
        "복약정보",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "- 충분한 물과 함께 투여하세요.\n- 정기적으로 술을 마시는 사람은 이 약을 투여하기 전 반드시 전문가와 상의하세요",
      ),
      Text(
        "- 황달 등 간기능 이상징후가 나타날 경우에는 전문가와 상의하세요.\n- 전문가와 상의없이 다른 소염진통제와 병용하지 마세요.",
      )
    ]),
  );
}
