import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/services/review.dart';
import 'all_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'get_rating.dart';
import 'review_list.dart';

class ReviewPage extends StatefulWidget {
  String drugItemSeq;
  ReviewPage(this.drugItemSeq);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  _ReviewPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
//    <List<Review>> rev = Provider.of<List<Review>>(context);
//    final reviews = Provider.of<List<Review>>(context);
    return StreamProvider<List<Review>>.value(
      value: ReviewService().getReviews(widget.drugItemSeq),
      child: Scaffold(
        body:  Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height:10),
            GetRating(widget.drugItemSeq),
            Container(
              height: 4,
              color: Colors.grey[200],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //TODO EDIT num of reviews
                    Text("#",
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                        )),
                    InkWell(
                        child: Text('전체리뷰 보기',
                            style: TextStyle(
                              fontSize: 14.5,
                            )),
                        onTap: () {
                          //TODO GET ALL REVIEW
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => AllReview()));
                        }),
                  ],
                )),
            _searchBar(),
            ReviewList(_searchText)
          ],
        )
      )
    );
  }

  Widget _searchBar() {
    return Container(
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
    );
  }


}

//class Record {
//  final DocumentReference reference;
//  final String name;
//  final String effect;
//  final String sideEffect;
//  final String effectText;
//  final String sideEffectText;
//  final String overallText;
//  final String id;
//  List<String> favoriteSelected = List<String>();
//  final String uid;
//  final num starRating;
//  var noFavorite;
//
//  Record.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['name'] != null),
//        assert(map['effectText'] != null),
//        assert(map['sideEffectText'] != null),
//        assert(map['overallText'] != null),
//        assert(map['id'] != null),
//        assert(map['noFavorite'] != null),
//        assert(map['uid'] != null),
//
//        name = map['name'],
//        effectText = map['effectText'],
//        sideEffectText = map['sideEffectText'],
//        overallText = map['overallText'],
//        id = map['id'],
////        favoriteSelected = map['favoriteSelected'],
////        favoriteSelected = favoriteSelected.map((item){return item.toMap();}).toList(),
//        noFavorite = map['noFavorite'],
//        uid = map['uid'],
//        effect = map['effect'],
//        sideEffect = map['sideEffect'],
//        starRating = map['starRating'];
//
//  Record.fromSnapshot(DocumentSnapshot snapshot)
//      : this.fromMap(snapshot.data(), reference: snapshot.reference);
//}
