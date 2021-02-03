import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'drug_info.dart';
import 'write_review.dart';

class AllReview extends StatefulWidget {
  String drugItemSeq;
  AllReview(this.drugItemSeq);

  @override
  _AllReveiewState createState() => _AllReveiewState();
}

class _AllReveiewState extends State<AllReview> {
  var index = 8;
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _AllReveiewState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return StreamProvider<List<Review>>.value(
      value: ReviewService().getReviews(widget.drugItemSeq),
      child: Scaffold(
        appBar: _appbar(context),
//      body: topOfReview(context),
        body: CustomScrollView(
          slivers: [
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
              child: _myTab(context),
            ),
//            SliverToBoxAdapter(
//              child: _underTab(),
//            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          backgroundColor: Colors.teal[300],
          elevation: 0.0,
//          onPressed: () {
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => WriteReview()));
//          }
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      title: Text('약이름',
          style: Theme.of(context).textTheme.headline4),
//      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[300]),
          onPressed: () {
            Navigator.pop(
              context,
//                MaterialPageRoute(builder: (context) => MyStatefulWidget()
//                    builder: (context) => MyApp()
//                )
            );
          }),
      actions: <Widget>[],
    );
  }

  Widget _myTab(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
              tabs: [
                Tab(child: Text('전체리뷰', style: TextStyle(color: Colors.black))),
                Tab(
                    child:
                        Text('효과리뷰만', style: TextStyle(color: Colors.black))),
                Tab(
                    child:
                        Text('부작용리뷰만', style: TextStyle(color: Colors.black))),
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
                  _underTab("none"),
                  _underTab("effectOnly"),
                  _underTab("sideEffectOnly"),

//
//                  _underInfo(context, drugItemSeq),
//                  ReviewPage(drugItemSeq)
                ],
              ),
            )
          ],
        ));
  }

  Widget _underTab(String filter) {
    return Container(
//                        key: _key1,
        height: 3000,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 4,
              color: Colors.grey[200],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //TODO EDIT num of reviews
                    StreamBuilder<Drug>(
                        stream: DatabaseService(itemSeq: widget.drugItemSeq)
                            .drugData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Drug drug = snapshot.data;
                            return Text(
                                drug.numOfReviews.toStringAsFixed(0) + "개",
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ));
                          } else
                            return Container();
                        }),

//                    InkWell(
//                        child: Text('전체리뷰 보기',
//                            style: TextStyle(
//                              fontSize: 14.5,
//                            )),
//                        onTap: () {
////
////                          Navigator.push(
////                              context,
////                              MaterialPageRoute(
////                                  builder: (context) => AllReview()));
//                        }),
                  ],
                )),
            _searchBar(),
            ReviewList(_searchText, filter),
          ],
        ));
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
//        width: 370,
//        width: MediaQuery.of(context).size.width*0.9,
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
//                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                      fillColor: Colors.white12,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
//                      suffixIcon: focusNode.hasFocus
//                          ? IconButton(
//                        icon: Icon(Icons.cancel, size: 20),
//                        onPressed: () {
//                          setState(() {
//                            _filter.clear();
//                            _searchText = "";
//                          });
//                        },
//                      )
//                          : Container(),
                      hintText: '검색',
                      contentPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent))),
                )),
//            focusNode.hasFocus
//                ? Expanded(
//              child: FlatButton(
//                child: Text(
//                  'clear',
//                  style: TextStyle(fontSize: 13),
//                ),
//                onPressed: () {
//                  setState(() {
//                    _filter.clear();
//                    _searchText = "";
//                    focusNode.unfocus();
//                  });
//                },
//              ),
//            )
//                : Expanded(
//              flex: 0,
//              child: Container(),
//            )
          ],
        ),
      ),
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

/*


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
  */
}
