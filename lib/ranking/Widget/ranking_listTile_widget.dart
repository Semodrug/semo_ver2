import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/drug.dart';

import 'package:flutter/material.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/theme/colors.dart';

class RankingTile extends StatelessWidget {
  final Drug drug;
  final int index;
  final String filter;
  final String category;

  RankingTile({this.drug, this.index, this.filter, this.category});

  @override
  Widget build(BuildContext context) {
    // print('미디어쿼리 값 ==> ');
    double mw = MediaQuery.of(context).size.width;
    // print(mw.toString());

    //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
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

    //디자이너님이 그냥 숫자로만
    Widget _upToThree(index) {
      return Center(
        child: Text(index.toString(),
            style: Theme.of(context)
                .textTheme
                .overline
                .copyWith(fontSize: 10, color: gray750_activated)),
      );
    }

    //return GestureDetector(
    return ListTile(
      minVerticalPadding: 0.5,
      contentPadding: EdgeInsets.zero,
      onTap: () => {
        //Navigator.pop(context),
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ReviewPage(drug.itemSeq, filter: filter, type: category),
          ),
        ),
      },
      title:   //String drugRating = drugStreamData.totalRating.toStringAsFixed(2);
               Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                height: 100.0,
                child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Container(
                            margin: EdgeInsets.only(left: 16, right: 5),
                            //padding: EdgeInsets.only(left: 0, right: 5),
                            child: _upToThree(index),
                          ),
                        ),
                        Container(
                          width: 88,
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Container(
                              padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                              child: SizedBox(
                                  child: DrugImage(
                                      drugItemSeq: drug.itemSeq))),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(drug.entpName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline
                                          .copyWith(
                                              fontSize: 10,
                                              color: gray300_inactivated)),
                                ),
                                Container(
                                  width: mw - 160,
                                  child: Text(
                                      //_checkLongName(drugStreamData.itemName),
                                      drug.itemName,
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
                                    Text(drug.totalRating.toStringAsFixed(2),
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
                                                color: gray300_inactivated)),
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
              )
           ,
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
}
