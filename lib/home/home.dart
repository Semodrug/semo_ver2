import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

int num ; // streambuilder 로 불러오기

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    Query user_drug = FirebaseFirestore.instance //user가 가지고 있는 약 data
        .collection('users')
    //.doc(_auth.currentUser.uid)
    //right now 1, i will changed after Login page complete
        .doc('1')
        .collection('savedList');
    print('user_drug == $user_drug');
    Future totalNum() async {
      var querySnapshot = await user_drug.getDocuments();
      var totalEquals = querySnapshot.docs.length;

      num = totalEquals;
      return totalEquals;
    }

    totalNum();

    Stream<QuerySnapshot> data = user_drug.snapshots();
    //print("data ==> $data");
    return Scaffold(
      body: _buildBody(context, data),
    );
  }

  Widget _buildBody(BuildContext context, Stream<QuerySnapshot> data) {
    return StreamBuilder<QuerySnapshot>(
      ///sumi
        stream: data,
        builder: (context, stream) {
          if (!stream.hasData) return LinearProgressIndicator();

          return _buildList(context, stream.data.docs);
        });

  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    print('snapshot == $snapshot');
    return Column(
      children: [
        SearchBar(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    print("in _buildListItem==> $data");
    String docID = data.id;
    print('    CHECK    == $docID ');

    //여기의 data.id == item sequence로 입니다.
    DocumentReference seq = FirebaseFirestore.instance
        .collection('users')
        .doc('docID');

    final drug = Drugs.fromSnapshot(data);//이건 실제 Drug의 data

    //print('docID ==> $drug');
    print('        ');

    return ListCards(
        drug.item_name, drug.image, drug.entp_name, drug.item_seq, drug.valid_term);
  }

}


class Drugs {

  final String item_name;
  final String image;
  final String entp_name;
  final String item_seq;
  final String valid_term;

  final DocumentReference reference;

  Drugs.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['ITEM_NAME'] != null),
        assert(map['ENTP_NAME'] != null),
        assert(map['ITEM_SEQ'] != null),
        item_name = map['ITEM_NAME'],
        image = map['image'],
        entp_name = map['ENTP_NAME'],
        item_seq = map['ITEM_SEQ'],
        valid_term = map['VALID_TERM'];

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
          width: 315,
          height: 33,
          padding: EdgeInsets.only(left: 20, right: 30),
          margin: EdgeInsets.fromLTRB(12, 11, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.grey[200],
          ),
          child: TextField(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (BuildContext context) => SearchScreen(),
//                ),
//              );
//            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(Icons.search, size: 20),
              hintText: "사람의 이름, 특징을 검색해보세요 ",
              //hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
              hintStyle: Theme.of(context).textTheme.bodyText2,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
            margin: EdgeInsets.only(top: 11),
            height: 33,
            width: 65,
            child: FlatButton(
              child: Text('확인', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {},
            ))
      ],
    );
  }
}

class ListCards extends StatefulWidget {

  final String item_name;
  final String image;
  final String entp_name;
  final String item_seq;
  final String valid_term;


  const ListCards(
      this.item_name,
      this.image,
      this.entp_name,
      this.item_seq,
      this.valid_term, {
        Key key,
      }) : super(key: key);

  @override
  _ListCardsState createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 390,
        height: 110,
        child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    width: 84,
                    height: 84,
                    child: Image.network(widget.image),
                  ),

                )
              ],
            )));
  }
}
