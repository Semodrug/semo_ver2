import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'all_review.dart';
import 'edit_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/services/review.dart';
import 'get_rating.dart';
import 'review_list.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  _ReviewPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
        print('       filter == ${_filter.text}');
      });
    });
  }

  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Review>>.value(
      value: ReviewService().reviews,
      child: Scaffold(
//        body: topOfReview(context),
//TODO Save reviewList()
//        body: ReviewList()
//          body: GetRating()

      //below is top of review
        body:  Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height:10),
            GetRating(),
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
  //TODO: save _searchBar()
          _searchBar(),
            ReviewList(_searchText)
  //        _buildBody(context)
          ],
        )

      )
    );
  }
//    return Scaffold(
//      body: topOfReview(context),
//    );


/*  Widget _effectPieChart(good, soso, bad) {
    double sum = (good+soso+bad)*1.0;
    double effectGood = (good/sum)*100;
    double effectSoso = (soso/sum)*100;
    double effectBad = (bad/sum)*100;
    return  Container(
      width: 110,
      height: 110,
      child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
//              sections: val == "effect" ? _effectChart : _sideEffectChart,
              sections: [
                if(good != 0)
                PieChartSectionData(
                  color: green,
                  value: effectGood,
                  title: 'good',
                  radius: 20,
                  titleStyle: TextStyle(color: Colors.white, fontSize:12),
                ),
                if(soso != 0)
                PieChartSectionData(
                  color: yellow,
                  value: effectSoso,
                  title: 'soso',
                  radius: 20,
                  titleStyle: TextStyle(color: Colors.white, fontSize:12),
                ),
                if(bad != 0)
                PieChartSectionData(
                  color: red,
                  value: effectBad,
                  title: 'bad',
                  radius: 20,
                  titleStyle: TextStyle(color: Colors.white, fontSize:12),
                )
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 20,
              sectionsSpace: 1,
            ),
          )
      ),
    );
  }
  Widget _sideEffectPieChart(yes, no) {
    double sum = (yes + no)*1.0;
    double sideEffectYes = (yes/sum)*100;
    double sideEffectNo = (no/sum)*100;
    return  Container(
      width: 110,
      height: 110,
      child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
//              sections: val == "effect" ? _effectChart : _sideEffectChart,
              sections: [
                if(sideEffectYes != 0)
                  PieChartSectionData(
                    color: red,
                    value: sideEffectYes,
                    title: 'Yes',
                    radius: 20,
                    titleStyle: TextStyle(color: Colors.white, fontSize:12),
                  ),
                if(sideEffectNo != 0)
                  PieChartSectionData(
                    color: green,
                    value: sideEffectNo,
                    title: 'No',
                    radius: 20,
                    titleStyle: TextStyle(color: Colors.white, fontSize:12),
                  ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 20,
              sectionsSpace: 1,
            ),
          )
      ),
    );
  }*/

/*  Widget _totalRating() {
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
            _rate(context),
            Padding(padding: EdgeInsets.only(top: 14.0)),
            Text("탭해서 평가하기",
                style: TextStyle(
                    fontSize: 14.0, color: Colors.grey[700])),
            Padding(padding: EdgeInsets.only(top: 7.0)),
            _tapToRate()
          ],
        ));
  }*/

/*  Widget _tapToRate() {
    return RatingBar.builder(
      initialRating:3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 30,
      glow: false,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      unratedColor: Colors.grey[300],
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
      onRatingUpdate: (rating) {
        //TODO: add rating!!!!!!!!!!!!!!!!!!!!!!!!
//        _showMyDialog();
      },
    );
  }*/

