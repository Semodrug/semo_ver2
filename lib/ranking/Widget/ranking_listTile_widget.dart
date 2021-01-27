import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/drug.dart';

import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/Page/ranking_content_page.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';

class RankingTile extends StatelessWidget {
  final Drug drug;
  final int index;

  RankingTile({this.drug, this.index});

  @override
  Widget build(BuildContext context) {
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
      if (newName.length > 15) {
        newName = newName.substring(0, 12);
        newName = newName + '...';
      }
      return newName;
    }

    //디자이너님이 1-3위까지는 위를 붙이고, 4위부터는 그냥 숫자로만
    Widget _upToThree(index) {
      if (index < 4) {
        return Center(
          child: Text(
            '${index.toString()}위',
            style: TextStyle(fontSize: 12),
          ),
        );
      } else
        return Center(
          child: Text(
            index.toString(),
            style: TextStyle(fontSize: 12),
          ),
        );
    }

    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () => {
            Navigator.pop(context),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage(drug.itemSeq, fromRankingTile: 'true' ),
              ),
            ),
          },
          child:StreamBuilder<Drug>(
              stream: DatabaseService(itemSeq: drug.itemSeq).drugData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Drug drugStreamData = snapshot.data;
                  String drugRating = drugStreamData.totalRating.toStringAsFixed(2);
                  return Container(
                    width: double.infinity,
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
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: AspectRatio(
                                aspectRatio: 2 / 2,
                                // TODO: show storage image - if null, defalut image
                                child: Container(
                                    padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                                    child: SizedBox(
                                        width: 40,
                                        child: DrugImage(drugItemSeq: drugStreamData.itemSeq))),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drugStreamData.entpName,
                                      style:
                                      TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Row(children: [
                                        Text(
                                          _checkLongName(drugStreamData.itemName),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          _getRateStar(drugStreamData.totalRating),
                                          Text(
                                            drugRating,
                                            style: TextStyle(
                                                color: Colors.grey[600], fontSize: 13),
                                          ),
                                          Text(
                                            '( ${drugStreamData.numOfReviews} 개)',
                                            style: TextStyle(
                                                color: Colors.grey[600], fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                          children: [CategoryButton(str: drugStreamData.category)],
                                        )),
                                  ],
                                )),
                          ],
                        )),
                  );
                }
                else return Container();//LinearProgressIndicator();
              }
          ),
        ));
  }

  Widget _getRateStar(RatingResult) {
    return RatingBar.builder(
      initialRating: RatingResult * 1.0,
      minRating: 1,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 14,
      glow: false,
      itemPadding: EdgeInsets.symmetric(horizontal: 0),
      unratedColor: Colors.grey[300],
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
    );
  }

}
