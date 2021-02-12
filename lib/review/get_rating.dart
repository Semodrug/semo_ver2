import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    bool _isRated = false;
    return StreamBuilder<Drug> (
      stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Drug drug = snapshot.data;
          return StreamBuilder<List<Review>>(
              stream: ReviewService().getReviews(widget.drugItemSeq),
              builder: (context, snapshot) {
                List<Review> reviews = snapshot.data;
                int length = 0 ;
                num sum = 0;
                double ratingResult = 0;
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

                  ratingResult = (sum / length);
                  if (ratingResult.isNaN) ratingResult = 0;
                  
                  double good = (effectGood / (effectGood + effectSoso + effectBad))*100;
                  double soso = (effectSoso / (effectGood + effectSoso + effectBad))*100;
                  double bad = (effectBad / (effectGood + effectSoso + effectBad))*100;
                  double yes = (sideEffectYes / (sideEffectYes + sideEffectNo))*100;
                  double no = (sideEffectNo / (sideEffectYes + sideEffectNo))*100;

                  if (good.isNaN) good = 0;
                  if (soso.isNaN) soso = 0;
                  if (bad.isNaN) bad = 0;
                  if (yes.isNaN) yes = 0;
                  if (no.isNaN) no = 0;


                  DatabaseService(itemSeq: widget.drugItemSeq).updateTotalRating(ratingResult, length);

                  return Container(
                      padding: EdgeInsets.fromLTRB(20,20,10,20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("총 평점",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: gray750_activated,
                                  fontSize: 14
                              )),
                          Container(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //#####
                              Row(
                                children: [
                                  Image.asset('assets/icons/star.png',
                                  width: 28, height: 28,),
                                  //Todo : Rating평
                                  Container(width: 5),
                                  Text("",
                                      style: Theme.of(context).textTheme.headline1.copyWith(
                                          color: gray750_activated,
                                          fontSize: 24
                                      )),
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(ratingResult.toStringAsFixed(2),
                                      style: Theme.of(context).textTheme.headline1.copyWith(
                                          color: gray750_activated,
                                          fontSize: 24
                                      )),
                                  Column(
                                    children: [
                                      Text(" /5",
                                          style: Theme.of(context).textTheme.headline4.copyWith(
                                              color: gray300_inactivated,
                                              fontSize: 16
                                          )),
                                      Container(height:4)
                                    ],
                                  ),
                                ],) ,
                              Expanded(child: Container()),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(good == 0 && soso == 0 && bad == 0 ? "" : "효과  ",
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: gray600,
                                          )),
                                      Container(height: 6),
                                      Text(good == 0 && soso == 0 && bad == 0 ? "" : "부작용  ",
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: gray600,
                                          )),
                                    ],
                                  ),
                                  Container(width:8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //effect
                                      effectBad > effectSoso && effectBad > effectGood ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: good == 0 && soso == 0 && bad == 0 ? "" : "별로에요  ",
                                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                color: gray600,)),
                                            TextSpan(
                                              text:good == 0 && soso == 0 && bad == 0 ? "" :
                                              bad.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      effectSoso > effectGood && effectSoso > effectBad ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "보통이에요  ",
                                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                soso.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "좋아요  ",
                                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                good.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      ),
                                      // Text(good == 0 && soso == 0 && bad == 0 ? "" : "좋아요  " + bad.toStringAsFixed(0) + "%",
                                      //     style: Theme.of(context).textTheme.subtitle1.copyWith(
                                      //       color: gray600,
                                      //     )
                                      // ),
                                      Container(height: 6),

                                      //side effect
                                      sideEffectYes > sideEffectNo ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "있어요  ",
                                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                yes.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "없어요  ",
                                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                no.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                      // Text(good == 0 && soso == 0 && bad == 0 ? "" : "없어요  " +  no.toStringAsFixed(0) + "%",
                                      //     style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      //       color: gray600,
                                      //     )
                                      // )
                                    ],
                                  ),
                                  Container(width:MediaQuery.of(context).size.width*0.15)
                                  //MyPieChart("effect", effectGood, effectSoso, effectBad, sideEffectYes, sideEffectNo)
                                ],
                              ),
                              // Column(
                              //   children: [
                              //     Text("부작용"),
                              //     MyPieChart("sideEffect", effectGood, effectSoso, effectBad, sideEffectYes, sideEffectNo)
                              //   ],
                              // ),
                            ],
                          ),


                        ],
                      ));
                }
                else {
                  return Container();
                }
              }
          );
        }
        else return Container();
      }
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
                            builder: (context) => WriteReview(drugItemSeq: widget.drugItemSeq,)
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
