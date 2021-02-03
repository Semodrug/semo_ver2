import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/Page/ranking_content_page.dart';
import 'package:semo_ver2/ranking/Provider/ranking_review_provider.dart';
import 'package:semo_ver2/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:semo_ver2/ranking/Widget/ranking_listTile_widget.dart';
import 'package:semo_ver2/theme/colors.dart';

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
        widget.drugsProvider.fetchNextDrugs(); //user 가 더 있다면 next user를 load 해라
      }
    }
  }

   void _onTap(){
     scrollController.animateTo(
       0, duration: Duration(microseconds: 500), curve: Curves.easeInOut,
     );
   }

   Widget _FAB(){
     return  Container(
       decoration: BoxDecoration(
         border: Border.all(color: gray50),
         borderRadius: BorderRadius.circular(10.0),
       ),
       width: 36,
       height: 36,
       child:
       FittedBox(
         child:
         FloatingActionButton(
           onPressed: (){
             _onTap();
           },
           child: Icon(Icons.arrow_upward, size: 35, color: gray300_inactivated,),
           backgroundColor: gray50,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(15.0))
           ),
         ),
       ),
     );
   }

  Widget build(BuildContext context) {
    if (widget.drugsProvider.drugs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        floatingActionButton:
        _FAB(),
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
                      index: (index + 1));
                },
              ),
            ),
          ],
        ),
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

  void _onTap(){
    scrollController.animateTo(
      0, duration: Duration(microseconds: 500), curve: Curves.easeInOut,
    );
  }

  Widget _FAB(){
   return  Container(
      decoration: BoxDecoration(
        border: Border.all(color: gray50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 36,
      height: 36,
      child:
      FittedBox(
        child:
        FloatingActionButton(
          onPressed: (){
            _onTap();
          },
          child: Icon(Icons.arrow_upward, size: 35, color: gray300_inactivated,),
          backgroundColor: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    if (widget.drugsProvider.drugs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        floatingActionButton:
        _FAB(),
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
                      index: (index + 1));
                },
              ),
            ),

          ],
        ),
      );
  }

}
