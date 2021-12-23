import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/edit_tip.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TipList extends StatefulWidget {
  String searchText;
  String filter;
  String drugItemSeq;
  String type;
  Tip tip;
  TipList(this.searchText, this.filter, this.drugItemSeq,
      {this.type, this.tip});

  @override
  _TipListState createState() => _TipListState();
}

class _TipListState extends State<TipList> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return widget.type == "mine"
        ? ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildListItemTips(context, widget.tip);
            },
          )
        : StreamBuilder<List<Tip>>(
            stream: TipService().getTips(widget.drugItemSeq),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Tip> tips = snapshot.data;
                List<Tip> searchResults = [];
                for (Tip tip in tips) {
                  //if (tip.effectText.contains(widget.searchText) ||
                  //  tip.sideEffectText.contains(widget.searchText)) {
                  searchResults.add(tip);
                  //}
                }
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildListItemTips(context, searchResults[index]);
                  },
                );
              } else
                return Loading();
            },
          );
  }

  Widget _buildListItemTips(BuildContext context, Tip tip) {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(tip.favoriteSelected);

    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 21.5),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.6, color: gray75))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _dateAndMenu(context, auth, tip),
          _tip(tip),
          Container(height: 11.5),
        ]));
  }

  Widget IYMYGotoSeeOrCheckDialog(alertContent) {
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
              Icon(Icons.check, color: primary300_main),
              SizedBox(height: 13),
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    TextSpan(text: alertContent),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '주말, 공휴일에는 확인이 지연될 수 있습니다',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: gray300_inactivated),
                    ),
                  ],
                ),
              ),
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

  Widget _dateAndMenu(context, auth, Tip tip) {
    TheUser user = Provider.of<TheUser>(context);

    String _regDate =
        DateFormat('yyyy.MM.dd').format(tip.registrationDate.toDate());

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
      child: Row(
        children: [
          Text(_regDate,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: gray500, fontSize: 12)),
          Expanded(child: Container()),
          IconButton(
            padding: EdgeInsets.only(right: 0),
            icon: Icon(Icons.more_horiz, color: gray500, size: 19),
            onPressed: () {
              if (user.uid == tip.uid) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return _popUpMenu(tip);
                    });
              } else if (auth.currentUser.uid != tip.uid) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return _popUpMenuAnonymous(tip, user);
                    });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _tip(tip) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(height: 6),
          TipBox(context: context, tip: tip),
          // Container(height: 6),

