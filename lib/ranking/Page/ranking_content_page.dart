import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/ranking/Provider/drugs_controller.dart';
import 'package:semo_ver2/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:semo_ver2/ranking/Widget/ranking_listview_widget.dart';

import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/theme/colors.dart';

class RankingContentPage extends StatefulWidget {
  final String categoryName;
  String filter;

  RankingContentPage({this.categoryName, this.filter});

  @override
  _RankingContentPageState createState() => _RankingContentPageState();
}

class _RankingContentPageState extends State<RankingContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          CustomAppBarWithArrowBackAndSearch(widget.categoryName, 0.5), //test
      body: Column(
        children: [
          _countDropDown(context),
          if (widget.filter == '리뷰 많은 순')
            sortByNumOfReview(context)
          else if (widget.filter == '별점순')
            sortByRating(context)
        ],
      ),
    );
  }

  Widget sortByNumOfReview(context) {
    return Expanded(
      child: ChangeNotifierProvider(
        create: (context) => DrugsController('리뷰 많은 순'),
        child: Consumer<DrugsController>(
          builder: (context, drugsProvider, _) => DrugList(
            drugsProvider: drugsProvider,
            category: widget.categoryName,
            // filter: '리뷰 많은 순',
          ),
        ),
      ),
    );
  }

  Widget sortByRating(context) {
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
                Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.filter,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    onChanged: (String newValue) {
                      setState(() {
                        widget.filter = newValue;
                      });
                    },
                    items: <String>['리뷰 많은 순', '별점순']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontSize: 12, color: gray900),
                        ),
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
