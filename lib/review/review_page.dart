import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'all_review.dart';
import 'write_review.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  List<PieChartSectionData> _sections = [
    PieChartSectionData(
    color: Color(0xff88F0BE),
    value: 40,
//    title: 'Food',
    radius: 20,
    titleStyle: TextStyle(color: Colors.white, fontSize:12),
    ),
    PieChartSectionData(
      color: Color(0xffFED74D),
      value: 40,
//      title: 'Food',
      radius: 20,
      titleStyle: TextStyle(color: Colors.white, fontSize:12),
    ),
    PieChartSectionData(
      color: Color(0xffFF7070),
      value: 20,
//      title: 'Food',
      radius: 20,
      titleStyle: TextStyle(color: Colors.white, fontSize:12),
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: topOfReview(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          backgroundColor: Colors.teal[300],
          elevation: 0.0,
          onPressed: () {
//            rating();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WriteReview()
                ));
          }
      ),
    );
  }

  Widget _rating() {
    FirebaseFirestore.instance
        .collection('Reviews')
        .get()
        .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["starRating"]);
    });
    });
  }

  Widget _pieChart(String text) {
    return  Column(
      children: [
        Text(text),
        Container(
          width: 110,
          height: 110,
          child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: _sections,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 20,
                  sectionsSpace: 3,
                ),
              )
          ),
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
                            color: Colors.green[200],
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
                            color: Colors.redAccent[100],
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

  Widget _tapToRate() {
    return RatingBar.builder(
      initialRating:3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 30,
      glow: false,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Widget _searchBar() {
    return //TODO: Bring SEARCH FUNCTION & show review according to search keyword
      Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.grey[200],
        ),
        child: TextField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            icon: Icon(Icons.search, size: 30),
            hintText: "어떤 리뷰를 찾고계세요?",
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
//                        filled: true,
//                        fillColor: Colors.white
            //contentPadding: EdgeInsets.only(left: 5)
          ),
        ),
      );
  }

  Widget _totalRating() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("총 평점",
                style: TextStyle(
                    fontSize: 16.5, fontWeight: FontWeight.bold)),
            //Container(height: size.height * 0.02),
            Padding(padding: EdgeInsets.only(top: 14.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.star, color: Colors.amber[300], size: 35),
                //Todo : Rating
                Text("4.26", style: TextStyle(fontSize: 35)),
                Text("/5",
                    style: TextStyle(
                        fontSize: 20, color: Colors.grey[500])),
                SizedBox(
                    width:30
                ),
                _pieChart("효과"),
                _pieChart("부작용"),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 14.0)),
            Text("탭해서 평가하기",
                style: TextStyle(
                    fontSize: 14.0, color: Colors.grey[700])),
            Padding(padding: EdgeInsets.only(top: 7.0)),
            _tapToRate()
          ],
        ));
  }


  Widget topOfReview(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height:10),
        _totalRating(),
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
                Text('리뷰 360개',
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllReview()));
                    }),
              ],
            )),
        _searchBar(),
        Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                    BorderSide(width: 0.6, color: Colors.grey[300]))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //_starAndId(size),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                  //_reviewSideEffect(size, _sideEffectColor),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                  //_reviewOverall(size),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                  Padding(padding: EdgeInsets.only(top: 7.0)),
                  //_dateAndLike(size),
                ])),
        Expanded(
//            height: 400,
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("Reviews").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Text("Error: ${snapshot.error}");
              if (!snapshot.hasData)
                return LinearProgressIndicator();
              return Column(
//                primary: false,
//                shrinkWrap: true,
//                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data.documents.map((DocumentSnapshot data) {
                  final record = Record.fromSnapshot(data);
                  List<String> names = List.from(data["favoriteSelected"]);
                  return Container(
//                      key: ValueKey(record.name),
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                }).toList(),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildBottomSheetWriter(BuildContext context) {
    return SizedBox(
        child: Container(
//                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  print("A");
                },
                child: Center(child: Text("수정하기",
                    style: TextStyle(color: Colors.blue[700],
                    fontSize: 16)))
              ),
              MaterialButton(
                  onPressed: () {
                    print("A");
                  },
                  child: Center(child: Text("삭제하기",
                      style: TextStyle(color: Colors.red[600],
                      fontSize: 16)))
              )
            ],
          )
        )
    );
  }

  Widget buildBottomSheetAnonymous(BuildContext context) {
    return SizedBox(
        child: Container(
//                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: <Widget>[
                MaterialButton(
                    onPressed: () {

                    },
                    child: Center(child: Text("신고하기,",
                        style: TextStyle(color: Colors.blue[700],
                            fontSize: 16)))
                ),
                MaterialButton(
                    onPressed: () {
                      print("A");
                    },
                    child: Center(child: Text("취소,",
                        style: TextStyle(color: Colors.blue[700],
                            fontSize: 16)))
                ),
              ],
            )
        )
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
                  showModalBottomSheet(
                      context: context,
                      builder: buildBottomSheetWriter);
                }
                else if(auth.currentUser.uid != record.uid) {
                  showModalBottomSheet(
                      context: context,
                      builder: buildBottomSheetAnonymous);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}

class Record {
  final DocumentReference reference;

  final String name;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  final String id;
  List<String> favoriteSelected = List<String>();
  final String uid;
  var noFavorite;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['effectText'] != null),
        assert(map['sideEffectText'] != null),
        assert(map['overallText'] != null),
        assert(map['id'] != null),
        assert(map['noFavorite'] != null),
        assert(map['uid'] != null),

        name = map['name'],
        effectText = map['effectText'],
        sideEffectText = map['sideEffectText'],
        overallText = map['overallText'],
        id = map['id'],
//        favoriteSelected = map['favoriteSelected'],
//        favoriteSelected = favoriteSelected.map((item){return item.toMap();}).toList(),
        noFavorite = map['noFavorite'],
        uid = map['uid'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

