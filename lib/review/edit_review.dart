import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/ranking/Provider/drugs_controller.dart';
import 'package:semo_ver2/review/see_my_review.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/review/review_pill_info.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

class EditReview extends StatefulWidget {
  Review review;
  String editOrWrite;
  EditReview(this.review, this.editOrWrite);

  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  TextEditingController myControllerEffect = TextEditingController();
  TextEditingController myControllerSideEffect = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    super.dispose();
  }

  String effect = '';
  String sideEffect = '';
  String originEffect = '';
  String originSideEffect = '';
  double starRating = 0;
  String effectText = '';
  String sideEffectText = '';
  String starRatingText = '';
  bool editSwitch = false;
  DrugsController drugsProvider;

  var isEffectBad = 0.0;
  var isEffectSoSo = 0.0;
  var isEffectGood = 0.0;
  var isSideEffectYes = 0.0;
  var isSideEffectNo = 0.0;

  var isOriginEffectBad = 0.0;
  var isOriginEffectSoSo = 0.0;
  var isOriginEffectGood = 0.0;
  var isOriginSideEffectYes = 0.0;
  var isOriginSideEffectNo = 0.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Review>(
        stream: ReviewService().getSingleReview(widget.review.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Review review = snapshot.data;

            // starRating = review.starRating;

            if (effect == '') {
              effect = review.effect;
              originEffect = review.effect;

              if (effect == 'bad') {
                isOriginEffectBad = 1.0;
                isEffectBad = 1.0;
                // isOriginEffectSoSo = 0.0;
                //  isOriginEffectGood = 0.0;
              } else if (effect == 'soso') {
                // isOriginEffectBad = 0.0;
                isOriginEffectSoSo = 1.0;
                isEffectSoSo = 1.0;
                // isOriginEffectGood = 0.0;
              } else if (effect == 'good') {
                // isOriginEffectBad = 0.0;
                // isOriginEffectSoSo = 0.0;
                isOriginEffectGood = 1.0;
                isEffectGood = 1.0;
              }
            }
            if (sideEffect == '') {
              sideEffect = review.sideEffect;
              originSideEffect = review.sideEffect;

              if (sideEffect == 'yes') {
                isOriginSideEffectYes = 1.0;
                isSideEffectYes = 1.0;
                // isOriginSideEffectNo = 0.0;
              } else if (sideEffect == 'no') {
                // isOriginSideEffectYes = 0.0;
                isOriginSideEffectNo = 1.0;
                isSideEffectNo = 1.0;
              }
            }
            if (editSwitch == false) {
              myControllerEffect.text = review.effectText;
              myControllerSideEffect.text = review.sideEffectText;
              editSwitch = true;
            }

            return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: gray0_white,
                appBar: AppBar(
                  title: Text(
                    "리뷰 수정하기",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: gray800),
                  ),
                  elevation: 0.5,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    color: primary300_main,
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog();
                    },
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ReviewPillInfo(review.seqNum),
                        _rating(review),
                        _effect(review),
                        _sideEffect(review),
                        _edit(review),
                      ],
                    ),
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  Widget IYMYGotoSeeOrCheckDialog(drugItemSeq) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Icon(Icons.star, color: yellow),
              SizedBox(height: 13),
              /* BODY */
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    // TextSpan(
                    //     text: boldBodyString,
                    //     style: Theme.of(context).textTheme.headline4.copyWith(
                    //         color: gray700, fontWeight: FontWeight.w700)),
                    TextSpan(text: "리뷰 수정이 완료되었습니다"),
                  ],
                ),
              ),
              SizedBox(height: 3),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "내가 작성한 리뷰 보러가기",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: gray300_inactivated),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: gray300_inactivated,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeeMyReview(drugItemSeq)));
                  }),
              SizedBox(width: 16),
              /* RIGHT ACTION BUTTON */
              ElevatedButton(
                child: Text(
                  "확인",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: primary400_line),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(260, 40),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                    primary: gray50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: gray75))),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _rating(Review review) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("약을 사용해보셨나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            SizedBox(height: 10),
            RatingBar.builder(
              itemSize: 48,
              glow: false,
              initialRating:
                  widget.editOrWrite == 'edit' ? review.starRating * 1.0 : 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              unratedColor: gray75,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => Image.asset(
                'assets/icons/rating_star.png',
                width: 28,
                height: 28,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  starRating = rating;
                  print('starRating!!!!!!!!!!!!!!!!');
                  print(starRating);
                  // if(starRating == 0)
                  //   starRatingText = "선택하세요.";
                  if (starRating == 1) starRatingText = "1점 (별로에요)";
                  if (starRating == 2) starRatingText = "2점 (그저그래요)";
                  if (starRating == 3) starRatingText = "3점 (괜찮아요)";
                  if (starRating == 4) starRatingText = "4점 (좋아요)";
                  if (starRating == 5) starRatingText = "5점 (최고예요)";
                });
              },
            ),
            SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: primary500_light_text,
                      fontSize: 12,
                    ),
                children: <TextSpan>[
                  TextSpan(
                    text: starRatingText.isNotEmpty
                        ? '${starRatingText.split(" ")[0]}'
                        : review.starRating == 1
                            ? "1점 "
                            : review.starRating == 2
                                ? "2점 "
                                : review.starRating == 3
                                    ? "3점 "
                                    : review.starRating == 4
                                        ? "4점 "
                                        : "5점 ",
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: primary600_bold_text,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: starRatingText.isNotEmpty
                        ? ' ' + '${starRatingText.split(" ")[1]}'
                        : review.starRating == 1
                            ? "(별로에요)"
                            : review.starRating == 2
                                ? "(그저그래요)"
                                : review.starRating == 3
                                    ? "(괜찮아요)"
                                    : review.starRating == 4
                                        ? "(좋아요)"
                                        : "(최고예요)",
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _effect(Review review) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("약의 효과는 어땠나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 40,
                            height: 40,
                            // child: Image.asset('assets/icons/sentiment_satisfied.png.png'),
                            child: Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            decoration: BoxDecoration(
                                color:
                                    effect == "bad" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            effect = "bad";

                            isEffectBad = 1.0;
                            isEffectSoSo = 0.0;
                            isEffectGood = 0.0;
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "별로에요",
                      style: effect == "bad"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary600_bold_text, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 40,
                            height: 40,
                            // child: Image.asset('assets/icons/sentiment_satisfied.png.png'),
                            child: Icon(
                              Icons.sentiment_neutral_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            decoration: BoxDecoration(
                                color:
                                    effect == "soso" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            effect = "soso";

                            isEffectBad = 0.0;
                            isEffectSoSo = 1.0;
                            isEffectGood = 0.0;
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "보통이에요",
                      style: effect == "soso"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary600_bold_text, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 40,
                            height: 40,
                            // child: Image.asset('assets/icons/sentiment_satisfied.png.png'),
                            child: Icon(
                              Icons.sentiment_satisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            decoration: BoxDecoration(
                                color:
                                    effect == "good" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            effect = "good";

                            isEffectBad = 0.0;
                            isEffectSoSo = 0.0;
                            isEffectGood = 1.0;
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "좋아요",
                      style: effect == "good"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary600_bold_text, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
//              SizedBox(height: 20),
//              Padding(padding: EdgeInsets.only(top: 25)),
            _textField("effect", myControllerEffect)
          ],
        ));
  }

  Widget _textFieldForSideEffect(TextEditingController myControllerEffect) {
    if (sideEffect == "no") {
      // myControllerSideEffect.text = " ";
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Container(
            width: 400,
//                height: 100,
            child: TextField(
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray750_activated,
                    ),
                maxLength: 500,
                controller: myControllerEffect,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gray75),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(4.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary300_main),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(4.0)),
                  ),
                  filled: true,
                  fillColor: gray50,
                ))),
      );
    }
  }

  Widget _sideEffect(Review review) {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.6,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약의 부작용은 없었나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
//                              color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "yes"
                                    ? primary300_main
                                    : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            sideEffect = "yes";
                            isSideEffectYes = 1.0;
                            isSideEffectNo = 0.0;
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "부작용 있어요",
                      style: sideEffect == "yes"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary600_bold_text, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child:
                        Text("VS", style: TextStyle(color: Colors.grey[700]))),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(
                              Icons.sentiment_satisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
//                              color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "no"
                                    ? primary300_main
                                    : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            sideEffect = "no";
                            isSideEffectYes = 0.0;
                            isSideEffectNo = 1.0;
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "부작용 없어요",
                      style: sideEffect == "no"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary600_bold_text, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
//              )
            _textFieldForSideEffect(myControllerSideEffect)
          ],
        ));
  }

  Widget _textField(String type, TextEditingController myControllerEffect) {
    String hintText;
    if (type == "effect")
      hintText = "효과에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if (type == "sideEffect") hintText = "부작용에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    double bottom = 20;
    if (type == "overall") bottom = bottom + 70;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, bottom),
      // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      // padding: EdgeInsets.symmetric(
      //   vertical: 20,
      // ),
      child: Container(
          width: 400,
//                height: 100,
          child: TextField(
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: gray750_activated,
                ),
            maxLength: 500,
            decoration: new InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: gray300_inactivated,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: gray75),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(4.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary300_main),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(4.0)),
              ),
              filled: true,
              fillColor: gray50,
            ),
            controller: myControllerEffect,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            // dd
          )),
    );
  }

  Widget _edit(Review review) {
    String _warning = '';
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: IYMYSubmitButton(
          context: context,
          isDone: true,
          textString: '완료',
          onPressed: () async {
            if (sideEffect == "no")
              myControllerSideEffect.text = "";
            else if (sideEffect ==
                "yes") if (myControllerSideEffect.text.length < 10)
              _warning = "부작용에 대한 리뷰를 10자 이상 \n작성해주세요";
            if (myControllerEffect.text.length < 10)
              _warning = "효과에 대한 리뷰를 10자 이상 작성해주세요";
            if ((myControllerSideEffect.text.length < 10 &&
                    sideEffect == "yes") ||
                myControllerEffect.text.length < 10)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    _warning,
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            else {
              await ReviewService(documentId: widget.review.documentId)
                  .updateReviewData(
                effect /*?? review.effect*/,
                sideEffect /*?? review.sideEffect*/,
                myControllerEffect.text /*?? review.effectText*/,
                myControllerSideEffect.text /*?? review.sideEffectText*/,
                starRating == 0 ? review.starRating : starRating,
                /*?? value.starRating*/
              );

              ///
              var numOfReviews = 0.0;
              var totalRating = 0.0;

              var numOfEffectBad = 0.0;
              var numOfEffectSoSo = 0.0;
              var numOfEffectGood = 0.0;
              var numOfSideEffectYes = 0.0;
              var numOfSideEffectNo = 0.0;

              // StreamBuilder<Drug>(
              //     stream: DatabaseService(itemSeq: review.seqNum).drugData,
              //     builder: (context, snpashot) {
              //       if (snpashot.hasData) {
              //         Drug drug = snpashot.data;

              //         numOfReviews = drug.numOfReviews * 1.0;
              //         totalRating = drug.totalRating * 1.0;

              //         numOfEffectBad = drug.numOfEffectBad * 1.0;
              //         numOfEffectSoSo = drug.numOfEffectSoSo * 1.0;
              //         numOfEffectGood = drug.numOfEffectGood * 1.0;
              //         numOfSideEffectYes = drug.numOfSideEffectYes * 1.0;
              //         numOfSideEffectNo = drug.numOfSideEffectNo * 1.0;
              //         if (numOfEffectBad == null) {
              //           numOfEffectBad = 0.0;
              //           numOfEffectSoSo = 0.0;
              //           numOfEffectGood = 0.0;
              //           numOfSideEffectYes = 0.0;
              //           numOfSideEffectNo = 0.0;
              //         }
              //         FirebaseFirestore.instance
              //             // .collection("TestDrugs")
              //             .collection("Drugs")
              //             .doc(review.seqNum)
              //             .update({
              //           "totalRating": starRating == 0
              //               ? review.starRating
              //               : (totalRating * numOfReviews -
              //                       review.starRating +
              //                       starRating) /
              //                   numOfReviews,
              //           "numOfEffectBad":
              //               numOfEffectBad - isOriginEffectBad + isEffectBad,
              //           "numOfEffectSoSo":
              //               numOfEffectSoSo - isOriginEffectSoSo + isEffectSoSo,
              //           "numOfEffectGood":
              //               numOfEffectGood - isOriginEffectGood + isEffectGood,
              //           "numOfSideEffectYes": numOfSideEffectYes -
              //               isOriginSideEffectYes +
              //               isSideEffectYes,
              //           "numOfSideEffectNo": numOfSideEffectNo -
              //               isOriginSideEffectNo +
              //               isSideEffectNo,
              //         });
              //         return Container();
              //       } else {
              //         return Container();
              //       }
              //     });

              var collection =
                  // FirebaseFirestore.instance.collection('TestDrugs');
                  FirebaseFirestore.instance.collection('Drugs');
              var docSnapshot = await collection.doc(review.seqNum).get();
              if (docSnapshot.exists) {
                Map<String, dynamic> data = docSnapshot.data();
                numOfReviews = data['numOfReviews'] * 1.0;
                totalRating = data['totalRating'] * 1.0;

                numOfEffectBad = data['numOfEffectBad'] * 1.0;
                numOfEffectSoSo = data['numOfEffectSoSo'] * 1.0;
                numOfEffectGood = data['numOfEffectGood'] * 1.0;
                numOfSideEffectYes = data['numOfSideEffectYes'] * 1.0;
                numOfSideEffectNo = data['numOfSideEffectNo'] * 1.0;

                await FirebaseFirestore.instance
                    // .collection("TestDrugs")
                    .collection("Drugs")
                    .doc(review.seqNum)
                    .update({
                  "totalRating": starRating == 0
                      ? review.starRating
                      : (totalRating * numOfReviews -
                              review.starRating +
                              starRating) /
                          numOfReviews,
                  "numOfEffectBad":
                      numOfEffectBad - isOriginEffectBad + isEffectBad,
                  "numOfEffectSoSo":
                      numOfEffectSoSo - isOriginEffectSoSo + isEffectSoSo,
                  "numOfEffectGood":
                      numOfEffectGood - isOriginEffectGood + isEffectGood,
                  "numOfSideEffectYes": numOfSideEffectYes -
                      isOriginSideEffectYes +
                      isSideEffectYes,
                  "numOfSideEffectNo":
                      numOfSideEffectNo - isOriginSideEffectNo + isSideEffectNo,
                });
              }

              ///

              Navigator.pop(context);
              editSwitch = true;
              // IYMYGotoSeeOrCheckDialog(review.seqNum);
            }
          },
        ),
      ),
    );
  }

  Future<void> _IYMYCancleConfirmReportDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              /* BODY */
              Text("저장하지 않고 나가시겠어요?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* LEFT ACTION BUTTON */
                  ElevatedButton(
                    child: Text(
                      "취소",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  /* RIGHT ACTION BUTTON */
                  ElevatedButton(
                      child: Text(
                        "확인",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
