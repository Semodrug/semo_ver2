import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/review/edit_review.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/dialog.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/review/review_box.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:semo_ver2/tip/edit_tip.dart';
import 'package:semo_ver2/tip/tip_list.dart';

class MyTips extends StatefulWidget {
  @override
  _MyTipsState createState() => _MyTipsState();
}

class _MyTipsState extends State<MyTips> {
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
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack('약사의 한마디', Icon(Icons.arrow_back), 0.5),
        backgroundColor: gray0_white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: StreamBuilder<List<Review>>(
                stream: ReviewService().getUserReviews(user.uid.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Review> reviews = snapshot.data;
                    return StreamBuilder<List<Tip>>(
                        stream:
                            TipService().getPharmacistTips(user.uid.toString()),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            List<Tip> tips = snapshot2.data;
                            // print(tips.length);
                            // print(reviews.length);
                            int count = tips.length + reviews.length;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                  child: Text(
                                      "약사의 한마디 & 리뷰 " + count.toString() + "개"),
                                ),
                                Divider(
                                  color: gray75,
                                  height: 1,
                                ),
                                (reviews.length == 0 && tips.length == 0)
                                    ? Container(
                                        height: 310,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 30,
                                            ),
                                            Image.asset(
                                              'assets/images/no_review.png',
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Text("아직 작성된 리뷰가 없어요")
                                          ],
                                        ))
                                    : // ReviewList(_searchText, "all", widget.drugItemSeq),
                                    Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: tips.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _tip(
                                                    context, tips[index]);
                                              }),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: reviews.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _review(
                                                    context, reviews[index]);
                                              }),
                                        ],
                                      ),
                              ],
                            );
                          } else
                            return Loading();
                        });
                  } else
                    return Loading();
                },
              ),
            )
          ],
        ));
  }

  Widget _tip(BuildContext context, tip) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(tip.seqNum),
          ),
        ),
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.6, color: gray75),
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 60,
                      child: DrugImage(drugItemSeq: tip.seqNum),
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          color: gray300_inactivated,
                          size: 16,
                        ),
                        Container(
                          width: 5,
                        ),
                        Text(tip.favoriteCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: gray400, fontSize: 12))
                      ],
                    )
                  ],
                ),
                Container(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 95,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tip.entpName,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(
                                      color: gray300_inactivated,
                                      fontSize: 11)),
                          Container(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 143,
                            child: Text(_shortenName(tip.itemName),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: gray900, fontSize: 14)),
                          ),
                          Container(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text('약사의 한마디',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 12)),
                              Container(
                                width: 4.5,
                              ),
                              Text(
                                  DateFormat('yy.MM.dd')
                                      .format(tip.registrationDate.toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        padding: EdgeInsets.only(right: 0),
                        // constraints: BoxConstraints(),
                        icon: Icon(Icons.more_horiz, color: gray500, size: 19),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return _popUpMenuforTip(tip);
                              });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(60, 0, 16, 0),
              child: Column(
                children: [
                  Container(height: 4),
                  TipBox(context: context, tip: tip),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _review(BuildContext context, review) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(review.seqNum),
          ),
        ),
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.6, color: gray75),
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 60,
                      child: DrugImage(drugItemSeq: review.seqNum),
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          color: gray300_inactivated,
                          size: 16,
                        ),
                        Container(
                          width: 5,
                        ),
                        Text(review.noFavorite.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: gray400, fontSize: 12))
                      ],
                    )
                  ],
                ),
                Container(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 95,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.entpName,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(
                                      color: gray300_inactivated,
                                      fontSize: 11)),
                          Container(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 143,
                            child: Text(_shortenName(review.itemName),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: gray900, fontSize: 14)),
                          ),
                          Container(
                            height: 2,
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: review.starRating * 1.0,
                                itemBuilder: (context, index) => Icon(
                                  // _selectedIcon ??
                                  Icons.star,
                                  color: yellow,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                                unratedColor: gray75,
                                //unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                              ),
                              Container(
                                width: 4.5,
                              ),
                              Text(
                                  DateFormat('yy.MM.dd')
                                      .format(review.registrationDate.toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        padding: EdgeInsets.only(right: 0),
                        // constraints: BoxConstraints(),
                        icon: Icon(Icons.more_horiz, color: gray500, size: 19),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return _popUpMenuforReview(review);
                              });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(60, 0, 16, 0),
              child: Column(
                children: [
                  Container(height: 6),
                  ReviewBox(context: context, review: review, type: "effect"),
                  Container(height: 6),
                  ReviewBox(
                      context: context, review: review, type: "sideEffect"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //   Text(
    //   review.effectText.toString(),
    // );
  }

  Widget _popUpMenuforReview(
    review,
  ) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditReview(review, "edit")));
                  },
                  child: Center(
                      child: Text(
                    "수정하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDeleteDialogforReview(review);
                  },
                  child: Center(
                      child: Text(
                    "삭제하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            // Divider(thickness: 1, color: gray100),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(color: Theme.of(context).hintColor),
                      top: BorderSide(color: gray100)),
                ),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "닫기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray300_inactivated),
                    ))),
              ),
            )
          ],
        ));
  }

  Future<void> _showDeleteDialogforReview(record) async {
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
              Text("선택한 리뷰를 삭제하시겠어요?",
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
                    onPressed: () async {
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
                        var reviewCollection =
                            FirebaseFirestore.instance.collection('Reviews');
                        var reviewDocSnapshot =
                            await reviewCollection.doc(record.documentId).get();
                        if (reviewDocSnapshot.exists) {
                          Map<String, dynamic> data = reviewDocSnapshot.data();
                          var effect = data['effect'];
                          var sideEffect = data['sideEffect'];
                          var starRating = data['starRating'] * 1.0;

                          var drugCollection = FirebaseFirestore.instance
                              // .collection('TestDrugs');
                              .collection('Drugs');
                          var docSnapshot =
                              await drugCollection.doc(record.documentId).get();
                          if (docSnapshot.exists) {
                            Map<String, dynamic> drugData = docSnapshot.data();
                            var numOfReviews = drugData['numOfReviews'] * 1.0;
                            var totalRating = drugData['totalRating'] * 1.0;
                            var numOfEffectBad =
                                drugData['numOfEffectBad'] * 1.0;
                            var numOfEffectSoSo =
                                drugData['numOfEffectSoSo'] * 1.0;
                            var numOfEffectGood =
                                drugData['numOfEffectGood'] * 1.0;
                            var numOfSideEffectYes =
                                drugData['numOfSideEffectYes'] * 1.0;
                            var numOfSideEffectNo =
                                drugData['numOfSideEffectNo'] * 1.0;

                            FirebaseFirestore.instance
                                // .collection("TestDrugs")
                                .collection("Drugs")
                                .doc(record.seqNum)
                                .update({
                              "totalRating": numOfReviews - 1 <= 0.0
                                  ? 0.0
                                  : (totalRating * numOfReviews -
                                          record.starRating) /
                                      (numOfReviews - 1),
                              "numOfReviews": numOfReviews - 1 <= 0.0
                                  ? 0.0
                                  : numOfReviews - 1,
                              'numOfEffectBad': effect == 'bad'
                                  ? numOfEffectBad - 1
                                  : numOfEffectBad,
                              'numOfEffectSoSo': effect == 'soso'
                                  ? numOfEffectSoSo - 1
                                  : numOfEffectSoSo,
                              'numOfEffectGood': effect == 'good'
                                  ? numOfEffectGood - 1
                                  : numOfEffectGood,
                              'numOfSideEffectYes': sideEffect == 'yes'
                                  ? numOfSideEffectYes - 1
                                  : numOfSideEffectYes,
                              'numOfSideEffectNo': sideEffect == 'no'
                                  ? numOfSideEffectNo - 1
                                  : numOfSideEffectNo,
                            });
                          }
                        }

                        // var collection =
                        //     FirebaseFirestore.instance.collection('Reviews');
                        // var reviewDocSnapshot =
                        //     await collection.doc(record.documentId).get();
                        // if (reviewDocSnapshot.exists) {
                        //   Map<String, dynamic> data = reviewDocSnapshot.data();
                        //   var effect = data['effect'];
                        //   var sideEffect = data['sideEffect'];
                        //   var starRating = data['starRating'] * 1.0;
                        //
                        //   var collection =
                        //       FirebaseFirestore.instance.collection('TestDrugs');
                        //   var docSnapshot =
                        //       await collection.doc(record.documentId).get();
                        //   if (docSnapshot.exists) {
                        //     var numOfReviews = data['numOfReviews'] * 1.0;
                        //     var totalRating = data['totalRating'] * 1.0;
                        //
                        //     FirebaseFirestore.instance
                        //         .collection("TestDrugs")
                        //         .doc(record.seqNum)
                        //         .update({
                        //       "totalRating": numOfReviews - 1 <= 0.0
                        //           ? 0.0
                        //           : (totalRating * numOfReviews -
                        //                   record.starRating) /
                        //               (numOfReviews - 1),
                        //       "numOfReviews": numOfReviews - 1 <= 0.0
                        //           ? 0.0
                        //           : numOfReviews - 1,
                        //     });
                        //   }
                        // }

                        await ReviewService(documentId: record.documentId)
                            .deleteReviewData();

                        Navigator.of(context).pop();

                        //OK Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Icon(Icons.check, color: primary300_main),
                                  SizedBox(height: 16),
                                  /* BODY */
                                  Text(
                                    "리뷰가 삭제되었습니다",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: gray700),
                                  ),
                                  SizedBox(height: 16),
                                  /* BUTTON */
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 0,
                                          primary: gray50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(color: gray75))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          },
                        );

                        // IYMYOkDialog(
                        //   context: context,
                        //   dialogIcon: Icon(Icons.check, color: primary300_main),
                        //   bodyString: '리뷰가 삭제되었습니다',
                        //   buttonName: '확인',
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //     Navigator.pop(context);
                        //   },
                        // ).showWarning();
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

  Widget _popUpMenuforTip(
    tip,
  ) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTip(tip, "edit")));
                  },
                  child: Center(
                      child: Text(
                    "수정하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDeleteDialogforTip(tip);
                  },
                  child: Center(
                      child: Text(
                    "삭제하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            // Divider(thickness: 1, color: gray100),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(color: Theme.of(context).hintColor),
                      top: BorderSide(color: gray100)),
                ),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "닫기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray300_inactivated),
                    ))),
              ),
            )
          ],
        ));
  }

  Future<void> _showDeleteDialogforTip(record) async {
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
              Text("선택한 약사의 한마디를 삭제하시겠어요?",
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
                    onPressed: () async {
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
                        await TipService(documentId: record.documentId)
                            .deleteTipData();

                        Navigator.of(context).pop();

                        //OK Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Icon(Icons.check, color: primary300_main),
                                  SizedBox(height: 16),
                                  /* BODY */
                                  Text(
                                    "약사의 한마디가 삭제되었습니다",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: gray700),
                                  ),
                                  SizedBox(height: 16),
                                  /* BUTTON */
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 0,
                                          primary: gray50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(color: gray75))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          },
                        );
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
