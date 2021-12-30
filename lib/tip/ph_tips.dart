import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/tip/all_pharmacists_tip.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/ok_dialog.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:semo_ver2/tip/edit_tip.dart';

class PhTipsList extends StatefulWidget {
  final String drugItemSeq;
  String type;

  PhTipsList(this.drugItemSeq, this.type);

  @override
  _PhTipsListState createState() => _PhTipsListState();
}

class _PhTipsListState extends State<PhTipsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tip>>(
      stream: TipService().getTips(widget.drugItemSeq),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Tip> phTips = snapshot.data;
          return _pharmacistTip(context, phTips, widget.drugItemSeq);
        } else
          return Container();
      },
    );
  }

  Widget _pharmacistTip(
      BuildContext context, List<Tip> phTips, String drugItemSeq) {
    TheUser user = Provider.of<TheUser>(context);

    // print('Check user uid: ' + user.uid);
    return Container(
      // height: 300,
      color: gray50,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
      // margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "약사의 한마디",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextSpan(
                      text: '  ' + phTips.length.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: yellow),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              phTips.length == 0
                  ? _askTip(drugItemSeq, user.uid)
                  : _seeAll(drugItemSeq, phTips)
            ],
          ),

          // SizedBox(height: 20),

          CarouselSlider(
            options: CarouselOptions(
              height: phTips.length == 0 ? 16 : 260.0,
              // enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: phTips.length == 1 ? 1 : 0.8,
            ),
            items: phTips.map((tip) {
              return Builder(
                builder: (BuildContext context) {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  return phTips.length == 0
                      ? Container()
                      : Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          elevation: 5,
                          shadowColor: Color(0xFF000000).withOpacity(0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // if you need this
                            side: BorderSide(
                              color: Color(0xFFE4E5E5),
                              width: 1,
                            ),
                          ),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  user.uid == tip.uid
                                      ? IconButton(
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.more_horiz,
                                              color: gray500, size: 19),
                                          onPressed: () {
                                            if (user.uid == tip.uid) {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return _popUpMenu(tip);
                                                  });
                                            }
                                            // else if (auth.currentUser.uid !=
                                            //     tip.uid) {
                                            //   showModalBottomSheet(
                                            //       backgroundColor: Colors.transparent,
                                            //       context: context,
                                            //       builder: (context) {
                                            //         return _popUpMenuAnonymous(
                                            //             tip, user);
                                            //       });
                                            // }
                                          },
                                        )
                                      : Container(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(height:width*0.02),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/pharmacist.png',
                                                width: 36,
                                                height: 36,
                                              ),
                                              SizedBox(width: 16),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  tip.pharmacistName.length > 3
                                                      /* 이름 글자 수가 3글자 보다 길면 중간 두 글자 암호화하기 */
                                                      ? Text(
                                                          tip.pharmacistName[
                                                                  0] +
                                                              '**' +
                                                              tip.pharmacistName
                                                                  .substring(
                                                                      3) +
                                                              " 약사",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              .copyWith(
                                                                  //fontSize: 14,
                                                                  color:
                                                                      gray700))
                                                      /* 이름 글자 수가 3글자면 중간글자 하나만 암호화하기 */
                                                      : Text(
                                                          tip.pharmacistName[
                                                                  0] +
                                                              '*' +
                                                              tip.pharmacistName
                                                                  .substring(
                                                                      2) +
                                                              " 약사",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              .copyWith(
                                                                  //fontSize: 14,
                                                                  color:
                                                                      gray700)),
                                                  // SizedBox(height: 2),
                                                  Text(
                                                      DateFormat('yyyy.MM.dd')
                                                          .format(tip
                                                              .registrationDate
                                                              .toDate()),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              color: gray400)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 4),
                                          Column(
                                            children: [
                                              SizedBox(height: 4),
                                              _term(tip.pharmacistDate),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(tip.content,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(color: gray700),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis),
                                      Spacer(),
                                      _likeButton(tip, auth)
                                    ],
                                  ),
                                ],
                              )));
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _seeAll(String drugItemSeq, List<Tip> phTips) {
    return Row(
      children: [
        TextButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AllPharMacistsTipScreen(
                              widget.drugItemSeq, widget.type
                              //phTips: phTips
                              // infoEE: infoEE,
                              // infoNB: infoNB,
                              // infoUD: infoUD,
                              // storage: storage,
                              // entp_name: entpName
                              )));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => DetailInfo(
              //               drugItemSeq: drug.itemSeq,
              //             )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('전체보기',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: gray500, fontSize: 12)),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: gray500,
                  size: 20,
                )
              ],
            )),
      ],
    );
  }

  Widget _term(String pharmacistDate) {
    /* 현재 pharmacistDate 는 YYYY.MM.DD 형식이라서 .을 제외하고 새로 변수 선언 */
    String _pharDate = pharmacistDate.substring(0, 4) +
        pharmacistDate.substring(5, 7) +
        pharmacistDate.substring(8, 10);
    var _toDay = DateTime.now();

    /* 면허 날짜를 시간 타입으로 바꿔주고 현재시간과 뺄셈을 날짜로 계산 */
    int difference = int.parse(
        _toDay.difference(DateTime.parse(_pharDate)).inDays.toString());

    /* 연차 계산: 날짜 기준으로, [(오늘날짜 - 면허날짜) / 365] + 1 년차로 계산 */
    int term = difference ~/ 365 + 1;

    //print('difference is' + difference.toString());
    //print('term is' + term.toString());

    return TextButton(
      child: Text(term.toString() + '년차',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: primary600_bold_text)),
      style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(41, 20),
          padding: EdgeInsets.fromLTRB(6.4, 0, 5.6, 1.5),
          // elevation: 0,
          backgroundColor: gray50),
      onPressed: () {},
    );
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
            )
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
  }

  Widget _askTip(String drugItemSeq, String uid) {
    /* drugItemSeq으로 drug doc에 접근하여 askTipList에 이미 uid가 있는지 확인 */

    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            // print(drugItemSeq);
            // print(drug.askTipList);
            // print(uid);
            bool isAsked = List.from(drug.askTipList).contains(uid);
            return Container(
              height: 28,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    side: BorderSide(
                        width: 1.0,
                        color:
                            isAsked ? Color(0xFF00C2AE) : Color(0xFFE4E5E5))),
                icon: Icon(
                  isAsked ? Icons.check : Icons.priority_high_rounded,
                  size: 16,
                  color: isAsked ? primary300_main : gray300_inactivated,
                ),
                label: Row(
                  children: [
                    Text("요청하기", style: Theme.of(context).textTheme.caption),
                    SizedBox(width: 4),
                    Text(
                      snapshot.data.askTipList.length.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                onPressed: () async {
                  bool isExist = await DatabaseService(itemSeq: drugItemSeq)
                      .checkIfAskTipDocExists(drugItemSeq);
                  // print('isExist' + isExist.toString());
                  if (isAsked) {
                    /* 이미 like 눌렀을 때 > dislike로 */
                    await DatabaseService(itemSeq: drugItemSeq)
                        .removeFromAskTipList(drugItemSeq, uid);
                    /* DB: AskTips Collection update */
                    await DatabaseService()
                        .updateAskTipForRemove(drugItemSeq, uid);
                  } else {
                    /* like로 */
                    await DatabaseService(itemSeq: drugItemSeq)
                        .addToAskTipList(drugItemSeq, uid);
                    isExist
                        /* DB: AskTips Collection에 itemSeq Doc이 있으면 update */
                        ? await DatabaseService()
                            .updateAskTipForAdd(drugItemSeq, uid)
                        /* DB: AskTips Collection에 itemSeq Doc이 없으면 새로 만들기 */
                        : await DatabaseService()
                            .createAskTip(drug.itemName, drugItemSeq, uid);

                    IYMYOkDialog(
                      context: context,
                      dialogIcon: Icon(Icons.check, color: primary300_main),
                      bodyString: '요청이 완료되었습니다',
                      buttonName: '확인',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ).showWarning();
                  }
                },
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
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
}
