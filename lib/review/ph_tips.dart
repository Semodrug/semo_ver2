import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/models/pharmacist_tips.dart';
import 'package:semo_ver2/services/pharmacist_tips.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhTipsList extends StatefulWidget {
  String drugItemSeq;
  PhTip phTip;
  PhTipsList(this.drugItemSeq, this.phTip);

  @override
  _PhTipsListState createState() => _PhTipsListState();
}

class _PhTipsListState extends State<PhTipsList> {
  @override
  Widget build(BuildContext context) {
    StreamBuilder<List<PhTip>>(
            stream: PhTipService().getPhTips(widget.drugItemSeq),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PhTip> phTips = snapshot.data;
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: phTips.length,
                  itemBuilder: (context, index) {
                    // return _buildListItem(context, phTips[index]);
                  },
                );
              } else
                return Loading();
            },
          );
  }

  //
  // Widget _buildListItem(BuildContext context, PhTip phtip) {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   List<String> names = List.from(phtip.favoriteSelected);
  //
  //   return Container(
  //       padding: EdgeInsets.fromLTRB(0, 10, 0, 21.5),
  //       decoration: BoxDecoration(
  //           border: Border(bottom: BorderSide(width: 0.6, color: gray75))),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         _review(review),
  //         Container(height: 11.5),
  //         _dateAndFavorite(
  //             DateFormat('yyyy.MM.dd').format(review.registrationDate.toDate()),
  //             names,
  //             auth,
  //             review)
  //       ]));
  // }
  //
  //
  // Widget _review(review) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         ReviewBox(context: context, review: review, type: "reason"),
  //         Container(height: 6),
  //
  //         //effect
  //         widget.filter == "sideEffectOnly"
  //             ? Container()
  //             // : _reviewBox(review, "effect"),
  //             : ReviewBox(context: context, review: review, type: "effect"),
  //         Container(height: 6),
  //
  //         //side effect
  //         widget.filter == "effectOnly"
  //             ? Container()
  //             // : _reviewBox(review, "sideEffect"),
  //             : ReviewBox(context: context, review: review, type: "sideEffect"),
  //         Container(height: 6),
  //
  //         //overall
  //         widget.filter == "sideEffectOnly" || widget.filter == "effectOnly"
  //             ? Container()
  //             // : _reviewBox(review, "overall"),
  //             : review.overallText == ""
  //                 ? Container()
  //                 : ReviewBox(
  //                     context: context, review: review, type: "overall"),
  //         review.overallText == "" ? Container() : Container(height: 6),
  //       ],
  //     ),
  //   );
  // }

}
