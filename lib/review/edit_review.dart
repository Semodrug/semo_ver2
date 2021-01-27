import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/image.dart';

class EditReview extends StatefulWidget {
  Review review;
  String editOrWrite;
  EditReview(this.review, this.editOrWrite);

  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {

  TextEditingController myControllerEffect = TextEditingController();
  TextEditingController myControllerSideEffect = TextEditingController();
  TextEditingController myControllerOverall = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    myControllerOverall.dispose();
    super.dispose();
  }


  String effect = '';
  String sideEffect = '';
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';

  String starRatingText = '';
  static const _green = Color(0xff57C8B8);
  static const _grey = Color(0x95C4C4C4);

//  String editOrWrite = 'edit'; // 'write'

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Review>(
        stream: ReviewService().getSingleReview(widget.review.documentId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Review review = snapshot.data;

            if(effect == '') effect = review.effect;
            if(sideEffect == '') sideEffect = review.sideEffect;
            myControllerEffect.text = review.effectText;
            myControllerSideEffect.text = review.sideEffectText;
            myControllerOverall.text = review.overallText;
//            sideEffectText = review.sideEffectText;
//            overallText = review.overallText;
//            starRating = review.starRating;

            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: Text(widget.editOrWrite == 'edit'? 'Edit Review': "Write Review",
                      style: GoogleFonts.roboto(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  centerTitle: true,
                  elevation: 0.0,
                  backgroundColor: Colors.teal[200],
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        print("Go back button is clicked");
                      }),
                ),

                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: <Widget>[
                      _pillInfo(review),
                      _rating(review),
                      _effect(review),
                      _sideEffect(review),
                      _overallReview(review),
                      _edit(review),
//                      Padding(padding: EdgeInsets.only(top: 35)),
                    ],
                  ),
                )
            );
          }
          else {
            return Loading();
          }
        }
    );
  }

  Widget _pillInfo(review) {
    //TODO: Bring pill information
    return Container(
        padding: EdgeInsets.fromLTRB(20,10,20,10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Row(
          children: <Widget>[
//            Container(
//              width: 100, height: 100,
//              color: Colors.teal[100],
//            ),
            SizedBox(
              child: DrugImage(drugItemSeq: review.seqNum),
              width: 100.0,
              height: 100.0,
            ),
            Padding(padding: EdgeInsets.only(left: 15)),

            // Text(widget.review.effectText),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<Drug>(
                    stream: DatabaseService(itemSeq: widget.review.seqNum).drugData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Drug drug = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drug.entpName, style: TextStyle(fontSize: 11, color: Colors.grey, )),
                            Text(drug.itemName, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                            Container(height: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  itemSize: 20,
                                  initialRating: drug.totalRating ,
                                  //!= null ? widget.tapToRatingResult: 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: _grey,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star, color: Colors.amber[300],
                                  ),
                                ),
                                Container(width:5),
                                Text(drug.totalRating.toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.black, )),
                                Container(width:3),
                                Text("("+drug.numOfReviews.toStringAsFixed(0)+"개)", style: TextStyle(fontSize: 13, color: Colors.grey, )),
                              ],
                            ),
                            CategoryButton(str: drug.category)
                          ],
                        );
                        // Text(drug.totalRating.toStringAsFixed(2)+drug.numOfReviews.toStringAsFixed(0) + "개",
                        //   style: TextStyle(
                        //     fontSize: 16.5,
                        //     fontWeight: FontWeight.bold,
                        //   ));
                      } else
                        return Loading();
                    }),
              ],
            )
          ],
        )
    );
  }

  Widget _rating(Review review) {
    return Container(
//          height: 150,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약을 사용해보셨나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
            SizedBox(height: 10),
            RatingBar.builder(
              itemSize: 48,
              glow: false,
              initialRating: widget.editOrWrite == 'edit'? review.starRating*1.0 : 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
//              unratedColor: Colors.grey[500],
              unratedColor: _grey,
              itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
              itemBuilder: (context, _) => Icon(
                  Icons.star,
//                color: Colors.amber[300],
                  color: _green
              ),
              onRatingUpdate: (rating) {
                starRating = rating;
                setState(() {
                  if(starRating == 0)
                    starRatingText = "선택하세요.";
                  if(starRating == 1)
                    starRatingText =  "1점 (별로에요)";
                  if(starRating == 2)
                    starRatingText =  "2점 (그저그래요)";
                  if(starRating == 3)
                    starRatingText =  "3점 (괜찮아요)";
                  if(starRating == 4)
                    starRatingText =  "4점 (좋아요)";
                  if(starRating == 5)
                    starRatingText =  "5점 (최고예요)";
                });
              },
            ),
            SizedBox(height: 10),
            Text(starRatingText)
          ],
        )
    );
  }

  Widget _effect(Review review) {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약의 효과는 어땠나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: effect == "bad" ? _green: Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(()  {
                            effect = "bad";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("별로에요", style: effect == "bad"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: effect == "soso" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          effect = "soso";
                          setState(()  {
                            effect = "soso";
                            print(effect);
                          });
                        }
                    ),

                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("보통이에요", style: effect == "soso"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: effect == "good" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(()  {
                            effect = "good";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("좋아요", style: effect == "good"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),

              ],
            ),
//              SizedBox(height: 20),
//              Padding(padding: EdgeInsets.only(top: 25)),
            _textField(myControllerEffect)
          ],
        )
    );
  }

  Widget _textField(TextEditingController myControllerEffect) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20,),
      child: Container(
        width: 400,
//                height: 100,
        child: TextField(
            controller: myControllerEffect,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: new InputDecoration(
              border: InputBorder.none,
//                        border: OutlineInputBorder(
//                          borderRadius: const BorderRadius.all(
//                            const Radius.circular(8.0)
//                          ),
//                          borderSide: BorderSide(color:Colors.white)
//                        ),
              filled: true,
//                        fillColor: _grey,
              fillColor: Colors.grey[200],
            )),
      ),
    );
  }

  Widget _sideEffect(Review review) {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.6, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약의 부작용은 어떤가요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
//                                                    color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "yes" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(() {
                            sideEffect = "yes";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("있어요", style: sideEffect == "yes"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),
                Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child: Text("VS", style: TextStyle(color: Colors.grey[700]))),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
