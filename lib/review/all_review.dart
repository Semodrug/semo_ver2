import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/home/indicator.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'drug_info.dart';
import 'write_review.dart';

class AllReview extends StatefulWidget {
  String drugItemSeq;
  String itemName;
  AllReview(this.drugItemSeq, this.itemName);

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

  TabController _tabController;

  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();

  String _shortenName(String data) {
    String newName = data;
    List splitName = [];

    if (data.contains('(수출')) {
      splitName = newName.split('(수출');
      newName = splitName[0];
    }

    if (data.contains('(군납')) {
      splitName = newName.split('(군납');
      newName = splitName[0];
    }
    return newName;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return StreamProvider<List<Review>>.value(
      value: ReviewService().getReviews(widget.drugItemSeq),
      child: Scaffold(
        appBar: CustomAppBarWithGoToBack(_shortenName(widget.itemName), Icon(Icons.arrow_back), 3),
          backgroundColor: gray0_white,
//      body: topOfReview(context),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
               // child: _myTab(context),
              child: _myTabbe(context),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.create),
        //   backgroundColor: Colors.teal[300],
        //   elevation: 0.0,
//          onPressed: () {
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => WriteReview()));
//          }
 //       ),
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
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0, bottom: 10),
              child: Container(
                height: 29,
                decoration: BoxDecoration(
                    color: gray75,
                    borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                //color: gray75,
                child: Column(
                  children: [
                    TabBar(
                        labelStyle: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: gray750_activated,),
                        unselectedLabelStyle: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith( color: gray500),
                        tabs: [
                          Tab(
                              child: Text(
                                  '전체 검색',
                                  style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
                          Tab(
                              child: Text(
                                  '나의 약 검색',
                                  style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
                          Tab(
                              child: Text(
                                  '나의 약 검색',
                                  style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
                        ],

                        //indicator: CustomTabIndicator()
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(0.0),
                    //   width: double.infinity,
                    //   height: 6000,
                    //   //height: height - 300, //440.0,
                    //
                    //
                    //   child: TabBarView(
                    //     children: [
                    //       _underTab("none"),
                    //       _underTab("effectOnly"),
                    //       _underTab("sideEffectOnly"),
                    //     ],
                    //   ),
                    // )
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: TabBarView(
                                children: [
                                  _underTab("none"),
                                  _underTab("effectOnly"),
                                  _underTab("sideEffectOnly"),
                                ],
                              ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),

          ],
        ));
  }

  Widget _myTabbe(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double height = 3000;
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16,15,16,5),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primary300_main
                  ),
                  // color: gray75,
                    color: gray0_white,
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: TabBar(
                  unselectedLabelColor: gray500,
                  labelColor: gray0_white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [gradient_button_long_end, Color(0xffA7E5DC)]),
                      // colors: [gradient_button_long_start, gradient_button_long_end]),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.redAccent),
                    controller: _tabController,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: gray750_activated,),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith( color: gray500),
                  tabs: [
                    // Tab(
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: Text("APPS"),
                    //   ),
                    // ),
                    Tab(child: Text('전체리뷰',
                      // style: Theme.of(context).textTheme.subtitle2
                      //     .copyWith(color: gray750_activated, fontSize: 12)
                    )),
                    Tab(child: Text('효과리뷰만',
                        // style: Theme.of(context).textTheme.subtitle2
                        // .copyWith(color: gray750_activated, fontSize: 12)
                    )),
                    Tab(child: Text('부작용리뷰만',
                        // style: Theme.of(context).textTheme.subtitle2
                        //     .copyWith(color: gray750_activated, fontSize: 12)
                    )),
                  ],
                    // indicator: CustomTabIndicator()
                ),
              ),
            ),
            //TODO: height 없이 괜찮게

            // CustomScrollView(
            //   slivers: [
            //     SliverToBoxAdapter(
            //       child: TabBarView(
            //         children: [
            //           _underTab("none"),
            //           _underTab("effectOnly"),
            //           _underTab("sideEffectOnly"),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            Container(
              padding: EdgeInsets.all(0.0),
              width: double.infinity,
              height: 5000,
              child: TabBarView(
                children: [
                  _underTab("none"),
                  _underTab("effectOnly"),
                  _underTab("sideEffectOnly"),
                ],
              ),
            )
          ],
        ));
  }

  Widget _underTab(String filter) {
    return Container(
        //key: _key1,
      //TODO!!!!!!!!!!!!!
        height: 5000,
        //height: MediaQuery.of(context).size.height-500,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              // decoration: BoxDecoration(
              //   border: Border(
              //     top: BorderSide( //                    <--- top side
              //       color: Colors.black,
              //       width: 3.0,
              //     ),
              //   )
              // ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                "리뷰 " + drug.numOfReviews.toStringAsFixed(0) + "개",
                                style: Theme.of(context).textTheme.headline5.copyWith(color: gray750_activated,fontSize: 14)
                            );
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

//   Widget _searchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
// //        width: 370,
// //        width: MediaQuery.of(context).size.width*0.9,
//         height: 45,
//         margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           color: Colors.grey[200],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//                 flex: 5,
//                 child: TextField(
//                   focusNode: focusNode,
//                   style: TextStyle(fontSize: 15),
// //                  autofocus: true,
//                   controller: _filter,
//                   decoration: InputDecoration(
//                       fillColor: Colors.white12,
//                       filled: true,
//                       prefixIcon:  SizedBox(
//                         height: 10,
//                         width: 10,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top:4.0, bottom: 4),
//                           child: Image.asset('assets/icons/search_grey.png'),
//                         ),
//                       ),
// //                      suffixIcon: focusNode.hasFocus
// //                          ? IconButton(
// //                        icon: Icon(Icons.cancel, size: 20),
// //                        onPressed: () {
// //                          setState(() {
// //                            _filter.clear();
// //                            _searchText = "";
// //                          });
// //                        },
// //                      )
// //                          : Container(),
//                       hintText: '검색',
//                       contentPadding: EdgeInsets.zero,
//                       labelStyle: TextStyle(color: Colors.grey),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           borderSide: BorderSide(color: Colors.transparent)),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           borderSide: BorderSide(color: Colors.transparent)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           borderSide: BorderSide(color: Colors.transparent))),
//                 )),
// //            focusNode.hasFocus
// //                ? Expanded(
// //              child: FlatButton(
// //                child: Text(
// //                  'clear',
// //                  style: TextStyle(fontSize: 13),
// //                ),
// //                onPressed: () {
// //                  setState(() {
// //                    _filter.clear();
// //                    _searchText = "";
// //                    focusNode.unfocus();
// //                  });
// //                },
// //              ),
// //            )
// //                : Expanded(
// //              flex: 0,
// //              child: Container(),
// //            )
//           ],
//         ),
//       ),
//     );
//   }


  Widget _searchBar() {
    // return Center(
    //   child: Column(
    //     children: [
    //       Container(
    //         margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
    //         child: SizedBox(
    //             height: 35,
    //             child: FlatButton(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Icon(Icons.search, size: 20),
    //                   Padding(
    //                     padding:
    //                     const EdgeInsets.symmetric(horizontal: 10.0),
    //                     child: Text(
    //                       "어떤 약정보를 찾고 계세요?",
    //                       style: Theme.of(context).textTheme.bodyText2,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               // onPressed: () {
    //               //   Navigator.push(
    //               //       context,
    //               //       MaterialPageRoute(
    //               //           builder: (BuildContext context) =>
    //               //               SearchHighlightingScreen(
    //               //                   infoEE: infoEE,
    //               //                   infoNB: infoNB,
    //               //                   infoUD: infoUD,
    //               //                   storage: storage,
    //               //                   entp_name: entpName)));
    //               // },
    //               textColor: gray300_inactivated,
    //               color: gray50,
    //               shape: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                       style: BorderStyle.solid,
    //                       width: 1.0,
    //                       color: gray200),
    //                   borderRadius: BorderRadius.circular(8.0)),
    //             )),
    //       ),
    //       SizedBox(height: 10)
    //     ],
    //   ),
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 35,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                      fillColor: gray50,
                      filled: true,
                      prefixIcon:  SizedBox(
                        height: 10,
                        width: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top:4.0, bottom: 4),
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
                      ),

                      //     ImageIcon(
                      //     AssetImage('assets/icons/search_grey.png'),
                      // // color: primary400_line,
                      //     ),
                      hintText: '어떤 리뷰를 찾고계세요?',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: gray300_inactivated,
                      ),
                      contentPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1.0,
                              color: gray75),
                          borderRadius: BorderRadius.circular(8.0))),
                )),
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
