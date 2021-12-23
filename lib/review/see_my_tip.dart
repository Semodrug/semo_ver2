import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/tip_list.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/review/review_pill_info.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/services/tip_service.dart';

class SeeMyTip extends StatefulWidget {
  final String drugItemSeq;

  SeeMyTip(
    this.drugItemSeq,
  );

  @override
  _SeeMyTipState createState() => _SeeMyTipState();
}

class _SeeMyTipState extends State<SeeMyTip> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack("약사의 한마디", Icon(Icons.arrow_back), 0.5),
        backgroundColor: gray0_white,
        body: StreamBuilder<List<Tip>>(
            stream:
                TipService().findPharmacistTip(widget.drugItemSeq, user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Tip> tips = snapshot.data;
                // return Text(review[0].effectText);
                return ListView(
                  children: [
                    ReviewPillInfo(widget.drugItemSeq),
                    tips.length == 0
                        ? Container()
                        : TipList("", "none", widget.drugItemSeq,
                            type: "mine", tip: tips[0]),
                  ],
                );
              } else {
                print("FAIL");
                return Container();
              }
            }));
  }
}
