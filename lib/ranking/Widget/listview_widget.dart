import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/Provider/ranking_review_provider.dart';
import 'package:semo_ver2/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:semo_ver2/ranking/Widget/ranking_listTile_widget.dart';

class ListViewReviewWidget extends StatefulWidget {
  final DrugsReviewProvider drugsProvider;
  final String category;

  const ListViewReviewWidget({
    @required this.drugsProvider,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _ListViewReviewWidgetState createState() => _ListViewReviewWidgetState();
}

class _ListViewReviewWidgetState extends State<ListViewReviewWidget> {
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
        widget.drugsProvider.fetchNextDrugs();//user 가 더 있다면 next user를 load 해라
      }
    }
  }


  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child:
        ListView.builder(
          controller: scrollController,
          itemCount: widget.drugsProvider.drugs.length,
          itemBuilder: (context, index) {
            print('${widget.drugsProvider.drugs[index].itemName}');
            return RankingTile(drug: widget.drugsProvider.drugs[index], index: (index + 1));
          },
        ),
        ),
      ],
    );
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
  _ListViewTotalRankingWidgetState createState() => _ListViewTotalRankingWidgetState();
}

class _ListViewTotalRankingWidgetState extends State<ListViewTotalRankingWidget> {
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
        widget.drugsProvider.fetchNextDrugs();//user 가 더 있다면 next user를 load 해라
      }
    }
  }


  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child:
        ListView.builder(
          controller: scrollController,
          itemCount: widget.drugsProvider.drugs.length,
          itemBuilder: (context, index) {
            print('${widget.drugsProvider.drugs[index].itemName}');
            return RankingTile(drug: widget.drugsProvider.drugs[index], index: (index + 1));
          },
        ),
        ),
      ],
    );
  }


//
//  String _checkCategoryName(String data) {
//    String newName = '';
//    //TODO: 이부분 0 --> 7로 바꿔주기 pattern이 0-6까지가 카테고리 이름
//    newName = data.substring(7,(data.length));
//    return newName;
//  }


}
