import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'review_page.dart';
import 'write_review.dart';


class AllReview extends StatefulWidget {
  @override
  _AllReveiewState createState() => _AllReveiewState();
}

class _AllReveiewState extends State<AllReview> {
  var index = 8;
  int _counter = 0;
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _appbar(context),
      body: topOfReview(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          backgroundColor: Colors.teal[300],
          elevation: 0.0,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WriteReview()));
          }),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      title: Text('약이름',
          style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
//      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.teal[300]),
//          onPressed: () {
//            Navigator.pop(
//                context,
//                MaterialPageRoute(builder: (context) => MyStatefulWidget()
////                    builder: (context) => MyApp()
//                ));
//          }
      ),
      actions: <Widget>[],
    );
  }

  /*Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        }
    );
  }*/

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Container(
        key: ValueKey(record.name),
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _starAndId(record, context),
              Column(
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
                              Text("효과",
                                  style: TextStyle(
                                      fontSize: 14.5, color: Colors.grey[600])),
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
                              Text("부작용",
                                  style: TextStyle(
                                      fontSize: 14.5, color: Colors.grey[600])),
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
                              Text("총평",
                                  style: TextStyle(
                                      fontSize: 14.5, color: Colors.grey[600])),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(record.overallText, style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                ],
              ),
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
                              Icons.favorite,
                              //color: _rating >= 1 ? Colors.orange : Colors.grey,
                              color: record.favoriteSelected == true
                                  ? Colors.redAccent[200]
                                  : Colors.grey[300],
                              size: 21,
                            ),
                            //when 2 people click this
                            onTap: () => record.reference.updateData({
                              'noFavorite': FieldValue.increment(1),
                              //TODO removed next one line
//                              'favoriteSelected': !record.favoriteSelected,
                            })
                          /*//                          onTap: () => Firestore.instance.runTransaction((transaction) async {
//                            final freshSnapshot = await transaction.get(record.reference);
//                            final fresh = Record.fromSnapshot(freshSnapshot);
//                            await transaction.update(record.reference, {'votes': fresh.votes + 1});
//                          }),
*/
                        )
                      ],
                    ),
                  ),
                  Text((record.noFavorite).toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black)),
//            Text("309", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              )
            ]));
  }

  Widget topOfReview(BuildContext context) {
    int _effectColor;
    int _sideEffectColor;

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("Reviews").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              if (!snapshot.hasData) return LinearProgressIndicator();
              return ListView(
//                        scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map((DocumentSnapshot data) {
                  final record = Record.fromSnapshot(data);
//                        Timestamp tt = document["datetime"];
//                        DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
//                            tt.microsecondsSinceEpoch);

                  return Container(
                      key: ValueKey(record.name),
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.6, color: Colors.grey[300]))),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _starAndId(record, context),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        height: 28,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[400],
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("효과",
                                                style: TextStyle(
                                                    fontSize: 14.5,
                                                    color: Colors.grey[600])),
                                            Padding(
                                                padding: EdgeInsets.all(2.5)),
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
                                    Text(record.effectText,
                                        style: TextStyle(fontSize: 17.0)),
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
                                                color: Colors.grey[400],
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("부작용",
                                                style: TextStyle(
                                                    fontSize: 14.5,
                                                    color: Colors.grey[600])),
                                            Padding(
                                                padding: EdgeInsets.all(2.5)),
                                            Container(
                                                width: 17,
                                                height: 17,
                                                decoration: BoxDecoration(
                                                    color:
                                                    Colors.redAccent[100],
                                                    shape: BoxShape.circle)),
                                          ],
                                        )),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(record.sideEffectText,
                                        style: TextStyle(fontSize: 17.0)),
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
                                                color: Colors.grey[400],
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("총평",
                                                style: TextStyle(
                                                    fontSize: 14.5,
                                                    color: Colors.grey[600])),
                                          ],
                                        )),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(record.overallText,
                                        style: TextStyle(fontSize: 17.0)),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 6.0)),
                              ],
                            ),
                            //Container(height: size.height * 0.01),
//              _dateAndLike(record),
                            Row(
                              children: <Widget>[
                                //Container(height: size.height * 0.05),
                                Text("2020.08.11",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 13)),
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
                                            Icons.favorite,
                                            //color: _rating >= 1 ? Colors.orange : Colors.grey,
                                            color:
                                            record.favoriteSelected == true
                                                ? Colors.redAccent[200]
                                                : Colors.grey[300],
                                            size: 21,
                                          ),
                                          //when 2 people click this
                                          onTap: () =>
                                              record.reference.updateData({
                                                'noFavorite':
                                                FieldValue.increment(1),
                                                    //Todo removed next two lines
//                                                'favoriteSelected':
//                                                !record.favoriteSelected,
                                              })
                                        /*//                          onTap: () => Firestore.instance.runTransaction((transaction) async {
//                            final freshSnapshot = await transaction.get(record.reference);
//                            final fresh = Record.fromSnapshot(freshSnapshot);
//                            await transaction.update(record.reference, {'votes': fresh.votes + 1});
//                          }),
*/
                                      )
                                    ],
                                  ),
                                ),
                                Text((record.noFavorite).toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
//            Text("309", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ]));
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
    /*
      ListView.builder(
        scrollDirection: Axis.vertical ,
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return Container(width: 200, height: 200, margin: EdgeInsets.only(bottom: 10), color: Colors.red);
        },
      )*/
  }

  Widget _starAndId(record, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.grey[300], size: 16),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(record.id,
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),

//          IconButton(
//            icon: Icon(Icons.create, color: Colors.grey[700], size: 19
//            ),
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => WriteReview()
//                  ));
//            },
//          )
          ],
        ),

        //TODO: GET
        //MySnackBar(),

//      Stack(
//        children: <Widget>[
//          Expanded(
//            child: Container(
//            width: 100,
//            color: Colors.black.withOpacity(0.25), //transparent
//            )
//          )
//        ],
//      )
      ],
    );
  }
}

Widget _reviewEffect(Size size, EffectColor) {}

Widget _reviewSideEffect(Size size, sideEffectColor) {}

Widget _reviewOverall(size) {}

Widget _dateAndLike(record) {
  return Row(
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
                Icons.favorite,
                //color: _rating >= 1 ? Colors.orange : Colors.grey,
                color: record.favoriteSelected == true
                    ? Colors.redAccent[200]
                    : Colors.grey[300],
                size: 21,
              ),
              onTap: () {
                //favorite(record.favoriteSelected, record.noFavorite);
              },
            )
          ],
        ),
      ),

      Text((record.noFavorite).toString(),
          style: TextStyle(fontSize: 14, color: Colors.black)),
//            Text("309", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
    ],
  );
}

/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllReview extends StatefulWidget {
  @override
  _AllReviewState createState() => _AllReviewState();
}

class _AllReviewState extends State<AllReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go back'))));
  }
}*/

