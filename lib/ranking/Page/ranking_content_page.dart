import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/ranking/Provider/ranking_review_provider.dart';
import 'package:semo_ver2/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:semo_ver2/ranking/Widget/ranking_listview_widget.dart';

import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/theme/colors.dart';

class RankingContentPage extends StatefulWidget {
  final String categoryName;
  //String signal;
  String filter;

  RankingContentPage({this.categoryName, this.filter});

  @override
  _RankingContentPageState createState() => _RankingContentPageState();
}

class _RankingContentPageState extends State<RankingContentPage> {
  //String _filterOrSort = "리뷰 많은 순";

  //원래
  // String _checkCategoryName(String data) {
  //   String newName = '';
  //   //실제 카테고리 이름이 무엇인지 알기 위함
  //   newName = data.substring(7, (data.length));
  //   return newName;
  // }

  @override
  Widget build(BuildContext context) {
    //원래
    //String onlyName = _checkCategoryName(widget.categoryName);
    return Scaffold(
      backgroundColor: Colors.white,
      //원래
      //appBar: CustomAppBarWithArrowBackAndSearch(onlyName, 0.5),
      appBar: CustomAppBarWithArrowBackAndSearch(widget.categoryName, 0.5), //test
      body: Column(
        children: [
          _countDropDown(context),
          if (widget.filter == '리뷰 많은 순')
            fromFilterOfReview(context)
          else if (widget.filter == '별점순')
            fromFilterOfName(context)
        ],
      ),
    );
  }

  Widget fromFilterOfReview(context) {
    return Expanded(
      child: ChangeNotifierProvider(
        create: (context) => DrugsReviewProvider('리뷰 많은 순'),
        child: Consumer<DrugsReviewProvider>(
          builder: (context, drugsProvider, _) => ListViewReviewWidget(
            drugsProvider: drugsProvider,
            category: widget.categoryName,
          ),
        ),
      ),
    );
  }

  Widget fromFilterOfName(context) {
    return Expanded(
      child: ChangeNotifierProvider(
        create: (context) => DrugsTotalRankingProvider('별점순'),
        child: Consumer<DrugsTotalRankingProvider>(
          builder: (context, drugsProvider, _) => ListViewTotalRankingWidget(
            drugsProvider: drugsProvider,
            category: widget.categoryName,
          ),
        ),
      ),
    );
  }

  Widget _countDropDown(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 30,
            child: Row(
              children: <Widget>[
                //TODO: No sql에서는 count가 현재 지원이 안되고 있어서 일단 1차적으로는 총 개수는 제외하고 가는 거로
                Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.filter ,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    onChanged: (String newValue) {
                      setState(() {
                        widget.filter  = newValue;
                      });
                    },
                    items: <String>['리뷰 많은 순','별점순']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase(), style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12, color: gray900),),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 5,
          thickness: 1,
          color: gray50,
        )
      ],
    );
  }
}
