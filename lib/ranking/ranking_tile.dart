import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/image.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';


class DrugTile extends StatelessWidget {
  final Drug drug;
  final int index;

  DrugTile({this.drug, this.index});

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
          print(splitName);
          newName = splitName[0];
        }
      }

      print('$newName 의 길이는? ');
      print(newName.length);

      if (newName.length > 15) {
        newName = newName.substring(0, 12);
        newName = newName + '...';
      }
      return newName;
    }

    return StreamBuilder(
        stream: ReviewService().getReviews(drug.itemSeq),
        builder: (context, snapshot) {
          List<Review> reviews = snapshot.data;
          int len = 0;
          num sum = 0;
          double ratingResult = 0;

          if (snapshot.hasData) {
            len = reviews.length;

            reviews.forEach((review) {
              sum += review.starRating;
            });
            ratingResult = sum / len;
            print('rating Result ==> $ratingResult');

            return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhilInfoPage(drugItemSeq: drug.itemSeq),
                      ),
                    ),
                    print('===> pushed'),
                    print(drug.itemSeq),
                    // TODO: 리뷰개수
                    // print(' 리뷰 개수 잘 받아오는 확인 ${drug.review.toString()} ')
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100.0,
                    child: Material(
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 5),
                                  //padding: EdgeInsets.only(left: 0, right: 5),
                                  child: Text(
                                    ' ${index.toString()}위',
                                    style: TextStyle(fontSize: 12),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: AspectRatio(
                                aspectRatio: 2 / 2,
                                // TODO: show storage image - if null, defalut image
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: SizedBox(
                                        width: 88,
                                        height: 66,
                                        child: DrugImage(
                                            drugItemSeq: drug.itemSeq))),
                                // Image.network(
                                //   drug.image,
                                // )
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
                                      drug.entpName,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Row(children: [
                                        Text(
                                          _checkLongName(drug.itemName),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          _getRateStar(drug.totalRating),
                                          Text(
                                            '${drug.totalRating}',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
                                          ),
                                          Text(
                                            '( ${drug.numOfReviews} 개)',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        _categoryButton((drug.category))
                                      ],
                                    )),
                                  ],
                                )),
                          ],
                        )),
                  ),
                ));
          }

          else {
          return Container();// Center(child: CircularProgressIndicator());
          }
        });

  }

  Widget _getRateStar(RatingResult) {
    print('  별정믄?   ');
    print(RatingResult.toString());
    //double rating = 1.0;
    //if(RatingResult == 0){
      return RatingBar.builder(
        initialRating: RatingResult*1.0,
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

  Widget _categoryButton(str) {
    return Container(
      width: 24 + str.length.toDouble() * 10,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: ButtonTheme(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        minWidth: 10,
        height: 22,
        child: RaisedButton(
          child: Text(
            '#$str',
            style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
          ),
          onPressed: () => print('$str!'),
          color: Colors.white,
        ),
      ),
    );
  }
}

