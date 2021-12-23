import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/theme/colors.dart';

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

  GlobalKey _key8 = GlobalKey();

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
    return StreamProvider<List<Review>>.value(
      value: ReviewService().getReviews(widget.drugItemSeq),
      child: Scaffold(
          appBar: CustomAppBarWithGoToBack(
              _shortenName(widget.itemName), Icon(Icons.arrow_back), 0.5),
          backgroundColor: gray0_white,
          body: _myTabbe(context)),
    );
  }

  // Widget _myTab(BuildContext context) {
  //   // double height = MediaQuery.of(context).size.height;

  //   return DefaultTabController(
  //       length: 3,
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0, bottom: 10),
  //             child: Container(
  //               height: 29,
  //               decoration: BoxDecoration(
  //                   color: gray75,
  //                   borderRadius: BorderRadius.all(Radius.circular(4))
  //               ),
  //               //color: gray75,
  //               child: Column(
  //                 children: [

  //                   TabBar(
  //                       labelStyle: Theme.of(context)
  //                           .textTheme
  //                           .subtitle2
  //                           .copyWith(color: gray750_activated,),
  //                       unselectedLabelStyle: Theme.of(context)
  //                           .textTheme
  //                           .caption
  //                           .copyWith( color: gray500),
  //                       tabs: [
  //                         Tab(
  //                             child: Text(
  //                                 '전체 검색',
  //                                 style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
  //                         Tab(
  //                             child: Text(
  //                                 '나의 약 검색',
  //                                 style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
  //                         Tab(
  //                             child: Text(
  //                                 '나의 약 검색',
  //                                 style:  TextStyle(color: gray750_activated, fontFamily: 'NotoSansKR')                        )),
  //                       ],

  //                       //indicator: CustomTabIndicator()
  //                   ),
  //                   TabBarView(
  //                             children: [
  //                               _underTab("none", 1),
  //                               _underTab("effectOnly", 2),
  //                               _underTab("sideEffectOnly", 3),
  //                             ],
  //                           )
  //                 ],
  //               ),
  //             ),
  //           ),

  //         ],
  //       ));
  // }

  Widget _myTabbe(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: primary300_main),
                    color: gray0_white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: TabBar(
                  unselectedLabelColor: gray500,
                  labelColor: gray0_white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        gradient_button_long_end,
                        Color(0xffA7E5DC)
                      ]),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.redAccent),
                  controller: _tabController,
                  labelStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: gray750_activated,
                      ),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: gray500),
                  tabs: [
                    Tab(
                        child: Text(
                      '전체리뷰',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width <= 320
                              ? 11
                              : 12),
                    )),
                    Tab(
                        child: Text(
                      '효과리뷰만',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width <= 320
                              ? 11
                              : 12),
                    )),
                    Tab(
                        child: Text(
                      '부작용리뷰만',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width <= 320
                              ? 11
                              : 12),
                    )),
                  ],
                  // indicator: CustomTabIndicator()
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _underTab("none", 1),
                  _underTab("effectOnly", 2),
                  _underTab("sideEffectOnly", 3),
                ],
              ),
            )

            // Container(
            //   height: 5000,
            //   child: TabBarView(
            //     children: [
            //       _underTab("none", 1),
            //       _underTab("effectOnly", 2),
            //       _underTab("sideEffectOnly", 3),
            //     ],
            //   ),
            // )
          ],
        ));
  }

  Widget _underTab(String filter, key) {
    return ListView(
      // physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<Drug>(
                    stream:
                        DatabaseService(itemSeq: widget.drugItemSeq).drugData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Drug drug = snapshot.data;
                        return Text(
                            "리뷰 " + drug.numOfReviews.toStringAsFixed(0) + "개",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: gray750_activated, fontSize: 14));
                      } else
                        return Container();
                    }),
              ],
            )),
        _searchBar(),
        ReviewList(_searchText, filter, widget.drugItemSeq),
      ],
    );
  }

  Widget _searchBar() {
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
                  controller: _filter,
                  decoration: InputDecoration(
                      fillColor: gray50,
                      filled: true,
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
                      ),
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
}
