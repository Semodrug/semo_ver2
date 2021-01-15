import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'edit_review.dart';
import 'pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
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
    TheUser user = Provider.of<TheUser>(context);
    double _tapToRatingResult = 0.0;
    bool _isRated = false;

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

            return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("총 평점",
                        style: TextStyle(
                            fontSize: 16.5, fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.only(top: 14.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.amber[300], size: 35),
                        //Todo : Rating
                        Text(ratingResult.toStringAsFixed(1), style: TextStyle(fontSize: 35)),
                        Text("/5",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[500])),
//                        SizedBox(
//                            width:30
//                        ),
                        Expanded(child: Container()),
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
                    StreamBuilder<Review>(
                      stream: ReviewService().getSingleReview("7nXbIzuWESZhHFEcRwyv"),
                      builder: (context, snapshot) {
                        Review review = snapshot.data;
                        print("*******"+review.starRating.toString());
                        return _tapToRate(review.starRating, user);
                      }
                    ),
                    //TODO Save tap to RATE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#######################

                  ],
                ));
          }
          else {
            return Loading();
          }
        }
    );



  }

  Widget _tapToRate(tapToRatingResult, user) {
    print("HERE!!!!!!!!!!!!"+tapToRatingResult.toString());
//    return RatingBar(
//      onRatingChanged: (rating) => setState(() => rating =3),
//      filledIcon: Icons.star,
//      emptyIcon: Icons.star_border,
//      halfFilledIcon: Icons.star_half,
//      isHalfAllowed: false,
//      filledColor: Colors.green,
//      emptyColor: Colors.redAccent,
//      size: 30,
//    );
    double rating = 1.0;
    return SmoothStarRating(
//      rating: 5,
      rating: tapToRatingResult,
      isReadOnly: false,
      size: 30,
      filledIconData: Icons.star,
      allowHalfRating: false,
      color: Colors.amberAccent,
      borderColor: Colors.amberAccent,
//      defaultIconData: Icons.star,
      starCount: 5,
      spacing: 2.0,
      onRated: (value) {
        print("rating value -> $value");
        rating = value;
        // print("rating value dd -> ${value.truncate()}");
      },
    );

//    return RatingBar.builder(
//
//      initialRating: 0,
//      minRating: 1,
//      direction: Axis.horizontal,
//      allowHalfRating: false,
//      itemCount: 5,
//      itemSize: 30,
//      glow: false,
//      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//      unratedColor: Colors.grey[300],
//      itemBuilder: (context, _) => Icon(
//        Icons.star,
//        color: Colors.amberAccent,
//      ),
//      onRatingUpdate: (rating) async {
//        rating =3;
//
//        if(ReviewService(documentId: widget.drugItemSeq).findUserWroteReview(widget.drugItemSeq, user.toString()) == true){
//          _dialogIfAlreadyExist();
//          //TODO:############################ Update rating###############################
//        }
//
//        else
//          _showMyDialog(rating);
//        await ReviewService(documentId: widget.drugItemSeq).tapToRate(rating, user);
//      },
//
//    );
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
                            builder: (context) => WriteReview(drugItemSeq: widget.drugItemSeq, tapToRatingResult: rating)
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

  Future<void> _dialogIfAlreadyExist()  {
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
//                Center(child: Text('별점이 반영되었습니다.', style: TextStyle(color: Colors.black45, fontSize: 14))),
                SizedBox(height: 20),
                Center(child: Text('Rating updated', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
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
//                    TextButton(
//                      child: Text('확인', style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
//                      onPressed: () {
//                        //TODO: GOTO Edit Review
//                        Navigator.of(context).pop();
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) => WriteReview(drugItemSeq: widget.drugItemSeq, tapToRatingResult: rating)
//                        ));
//                      },
//                    ),
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





/*
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
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
    TheUser user = Provider.of<TheUser>(context);
//    final reviews = Provider.of<List<Review>>(context) ?? [];
    double _tapToRatingResult = 0.0;
    bool _isRated = false;

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
//          print("SUM:" + sum.toString());
//          print("RANGTH:" + length.toString());
//          print("RATING RESULT:" + ratingResult.toString());

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
                  _tapToRate(_tapToRatingResult, user)
                ],
              ));
        }
        else {
          return Loading();
        }
      }
    );



  }

  Widget _tapToRate(tapToRatingResult, user) {
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
      onRatingUpdate: (rating) async {
        _showMyDialog(rating);
        await ReviewService(documentId: widget.drugItemSeq).tapToRate(rating, user);
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
*/