//                                                    color: widget.review.sideEffect == "no" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "no" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(() {
                            sideEffect = "no";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("없어요", style: sideEffect == "no"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),
              ],
            ),
//              Padding(padding: EdgeInsets.only(top: 25)),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                child: Container(
//                  width: 400,
//                  height: 100,
//                  child: TextField(
//                      controller: myControllerSideEffect,
////                          keyboardType: TextInputType.multiline,
//                      maxLines: null,
//                      decoration: new InputDecoration(
//                          border: InputBorder.none
//                      )),
//                ),
//              )
            _textField(myControllerSideEffect)
          ],
        )
    );
  }

  Widget _overallReview(Review review) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
//          height: 300,
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약에 대한 총평", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
//              Padding(padding: EdgeInsets.only(top: 25)),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
//                child: Container(
//                  width: 400,
//                  height: 100,
//                  child: TextField(
//                      controller: myControllerOverall,
////                          keyboardType: TextInputType.multiline,
//                      maxLines: null,
//                      decoration: new InputDecoration(
//                          border: InputBorder.none
////                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
////                        color: Colors.grey[400])
//                      )),
//                ),
//
//              ),
            _textField(myControllerOverall),
//            Padding(padding: EdgeInsets.only(top: 25)),
          ],
        )
    );
  }

  Widget _edit(Review review) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,40),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.teal[300]
            ), //padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
//          width: 50,
            height: 50,
            child: Center(
                child: Text("수정하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
            )
        ),
      ),
      onTap: () async {
        effectText = myControllerEffect.text;
        sideEffectText = myControllerSideEffect.text;
        overallText = myControllerOverall.text;
        await ReviewService(documentId: widget.review.documentId).updateReviewData(
            effect /*?? review.effect*/,
            sideEffect /*?? review.sideEffect*/,
            myControllerEffect.text /*?? review.effectText*/,
            myControllerSideEffect.text /*?? review.sideEffectText*/,
            myControllerOverall.text /*?? review.overallText*/,
            starRating == 0 ? review.starRating : starRating/*?? value.starRating*/
        );
        Navigator.pop(context);
      },
    );
  }

}




