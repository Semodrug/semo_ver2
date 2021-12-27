import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:intl/intl.dart';

class AllPharMacistsTipScreen extends StatefulWidget {
  List<Tip> phTips;

  AllPharMacistsTipScreen({
    this.phTips,
  });

  @override
  _AllPharMacistsTipScreenState createState() =>
      _AllPharMacistsTipScreenState();
}

class _AllPharMacistsTipScreenState extends State<AllPharMacistsTipScreen> {
  final TextEditingController _filter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack(
            '약사의 한마디 전체보기', Icon(Icons.arrow_back), 0.5),
        backgroundColor: Colors.white,
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: widget.phTips.length,
                itemBuilder: (BuildContext context, int index) {
                  return tipCard(widget.phTips[index]);
                },
              ),
            )
          ],
        ));
  }

  Widget tipCard(Tip tip) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        elevation: 5,
        shadowColor: Color(0xFF000000).withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // if you need this
          side: BorderSide(
            color: Color(0xFFE4E5E5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height:width*0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tip.pharmacistName.length > 3
                              /* 이름 글자 수가 3글자 보다 길면 중간 두 글자 암호화하기 */
                              ? Text(
                                  tip.pharmacistName[0] +
                                      '**' +
                                      tip.pharmacistName.substring(3) +
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
                                      tip.pharmacistName.substring(2) +
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
                                  .format(tip.registrationDate.toDate()),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: gray400)),
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
              Text(
                tip.content,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray700),
              ),
              // Spacer(),
              SizedBox(height: 16),
              _likeButton(tip, auth)
            ],
          ),
        ));
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

  Widget _likeButton(tip, FirebaseAuth auth) {
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
          // if (isFavorite) {
          //   /* 이미 like 눌렀을 때 > dislike로 */
          //   await TipService(documentId: tip.documentId)
          //       .decreaseFavorite(tip.documentId, auth.currentUser.uid);
          // } else {
          //   /* like로 */
          //   await TipService(documentId: tip.documentId)
          //       .increaseFavorite(tip.documentId, auth.currentUser.uid);
          // }
        },
      ),
    );
  }
}