/*          //overall
          widget.filter == "sideEffectOnly" || widget.filter == "effectOnly"
              ? Container()
              // : _reviewBox(review, "overall"),
              : review.overallText == ""
                  ? Container()
                  : ReviewBox(
                      context: context, review: review, type: ""),
          review.overallText == "" ? Container() : Container(height: 6),*/
        ],
      ),
    );
  }

  Widget _popUpMenu(tip) {
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
              padding: const EdgeInsets.only(top: 8.0),
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
              // padding: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _IYMYCancleConfirmDeleteDialog(
                      tip,
                    );
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

  Widget _popUpMenuAnonymous(tip, user) {
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
              // padding: const EdgeInsets.only(top: 4.0),
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return _reportTipPopup(tip /*, user*/);
                        });
                  },
                  child: Center(
                      child: Text(
                    "신고하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
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
                      "취소",
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

  Widget _reportTipPopup(
    review,
  ) {
    var mqWidth = MediaQuery.of(context).size.width;
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text("약사의 한마디 신고하기",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: primary500_light_text, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              // padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.6 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        1, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "광고, 홍보 / 거래 시도",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        2, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "욕설, 음란어 사용",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        3, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "약과 무관한 리뷰 작성",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        4, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "개인 정보 노출",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        5, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "기타 (명예훼손)",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                // height: (mqWidth*0.6)/4.5,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
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

  Future<void> _IYMYCancleConfirmDeleteDialog(record) async {
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
                        await TipService(documentId: record.documentId)
                            .deleteTipData();
                        Navigator.of(context).pop();
                        if (widget.type == "mine") Navigator.of(context).pop();

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

  Future<void> _IYMYCancleConfirmReportDialog(
    tip,
    report,
    /*user*/
  ) async {
    User user = FirebaseAuth.instance.currentUser;

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
              Text("신고하시겠어요?",
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
                        await TipService(documentId: tip.documentId)
                            .reportTip(tip, report, user.uid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        IYMYGotoSeeOrCheckDialog("이약모약 운영진에게\n신고가 접수되었어요");

                        // var reviewReported = await ReviewService(documentId: review.documentId).checkReviewIsReported();
                        //
                        // if(reviewReported == false) {
                        //   await ReviewService(documentId: review.documentId).reportReview(review, report, user.uid);
                        //   Navigator.of(context).pop();
                        //   IYMYGotoSeeOrCheckDialog("이약모약 운영진에게\n신고가 접수되었어요");
                        // }
                        //
                        // else if(reviewReported == true) {
                        //   await ReviewService(documentId: review.documentId).reportAlreadyReportedReview(review, user.uid, report);
                        //   Navigator.of(context).pop();
                        //   IYMYGotoSeeOrCheckDialog("이미 해당 리뷰를 신고하셨습니다");
                        // }
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

class TipBox extends StatelessWidget {
  final BuildContext context;
  final Tip tip;

  const TipBox({
    Key key,
    // this.context,
    @required this.context,
    @required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return
        //Card();

        Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            elevation: 5,
            shadowColor: Color(0xFF000000).withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // if you need this
              side: BorderSide(
                color: Color(0xFFE4E5E5),
                width: 1,
              ),
            ),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tip.content,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray700),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 12),
                    _likeButton(tip, auth)
                  ],
                )));
  }

  Widget _likeButton(Tip tip, FirebaseAuth auth) {
    bool isFavorite =
        List.from(tip.favoriteSelected).contains(auth.currentUser.uid);
    return Container(
      height: 28,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 13),
            side: BorderSide(
                width: 1.0,
                color: isFavorite ? Color(0xFF00C2AE) : Color(0xFFE4E5E5))),
        icon: Icon(
          Icons.thumb_up_alt,
          size: 18,
          color: isFavorite ? primary300_main : gray300_inactivated,
        ),
        label: Row(
          children: [
            Text("도움이 됐어요", style: Theme.of(context).textTheme.caption),
            SizedBox(width: 4),
            Text(
              tip.favoriteCount.toString(),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        onPressed: () async {
          if (isFavorite) {
            /* 이미 like 눌렀을 때 > dislike로 */
            await TipService(documentId: tip.documentId)
                .decreaseFavorite(tip.documentId, auth.currentUser.uid);
          } else {
            /* like로 */
            await TipService(documentId: tip.documentId)
                .increaseFavorite(tip.documentId, auth.currentUser.uid);
          }
        },
      ),
    );

    // return Container(
    //   child: new Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       new GestureDetector(
    //           child: new Icon(
    //             // names.contains(auth.currentUser.uid)
    //             true ? Icons.thumb_up_alt : Icons.thumb_up_alt,
    //             color: true
    //                 //names.contains(auth.currentUser.uid)
    //                 ? primary400_line
    //                 : Color(0xffDADADA),
    //             size: 20,
    //           ),
    //           onTap: () async {
    //             // if (names.contains(auth.currentUser.uid)) {
    //             //   await ReviewService(documentId: review.documentId)
    //             //       .decreaseFavorite(
    //             //           review.documentId, auth.currentUser.uid);
    //             // } else {
    //             //   await ReviewService(documentId: review.documentId)
    //             //       .increaseFavorite(
    //             //           review.documentId, auth.currentUser.uid);
    //             // }
    //           })
    //     ],
    //   ),
    // );
  }
}
