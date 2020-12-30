import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/mypage/my_page.dart';
import 'search_screen.dart';

import 'home_add_button_stack.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

int num; // streambuilder 로 불러오기
int compare;
String check = 'defalut'; //check for docID

class HomeEditPage extends StatefulWidget {
  @override
  _HomeEditPageState createState() => _HomeEditPageState();
}

class _HomeEditPageState extends State<HomeEditPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference user_drug =
        FirebaseFirestore.instance //user가 가지고 있는 약 data
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('savedList');

    Future totalNum() async {
      var querySnapshot = await user_drug.getDocuments();
      var totalEquals = querySnapshot.docs.length;

      num = totalEquals;
      return totalEquals;
    }

    totalNum();

    Stream<QuerySnapshot> data = user_drug.snapshots();
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          '이약모약',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.teal[200],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            ),
          ),
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
      body: _buildBody(context, data),
    );
  }

  Widget _buildBody(BuildContext context, Stream<QuerySnapshot> data) {
    return StreamBuilder<QuerySnapshot>(
        stream: data,
        builder: (context, stream) {
          if (!stream.hasData) return LinearProgressIndicator();

          return _buildList(context, stream.data.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    compare = 0;
    return Column(
      children: [
        SearchBar(),
        Container(
          margin: EdgeInsets.only(left: 19, top: 6, bottom: 2),
          child: Row(
            children: <Widget>[
              Text('나의 상비약'), // theme 추가
              ButtonTheme(
                //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                height: 10,
                minWidth: 20,
                child: FlatButton(
                  child: Text(
                    num.toString(),
                    style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
                  ),
                ),
              ),
              SizedBox(
                width: 180,
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
        ButtonTheme(
          padding: EdgeInsets.fromLTRB(50, 0, 5, 15),
          minWidth: 340.0,
          height: 70.0,
          //buttonColor: Colors.redAccent,
          child: RaisedButton.icon(
            color: Colors.white70,
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddButton()));
            },
            padding: EdgeInsets.fromLTRB(20, 5, 5, 15),
            label: Container(
              width: 340,
              padding: const EdgeInsets.all(10.0),
              child: const Text('상비약 추가하기'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    String docID = data.id;

    CollectionReference drug = FirebaseFirestore.instance.collection('drug');

    return FutureBuilder<DocumentSnapshot>(
      //user의 savedList안에 있는 애들과 실제 약 데이터 매치하여 약에 대한 정보를 받아오는 부분
      future: drug.doc(docID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final drug_snapshot = Drugs.fromSnapshot(snapshot.data);
          print('Snapshot Data ==> ${snapshot.data}');
          print(drug_snapshot.reference.id); //this is item seq num

          final drugFromUser = DrugFromUser.fromSnapshot(data);
          return Column(
            children: [
              ListCards(
                  //drug_snapshot.reference,
                  drug_snapshot.item_name,
                  drug_snapshot.image,
                  drug_snapshot.entp_name,
                  drug_snapshot.item_seq,
                  drug_snapshot.valid_term,
                  drug_snapshot.category,
                  drugFromUser.expiration),
              Divider(
                thickness: 1,
              )
            ],
          );
        }
        return Text("loading");
      },
    );
  }
}

class DrugFromUser {
  final String item_seq;
  final String expiration;

  final DocumentReference reference;

  DrugFromUser.fromMap(Map<String, dynamic> map, {this.reference})
      :
        //assert(map['expiration'] != null),
        item_seq = map['ITEM_SEQ'],
        expiration = map['expiration'];

  DrugFromUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Drugs {
  final String item_name;
  final String image;
  final String entp_name;
  final String item_seq;
  final String valid_term;
  final String category;

  final DocumentReference reference;

  Drugs.fromMap(Map<String, dynamic> map, {this.reference})
      :
        //assert(map['ITEM_NAME'] != null),
        //assert(map['ENTP_NAME'] != null),
        //assert(map['ITEM_SEQ'] != null),
        item_name = map['ITEM_NAME'],
        image = map['image'],
        entp_name = map['ENTP_NAME'],
        item_seq = map['ITEM_SEQ'],
        valid_term = map['VALID_TERM'],
        category = map['category'];

  Drugs.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    //이 search bar에서 바로 검색을 하게 할 것인가?
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: 10,
          ),
          margin: EdgeInsets.fromLTRB(0, 11, 0, 0),
          child: SizedBox(
              width: 390,
              height: 35,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search, size: 20),
                    Text("어떤 약을 찾고 계세요? "),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchScreen(),
                    ),
                  );
                },
                textColor: Colors.grey[500],
                color: Colors.grey[200],
                shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 1.0,
                        color: Colors.white),
                    borderRadius: new BorderRadius.circular(8.0)),
              )),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class ListCards extends StatefulWidget {
  //final String ref;
  final String item_name;
  final String image;
  final String entp_name;
  final String item_seq;
  final String valid_term;
  final String category;
  final String expiration;

  const ListCards(
    //this.ref,
    this.item_name,
    this.image,
    this.entp_name,
    this.item_seq,
    this.valid_term,
    this.category,
    this.expiration, {
    Key key,
  }) : super(key: key);

  @override
  _ListCardsState createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 100.0,
        child: Material(
            color: Colors.white,
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                        child: Image.network(widget.image)),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 20, 0, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                widget.item_name,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),

                            ]),
                            Expanded(
                                child: Row(
                                  children: [_categoryButton((widget.category))],
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Expanded(
                              child: Text(
                                widget.expiration,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            )
                          ],
                        )),
                  ],
                ),

                //Stack(
                  //children: [
                            Positioned(
                              top: 5,
                              right: 20,
                              width: 20,
                             height: 30,
                             // top: 0,                             // right: 0,
                                child: Align(
                                  //alignment: Alignment.centerRight,
                                  child: IconButton(
                                    padding: EdgeInsets.all(2.0),
                                    icon:
                                      Icon(
                                        Icons.cancel, size: 20
                                       ),
                                    onPressed: () {
                                      askDeleteAlert(context);                                  },
                                  ),
                                ),
                              ),

                          //),
                  //]
                //)
              ],
            )),
      ),
    );
  }

  void askDeleteAlert (BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('나의 상비약 목록에서 지우시겠습니까?'),
          content: Text("나의 상비약 목록에서 지우시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');

                      FirebaseFirestore.instance //user가 가지고 있는 약 data
                          .collection('users')
                          .doc(_auth.currentUser.uid)
                          .collection('savedList')
                          .doc(widget.item_seq)
                          .delete();
                      },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');
              },
            ),
          ],
        );
      },
    );
  }


  Widget _categoryButton(str) {
    return Container(
      width: 24 + str.length.toDouble() * 10,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: ButtonTheme(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        minWidth: 10,
        height: 22,
        child: RaisedButton(
          child: Text(
            '#$str',
            style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
          ),
          onPressed: () => print('$str!'),
          color: Colors.white,
        ),
      ),
    );
  }
}