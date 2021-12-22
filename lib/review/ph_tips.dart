import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class PhTipsList extends StatefulWidget {
  final String drugItemSeq;
  PhTipsList(
    this.drugItemSeq,
    /*this.phTip*/
  );

  @override
  _PhTipsListState createState() => _PhTipsListState();
}

class _PhTipsListState extends State<PhTipsList> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('PharmacistTips');

  Future<void> addUser() {
    return users
        .add({
          'content':
              "매일 계속 사용하는것보다 3일 정도 사용하면 하루 쯤 쉬었다가 사용하는게 더 나아요 참고하세요", // John Doe
          'name': "세모", // Stokes and Sons
          'regDate': DateTime.now(),
          'seqNum': "200209700",
          //
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tip>>(
      stream: TipService().getTips(widget.drugItemSeq),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Tip> phTips = snapshot.data;
          return _pharmacistTip(phTips);
        } else
          return Container();
      },
    );
  }

  Widget _pharmacistTip(List<Tip> phTips) {
    // var width = MediaQuery.of(context).size.width;

    return Container(
      // height: 300,
      color: gray50,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
      // margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InkWell(
          //     child: Icon(
          //       Icons.arrow_back,),
          //   onTap: addUser,
          // ),
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
                ), // TODO: connect with DB
              ],
            ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      tip.pharmacistName[0] +
                                                          '**' +
                                                          tip.pharmacistName
                                                              .substring(3) +
                                                          " 약사",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          .copyWith(
                                                              //fontSize: 14,
                                                              color: gray700))
                                                  /* 이름 글자 수가 3글자면 중간글자 하나만 암호화하기 */
                                                  : Text(
                                                      tip.pharmacistName[0] +
                                                          '*' +
                                                          tip.pharmacistName
                                                              .substring(2) +
                                                          " 약사",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          .copyWith(
                                                              //fontSize: 14,
                                                              color: gray700)),
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
                              )));
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _term(String pharmacistDate) {
    var term = 3;

    // return Container(
    //   width: 41,
    //   height: 20,
    //   color: gray50,
    //   child: Center(
    //     child: Text(term.toString() + '년차',
    //         style: Theme.of(context)
    //             .textTheme
    //             .subtitle2
    //             .copyWith(color: primary600_bold_text)),
    //   ),
    // );

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
