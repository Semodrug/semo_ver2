import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'review_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final String auth_id = _auth.currentUser.uid;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
        print('       filter == ${_filter.text}');
      });
    });
  }



  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
      } else
        print('    RESULT Nothing     ');
    }
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children:
        searchResults.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _starAndIdAndMore(record, context, auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.grey[300], size: 16),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(record.id, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            SizedBox(width: 145),
            IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.grey[700], size: 19),
              onPressed: () {
                //TODO : It doesn't working
                print("auth.currentUser.uid: " + auth.currentUser.uid);
                print("record.uid: " + record.uid);
                if(auth.currentUser.uid == record.uid) {
//                  showModalBottomSheet(
//                      context: context,
//                      builder: buildBottomSheetWriter);
                }
                else if(auth.currentUser.uid != record.uid) {
//                  showModalBottomSheet(
//                      context: context,
//                      builder: buildBottomSheetAnonymous);
                }
              },
            )
          ],
        ),
      ],
    );
  }


  Widget _review(record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey[400], width: 1.0),
                    borderRadius:
                    BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("효과", style: TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                    Padding(padding: EdgeInsets.all(2.5)),
                    //Container(width: size.width * 0.015),
                    Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          //TODO: COlor: Based on effect color
                            color: record.effect == "soso" ? Color(0xffFFDD66) : record.effect == "bad" ? Color(0xffFF7070) : Color(0xff88F0BE),
                            shape: BoxShape.circle)),
                  ],
                )),
            //Container(width: size.width * 0.025),
            Padding(padding: EdgeInsets.all(5)),
            Text(record.effectText, style: TextStyle(fontSize: 17.0)),
          ],
        ),

        Padding(padding: EdgeInsets.only(top: 6.0)),
        Row(
          children: <Widget>[
            Container(
                height: 28,
                width: 80,
                //width: 5, height: 5,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey[400], width: 1.0),
                    borderRadius:
                    BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("부작용", style: TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                    Padding(padding: EdgeInsets.all(2.5)),
                    Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                            color: record.sideEffect == "yes"? Color(0xffFF7070) : Color(0xff88F0BE),
//                            color: Colors.redAccent[100],
                            shape: BoxShape.circle)),
                  ],
                )),
            Padding(padding: EdgeInsets.all(5)),
            Text(record.sideEffectText, style: TextStyle(fontSize: 17.0)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 6.0)),

        Row(
          children: <Widget>[
            Container(
                height: 25,
                width: 45,
                //width: 5, height: 5,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey[400], width: 1.0),
                    borderRadius:
                    BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("총평", style: TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                  ],
                )),
            Padding(padding: EdgeInsets.all(5)),
            Text(record.overallText, style: TextStyle(fontSize: 17.0)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 6.0)),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(data["favoriteSelected"]);
    String docID = data.id;
    //print(docID);

    return Container(
//                      key: ValueKey(record.name),
//        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.6, color: Colors.grey[300]))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _starAndIdAndMore(record, context, auth),
              _review(record),
              //Container(height: size.height * 0.01),
//              _dateAndLike(record),
              Row(
                children: <Widget>[
                  //Container(height: size.height * 0.05),
                  Text("2020.08.11",
                      style: TextStyle(color: Colors.grey[500], fontSize: 13)),
//        Container(width: size.width * 0.63),
                  Padding(padding: EdgeInsets.all(18)),
                  Padding(padding: EdgeInsets.only(left: 235)),
                  Container(
                    //width: 500.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new GestureDetector(
                            child: new Icon(
                              names.contains(auth.currentUser.uid) ? Icons.favorite
                                  : Icons.favorite_border,
//                                            color: names.contains(auth.currentUser.uid) ?
//                                                Colors.redAccent[200] : Colors.grey[300],
                              color: Colors.redAccent[200],
                              size: 21,
                            ),
                            //when 2 people click this
                            onTap:() {
//                                            List<String> names = List.from(data["favoriteSelected"]);
                              if(names.contains(auth.currentUser.uid)) {
                                print("UID: "+auth.currentUser.uid);
                                record.reference.update({
                                  'favoriteSelected': FieldValue.arrayRemove([auth.currentUser.uid]),
                                  'noFavorite': FieldValue.increment(-1),
                                });
                              }
                              else {
                                record.reference.update({
                                  'favoriteSelected': FieldValue.arrayUnion([auth.currentUser.uid]),
                                  'noFavorite': FieldValue.increment(1),
                                });
                              }
                            }
                        )
                      ],
                    ),
                  ),
                  Text((record.noFavorite).toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
//        padding: EdgeInsets.fromLTRB(20, 5, 20, 7),
        child: Column(
          children: [
            //Padding(padding: EdgeInsets.all(30)),
            Container(
              width: 370,
              height: 45,
              //padding: EdgeInsets.only(top: 3,),
              margin: EdgeInsets.fromLTRB(0, 11, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextField(
                        focusNode: focusNode,
                        style: TextStyle(fontSize: 15),
                        autofocus: true,
                        controller: _filter,
                        decoration: InputDecoration(
                            fillColor: Colors.white12,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 20,
                            ),
                            suffixIcon: focusNode.hasFocus
                                ? IconButton(
                              icon: Icon(Icons.cancel, size: 20),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                });
                              },
                            )
                                : Container(),
                            hintText: '검색',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                BorderSide(color: Colors.transparent))),
                      )),
                  focusNode.hasFocus
                      ? Expanded(
                    child: FlatButton(
                      child: Text(
                        'clear',
                        style: TextStyle(fontSize: 13),
                      ),
                      onPressed: () {
                        setState(() {
                          _filter.clear();
                          _searchText = "";
                          focusNode.unfocus();
                        });
                      },
                    ),
                  )
                      : Expanded(
                    flex: 0,
                    child: Container(),
                  )
                ],
              ),
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }
}
