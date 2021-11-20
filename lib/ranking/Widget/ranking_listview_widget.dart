import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/Page/ranking_content_page.dart';
import 'package:semo_ver2/ranking/Provider/drugs_controller.dart';
import 'package:semo_ver2/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:semo_ver2/ranking/Widget/ranking_listTile_widget.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DrugList extends StatefulWidget {
  final DrugsController drugsProvider;
  // final String filter;
  final String category;

  const DrugList({
    @required this.drugsProvider,
    // @required this.filter,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _ListViewReviewWidgetState createState() => _ListViewReviewWidgetState();
}

class _ListViewReviewWidgetState extends State<DrugList> {
  DrugsController drugsProvider;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    widget.drugsProvider.fetchNextDrugs();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.drugsProvider.hasNext) {
        widget.drugsProvider.fetchNextDrugs(); //user 가 더 있다면 next user를 load 해라
      }
    }
  }

  void _onTap() {
    scrollController.animateTo(
      0,
      duration: Duration(microseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _FAB() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: gray50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 36,
      height: 36,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            _onTap();
          },
          child: Icon(
            Icons.arrow_upward,
            size: 35,
            color: gray300_inactivated,
          ),
          backgroundColor: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      ),
    );
  }

  String _checkLongName(String data) {
    String newName = data;
    List splitName = [];

    if (data.contains('(수출') || data.contains('(군납')) {
      newName = data.replaceAll('(', '(');
      if (newName.contains('')) {
        splitName = newName.split('(');
        newName = splitName[0];
      }
    }
    return newName;
  }

  Widget _upToThree(index) {
    return Center(
      child: Text('${index + 1}',
          style: Theme.of(context)
              .textTheme
              .overline
              .copyWith(fontSize: 10, color: gray750_activated)),
    );
  }

  Widget _getRateStar(RatingResult) {
    return RatingBarIndicator(
      rating: RatingResult * 1.0,
      //ignoreGestures: true,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 14,
      itemPadding: EdgeInsets.symmetric(horizontal: 0),
      unratedColor: gray75,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: yellow,
      ),
    );
  }

  double mw;
  Widget build(BuildContext context) {
    mw = MediaQuery.of(context).size.width;
    if (widget.drugsProvider.drugs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        floatingActionButton: _FAB(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.drugsProvider.drugs.length,
                itemBuilder: (context, index) {
                  var drug = widget.drugsProvider.drugs[index];
                  return ListTile(
                    minVerticalPadding: 0.5,
                    contentPadding: EdgeInsets.zero,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(drug.itemSeq,
                              filter: '리뷰 많은 순', type: widget.category),
                        ),
                      ),
                    },
                    title: //String drugRating = drugStreamData.totalRating.toStringAsFixed(1);
                        Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 0.6, color: gray50))),
                      height: 100.0,
                      child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Container(
                                  margin: EdgeInsets.only(left: 16, right: 5),
                                  child: _upToThree(index),
                                ),
                              ),
                              Container(
                                width: 88,
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Container(
                                    padding:
                                        EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                                    child: SizedBox(
                                        child: DrugImage(
                                            drugItemSeq: drug.itemSeq))),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(drug.entpName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                    fontSize: 10,
                                                    color:
                                                        gray300_inactivated)),
                                      ),
                                      Container(
                                        width: mw - 160,
                                        child: Text(drug.itemName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(color: gray900)),
                                      ),
                                      Row(
                                        children: [
                                          _getRateStar(drug.totalRating),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                              drug.totalRating
                                                  .toStringAsFixed(1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(color: gray900)),
                                          Text(' (${drug.numOfReviews}개)',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          gray300_inactivated)),
                                        ],
                                      ),
                                      Expanded(
                                          child: Row(
                                        children: [
                                          CategoryButton(
                                              str: drug.category,
                                              forRanking: 'ranking')
                                        ],
                                      )),
                                    ],
                                  )),
                            ],
                          )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    //여기까지는 스크롤 문제 없다.
  }
}

class ListViewTotalRankingWidget extends StatefulWidget {
  final DrugsTotalRankingProvider drugsProvider;
  final String category;

  const ListViewTotalRankingWidget({
    @required this.drugsProvider,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _ListViewTotalRankingWidgetState createState() =>
      _ListViewTotalRankingWidgetState();
}

class _ListViewTotalRankingWidgetState
    extends State<ListViewTotalRankingWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.drugsProvider.fetchNextDrugs();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.drugsProvider.hasNext) {
        widget.drugsProvider.fetchNextDrugs(); //user 가 더 있다면 next user를 load 해라
      }
    }
  }

  void _onTap() {
    scrollController.animateTo(
      0,
      duration: Duration(microseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _FAB() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: gray50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 36,
      height: 36,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            _onTap();
          },
          child: Icon(
            Icons.arrow_upward,
            size: 35,
            color: gray300_inactivated,
          ),
          backgroundColor: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    if (widget.drugsProvider.drugs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        floatingActionButton: _FAB(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.drugsProvider.drugs.length,
                itemBuilder: (context, index) {
                  //print('${widget.drugsProvider.drugs[index].itemName}');
                  return RankingTile(
                    drug: widget.drugsProvider.drugs[index],
                    index: (index + 1),
                    filter: '별점순',
                    category: widget.category,
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
