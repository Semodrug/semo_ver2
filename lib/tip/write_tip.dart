import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/review_pill_info.dart';
import 'package:semo_ver2/tip/see_my_tip.dart';
import 'package:semo_ver2/tip/tip.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

class WriteTip extends StatefulWidget {
  String drugItemSeq;
  WriteTip({this.drugItemSeq});

  @override
  _WriteTipState createState() => _WriteTipState();
}

class _WriteTipState extends State<WriteTip> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final myControllerTip = TextEditingController();

  @override
  void dispose() {
    myControllerTip.dispose();
    super.dispose();
  }

  final firestoreInstance = Firestore.instance;

  String content = '';
  List favoriteSelected = [];
  int favoriteCount = 0;
  DateTime regDate = DateTime.now();
  String _entpName = ''; //약 제조사
  String _itemName = ''; //약

  void setItemNames(itemName, entpName) {
    _itemName = itemName;
    _entpName = entpName;
  }

  void _registerTip(pharmacistName, pharmacistDate) {
    FirebaseFirestore.instance.collection("TestTips").add({
      "content": content,
      "uid": auth.currentUser.uid,
      "pharmacistName": pharmacistName,
      "pharmacistDate": pharmacistDate,
      "favoriteSelected": favoriteSelected,
      "favoriteCount": favoriteCount,
      "registrationDate": DateTime.now(),
      "seqNum": widget.drugItemSeq,
      "entpName": _entpName,
      "itemName": _itemName,
    });
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        backgroundColor: gray0_white,
        // appBar: CustomAppBarWithGoToBack('리뷰 쓰기', Icon(Icons.close), 3),
        appBar: AppBar(
          title: Text(
            "약사의 한마디 쓰기",
            style:
                Theme.of(context).textTheme.headline5.copyWith(color: gray800),
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
        body: ChangeNotifierProvider(
            create: (context) => Tip(),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: <Widget>[
                  ReviewPillInfo(widget.drugItemSeq),
                  _tip(),
                  _submit(),
                ],
              ),
            )));
  }

  Widget _tip() {
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
          //height: 600,
          child: TextField(
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: gray750_activated,
                  ),
              maxLength: 500,
              controller: myControllerTip,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                hintText:
                    "약사님의 노하우를 나눠주세요 :)\n\n예시\n* 이 약을 복용하기 전 알아야 하는 상식\n* 어떤 사람들에게 이 약을 추천하는지\n* 어떤 사람들이 이 약을 주의해야하는지\n* 함께 복용하면 좋은 약/영양제/식품\n* 함께 복용하면 안되는 약/영양제/식품",
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
              ))),
    );
  }

  Widget _submit() {
    TheUser user = Provider.of<TheUser>(context);

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
              String pharmacistName = await DatabaseService(uid: user.uid)
                  .getPharmacistName(user.uid);
              String pharmacistDate = await DatabaseService(uid: user.uid)
                  .getPharmacistDate(user.uid);
              _registerTip(pharmacistName, pharmacistDate);

              Navigator.pop(context);
              IYMYGotoSeeOrCheckDialog();
            }
          },
        ),
      ),
    );
  }

  //TODO:    - [ ] 작성한 리뷰 보러가기 - edit review
  Widget IYMYGotoSeeOrCheckDialog() {
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
                    TextSpan(text: "약사의 한마디 작성이 완료되었습니다"),
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
                            builder: (context) =>
                                SeeMyTip(widget.drugItemSeq)));
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

  Future<void> _IYMYCancleConfirmReportDialog() async {
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
}