/*  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Icon(Icons.star, size: 30, color: Colors.amberAccent)),
                SizedBox(height: 5),
                Center(child: Text('별점이 반영되었습니다.', style: TextStyle(color: Colors.black45, fontSize: 14))),
                SizedBox(height: 20),
                Center(child: Text('리뷰 작성도 이어서 할까요?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('확인', style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        //TODO: GOTO Edit Review
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
  }*/

  Widget _review(record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //effect
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

        SizedBox(height:13),

        //side effect
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
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


        SizedBox(height:13),
        Row(
          children: <Widget>[
            Container(
                height: 25,
                width: 45,
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


/*  Widget topOfReview(BuildContext context) {
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
//TODO: save _searchBar()
//        _searchBar(),
//        _buildBody(context)
      ],
    );
  }*/


  //BuildContext context, List<DocumentSnapshot> snapshot
  Widget _rate(BuildContext context) {
    num sum = 0;
    int length = 0;
    num ratingResult = 0;
    int effectGood = 0;
    int effectSoso = 0;
    int effectBad = 0;
    int sideEffectYes = 0;
    int sideEffectNo = 0;

    GetRating();



//    Stream<List<Review>> get reviews {
//      return FirebaseFirestore.instance.collection('Reviews').snapshots()
//          .map(_reviewListFromSnapshot);
//    }

    //TODO: CHANGE into provider
    /*return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Loading");

        length = snapshot.data.documents.length;
//        snapshot.data.documents.map((DocumentSnapshot document) {
//           sum += document.data()['starRating'];
//        });

        snapshot.data.docs.forEach((doc) {
          sum += doc["starRating"];
        });
        ratingResult = sum/length;
        print(ratingResult);


        snapshot.data.docs.forEach((doc) {
          doc["effect"] == "good" ? effectGood++ :
          doc["effect"] == "soso" ? effectSoso++ : effectBad ++;
        });

        snapshot.data.docs.forEach((doc) {
          doc["sideEffect"] == "yes" ? sideEffectYes++ : sideEffectNo++;
        });

        return
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.star, color: Colors.amber[300], size: 35),
              //Todo : Rating
              Text(ratingResult.toStringAsFixed(1), style: TextStyle(fontSize: 35)),
              Text("/5",
                  style: TextStyle(
                      fontSize: 20, color: Colors.grey[500])),
              SizedBox(
                  width:30
              ),
              //pie chart
              Column(
                children: [
                  Text("효과"),
                  _effectPieChart(effectGood, effectSoso, effectBad),
                ],
              ),
              Column(
                children: [
                  Text("부작용"),
                  _sideEffectPieChart(sideEffectYes, sideEffectNo),
                ],
              ),

            ],
          );
      },
    );*/
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
        physics: const ClampingScrollPhysics(),
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        children:
        searchResults.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(data["favoriteSelected"]);
    String docID = data.id;
    //print(docID);

    return Container(
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

/*  Widget _starAndIdAndMore(record, context, auth) {
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
  }*/

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

  Widget buildBottomSheetWriter(BuildContext context, record) {
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
                    _showDeleteDialog(record);
                  },
                  child: Center(child: Text("취소",
                      style: TextStyle(color: Colors.red[600],
                      fontSize: 16)))
              ),
            ],
          )
        )
    );
  }

  Future<void> _showDeleteDialog(record) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Center(child: Text('AlertDialog Title')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('삭제',style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        record.reference.delete();
                        Navigator.of(context).pop();
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
          children: <Widget>[
            RatingBar.builder(
              initialRating: record.starRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 14,
              glow: false,
              itemPadding: EdgeInsets.symmetric(horizontal: 0),
              unratedColor: Colors.grey[300],
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amberAccent,
              ),
            ),

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
                      builder: (BuildContext context) {
                        return SizedBox(
                            child: Container(
//                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Wrap(
                                  children: <Widget>[
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => EditReview(record)
                                          ));
                                        },
                                        child: Center(child: Text("수정하기",
                                            style: TextStyle(color: Colors.blue[700],
                                                fontSize: 16)))
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          _showDeleteDialog(record);
                                        },
                                        child: Center(child: Text("삭제하기",
                                            style: TextStyle(color: Colors.red[600],
                                                fontSize: 16)))
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(child: Text("취소",
                                            style: TextStyle(color: Colors.grey[600],
                                                fontSize: 16)))
                                    )
                                  ],
                                )
                            )
                        );
                      });
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
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  final String id;
  List<String> favoriteSelected = List<String>();
  final String uid;
  final num starRating;
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
        uid = map['uid'],
        effect = map['effect'],
        sideEffect = map['sideEffect'],
        starRating = map['starRating'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}