import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'edit_review.dart';
import 'pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'write_review.dart';

class GetRating extends StatefulWidget {
  String drugItemSeq;
  GetRating(this.drugItemSeq);

  @override
  _GetRatingState createState() => _GetRatingState();
}

class _GetRatingState extends State<GetRating> {
  @override
  Widget build(BuildContext context) {
//    final reviews = Provider.of<List<Review>>(context) ?? [];
    double tapToRatingResult = 0.0;

    return StreamBuilder<List<Review>>(
      stream: ReviewService().getReviews(widget.drugItemSeq),
      builder: (context, snapshot) {
        List<Review> reviews = snapshot.data;
        int length = 0 ;
        num sum = 0;
        num ratingResult = 0;
        double effectGood = 0;
        double effectSoso = 0;
        double effectBad = 0;
        double sideEffectYes = 0;
        double sideEffectNo = 0;

        if(snapshot.hasData) {
          length = reviews.length;

          reviews.forEach((review) {
            sum += review.starRating;

            review.effect == "good" ? effectGood++ :
            review.effect == "soso" ? effectSoso++ : effectBad++;

            review.sideEffect == "yes" ? sideEffectYes++ : sideEffectNo++;
          });

          ratingResult = sum / length;
          print("SUM:" + sum.toString());
          print("RANGTH:" + length.toString());
          print("RATING RESULT:" + ratingResult.toString());
//    ratingResult = sum/length;
//    print(ratingResult);
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("총 평점",
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.bold)),
                  //Container(height: size.height * 0.02),
                  Padding(padding: EdgeInsets.only(top: 14.0)),
//            _rate(context),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.star, color: Colors.amber[300], size: 35),
                      //Todo : Rating
                      Text(ratingResult.toStringAsFixed(1), style: TextStyle(fontSize: 35)),
                      Text("/5",
                          style: TextStyle(
                              fontSize: 20, color: Colors.grey[500])),
                      SizedBox(
                          width:30
                      ),
                      //pie chart
                      Column(
                        children: [
                          Text("효과"),
                          MyPieChart("effect", effectGood, effectSoso, effectBad, sideEffectYes, sideEffectNo)
//            _effectPieChart(effectGood, effectSoso, effectBad),
                        ],
                      ),
                      Column(
                        children: [
                          Text("부작용"),
                          MyPieChart("sideEffect", effectGood, effectSoso, effectBad, sideEffectYes, sideEffectNo)
//            _sideEffectPieChart(sideEffectYes, sideEffectNo),
                        ],
                      ),

                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 14.0)),
                  Text("탭해서 평가하기",
                      style: TextStyle(
                          fontSize: 14.0, color: Colors.grey[700])),
                  Padding(padding: EdgeInsets.only(top: 7.0)),
                  _tapToRate(tapToRatingResult)
                ],
              ));
        }
        else {
          return Loading();
        }
      }
    );



  }

  Widget _tapToRate(tapToRatingResult) {
    return RatingBar.builder(
      initialRating:0,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 30,
      glow: false,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      unratedColor: Colors.grey[300],
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
      onRatingUpdate: (rating) {
        _showMyDialog(rating);
      },
    );
  }


  Future<void> _showMyDialog(rating) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Icon(Icons.star, size: 30, color: Colors.amberAccent)),
                SizedBox(height: 5),
                Center(child: Text('별점이 반영되었습니다.', style: TextStyle(color: Colors.black45, fontSize: 14))),
                SizedBox(height: 20),
                Center(child: Text('리뷰 작성도 이어서 할까요?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('확인', style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        //TODO: GOTO Edit Review
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => WriteReview(widget.drugItemSeq, rating)
                        ));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
