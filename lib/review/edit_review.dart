import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/review/see_my_review.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/review_pill_info.dart';
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
  TextEditingController myControllerOverall = TextEditingController();

  TextEditingController reasonForTakingPillController = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    myControllerOverall.dispose();
    super.dispose();
  }

  String effect = '';
  String sideEffect = '';
  double starRating = 0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';
  String starRatingText = '';
  String reasonForTakingPill = '';

  bool editSwitch = false;

//  String editOrWrite = 'edit'; // 'write'

  String _shortenName(String drugName) {
    String newName;
    List splitName = [];

    if (drugName.contains('(')) {
      splitName = drugName.split('(');
      newName = splitName[0];
      return newName;
    } else
      return drugName;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Review>(
        stream: ReviewService().getSingleReview(widget.review.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Review review = snapshot.data;

            if (effect == '') effect = review.effect;
            if (sideEffect == '') sideEffect = review.sideEffect;
            if (editSwitch == false) {
              myControllerEffect.text = review.effectText;
              myControllerSideEffect.text = review.sideEffectText;
              myControllerOverall.text = review.overallText;
              reasonForTakingPillController.text = review.reasonForTakingPill;
              editSwitch = true;
            }

            return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: gray0_white,
                appBar: AppBar(
                  title: Text(
                    "리뷰 쓰기",
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
                      // Navigator.pop(context);
                    },
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: <Widget>[
                      ReviewPillInfo(review.seqNum),
                      // _pillInfo(review),
                      _rating(review),
                      _reasonForTakingPill(review),
                      _effect(review),
                      _sideEffect(review),
                      _overallReview(review),
                      _edit(review),
//                      Padding(padding: EdgeInsets.only(top: 35)),
                    ],
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  Future<void> _IYMYCheckDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                      onPressed: () {
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

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
// //          title: Center(child: Text('AlertDialog Title')),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Center(child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     TextButton(
//                       child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     TextButton(
//                       child: Text('삭제',style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         await ReviewService(documentId: record.documentId).deleteReviewData();
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
  }

  Widget IYMYGotoSeeOrCheckDialog(drugItemSeq) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  Widget _pillInfo(review) {
    //TODO: Bring pill information
    return Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 12,
          color: gray50,
        ))),
        child: Row(
          children: <Widget>[
//            Container(
//              width: 100, height: 100,
//              color: Colors.teal[100],
//            ),
            SizedBox(
              child: DrugImage(drugItemSeq: review.seqNum),
              width: 88.0,
            ),
            Padding(padding: EdgeInsets.only(left: 15)),

            // Text(widget.review.effectText),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<Drug>(
                    stream:
                        DatabaseService(itemSeq: widget.review.seqNum).drugData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Drug drug = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drug.entpName,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        color: gray300_inactivated,
                                        fontSize: 10)),
                            Container(
                              width: MediaQuery.of(context).size.width - 155,
                              padding: new EdgeInsets.only(right: 10.0),
                              child: Text(_shortenName(drug.itemName),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: gray900)),
                            ),
                            Container(
                              height: 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  itemSize: 16,
                                  initialRating: drug.totalRating,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: gray75,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => ImageIcon(
                                    AssetImage('assets/icons/star.png'),
                                    color: yellow,
                                  ),
                                ),
                                Container(width: 5),
                                Text(
                                  drug.totalRating.toStringAsFixed(2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: gray900, fontSize: 12),
                                ),
                                Container(width: 3),
                                Text(
                                    "(" +
                                        drug.numOfReviews.toStringAsFixed(0) +
                                        "개)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                            color: gray300_inactivated,
                                            fontSize: 10)),
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
                        return Container();
                    }),
              ],
            )
          ],
        ));
  }

  Widget _rating(Review review) {
    return Container(
//          height: 150,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
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
//              unratedColor: Colors.grey[500],
              unratedColor: gray75,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) =>
//                   Icon(Icons.star,
// //                color: Colors.amber[300],
//                   color: primary300_main),
                  Image.asset(
                'assets/icons/rating_star.png',
                width: 28,
                height: 28,
              ),

              onRatingUpdate: (rating) {
                starRating = rating;
                setState(() {
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

  Widget _reasonForTakingPill(Review review) {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("어디가 아파서 사용하셨나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            _textField("reason", reasonForTakingPillController),
            // _exclusiveMultiButton(),
            // writeReason(),
            Container(
              height: 45,
            )
            // _textField(myControllerEffect)
          ],
        ));
  }

  Widget _exclusiveMultiButton() {
    return ButtonTheme(
      minWidth: 40.0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: primary300_main)),
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        onPressed: () {
          setState(() {});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("buttonName",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: primary500_light_text,
                    )),
            Container(
              width: 1,
            ),
            Icon(
              Icons.cancel,
              color: gray200,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget writeReason() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: TextField(
        controller: reasonForTakingPillController,
        cursorColor: primary400_line,
        decoration: textInputDecoration.copyWith(
            hintText: '키워드 하나 입력하기   예시)치통',
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: InkWell(
                child: Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: gray200,
                        ),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                        ),
                        Center(child: Text("추가")),
                      ],
                    )),
                onTap: () {
                  reasonForTakingPillController.clear();
                },
              ),
            )

            // Padding(
            //   // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            //   padding: const EdgeInsets.fromLTRB(15,5,15,5),
            //   child: Container(
            //     height: 10,
            //     // width: 40,
            //     child: RaisedButton(
            //       onPressed: () {},
            //       child: Text('확인'),
            //     ),
            //   ),
            // ),
            ),
        // suffixIcon: RaisedButton(
        //   onPressed: () {},
        //   child: new Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       new Text('Button with text and icon!'),
        //       new Icon(Icons.lightbulb_outline),
        //     ],
        //   ),
        // ),

        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _effect(Review review) {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
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
    else if (type == "sideEffect")
      hintText = "부작용에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if (type == "overall")
      hintText = "전체적인 만족도에 대한 후기를 남겨주세요(선택)\n";
    else if (type == "reason") hintText = "키워드 하나를 입력해주세요  예시)치통\n";
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
            maxLength: type == "reason" ? 10 : 500,
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

  Widget _overallReview(Review review) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
//          height: 300,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약에 대한 총평",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            _textField("overall", myControllerOverall),
//            Padding(padding: EdgeInsets.only(top: 25)),
          ],
        ));
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
            if (myControllerOverall.text.length < 10 &&
                myControllerOverall.text.length > 0)
              _warning = "총평 리뷰를 10자 이상 작성해주세요";
            // if(sideEffect == "yes" && myControllerSideEffect.text.length < 10)
            // // if (myControllerSideEffect.text.length < 10 && sideEffect!= "no")
            //   _warning = "부작용에 대한 리뷰를 10자 이상 \n작성해주세요";
            if (myControllerEffect.text.length < 10)
              _warning = "효과에 대한 리뷰를 10자 이상 작성해주세요";
            if (reasonForTakingPillController.text.length < 1)
              _warning = "어디가 아파서 사용하셨는지 작성해주세요";

            if (myControllerOverall.text.length < 10 &&
                    myControllerOverall.text.length > 0 ||
                (myControllerSideEffect.text.length < 10 &&
                    sideEffect == "yes") ||
                myControllerEffect.text.length < 10 ||
                reasonForTakingPillController.text.length < 1)
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
                      myControllerOverall.text /*?? review.overallText*/,
                      starRating == 0 ? review.starRating : starRating,
                      /*?? value.starRating*/
                      reasonForTakingPillController.text);
              Navigator.pop(context);
              editSwitch = true;
              IYMYGotoSeeOrCheckDialog(review.seqNum);
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
