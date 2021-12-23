import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/ranking/Provider/drugs_controller.dart';
import 'package:semo_ver2/review/see_my_review.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/review/review_pill_info.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

class EditTip extends StatefulWidget {
  Tip tip;
  String editOrWrite;
  EditTip(this.tip, this.editOrWrite);

  _EditTipState createState() => _EditTipState();
}

class _EditTipState extends State<EditTip> {
  final myControllerTip = TextEditingController();

  @override
  void dispose() {
    myControllerTip.dispose();
    super.dispose();
  }

  String content = '';
  String originContent = '';
  bool editSwitch = false;
  DrugsController drugsProvider;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tip>(
        stream: TipService().getSingleTip(widget.tip.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Tip tip = snapshot.data;

            // starRating = review.starRating;
            content = tip.content;
            originContent = tip.content;

            if (editSwitch == false) {
              myControllerTip.text = tip.content;
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
                  child: ListView(
                    children: <Widget>[
                      ReviewPillInfo(tip.seqNum),
                      _tip(tip),
                      _edit(tip),
                    ],
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
                    TextSpan(text: "약사의 한마디 수정이 완료되었습니다"),
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
                          "내가 작성한 약사의 한마디 보러가기",
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

  Widget _tip(Tip tip) {
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
            Text("이 약에 대해 알려주세요",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 16)),
            _textFieldForTip(myControllerTip)
          ],
        ));
  }

  Widget _textFieldForTip(TextEditingController myControllerTip) {
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
              controller: myControllerTip,
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

  Widget _edit(Tip tip) {
    String _warning = '';
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: IYMYSubmitButton(
          context: context,
          isDone: true,
          textString: '완료',
          onPressed: () async {
            content = myControllerTip.text;

            if (content.length < 10)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "약사의 한마디를 10자 이상 작성해주세요",
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            else {
              await TipService(documentId: widget.tip.documentId)
                  .updateTipData(content /*?? content.effect*/
                      );

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
