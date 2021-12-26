import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/tip.dart';
import 'package:semo_ver2/mypage/pharmacist_auth.dart';
import 'package:semo_ver2/models/review.dart';

import 'package:semo_ver2/mypage/1_edit_privacy.dart';
import 'package:semo_ver2/mypage/2_edit_health.dart';
import 'package:semo_ver2/mypage/3_notice.dart';
import 'package:semo_ver2/mypage/4_inquiry.dart';
import 'package:semo_ver2/mypage/5_policy_terms.dart';
import 'package:semo_ver2/mypage/6_policy_privacy.dart';
import 'package:semo_ver2/mypage/7_others.dart';
import 'package:semo_ver2/mypage/case_recognition_list.dart';
import 'package:semo_ver2/mypage/my_reviews.dart';
import 'package:semo_ver2/mypage/my_favorites.dart';

import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/services/tip_service.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:semo_ver2/tip/my_tips.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return (user == null)
        ? Loading()
        : Scaffold(
            appBar: CustomAppBarWithGoToBack('마이페이지', Icon(Icons.close), 0.5),
            backgroundColor: Colors.white,
            body: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  // print(userData.isPharmacist); // 약사인지 디버깅 출력
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _topMyInfo(userData),
                        Container(
                          color: gray50,
                          height: 10,
                        ),
                        _myPageMenu('회원정보 수정', context,
                            EditPrivacyPage(userData: userData)),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        _myPageMenu('키워드 알림 설정', context,
                            EditHealthPage(userData: userData)),
                        Container(
                          color: gray50,
                          height: 10,
                        ),
                        // TODO: 공지사항, 1:1문의, 이용약관, 환경설정 페이지
                        _myPageMenu('공지사항', context, NoticePage()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        _myPageMenu('1:1 문의', context, InquiryPage()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        _myPageMenu('이용약관', context, PolicyTermPage()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        _myPageMenu('개인정보 처리방침', context, PolicyPrivacyPage()),
                        Container(
                          color: gray50,
                          height: 10,
                        ),
                        _myPageMenu(
                            '케이스 인식 지원 의약품 목록', context, CaseRecognitionList()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        userData.isPharmacist
                            ? Container()
                            : _myPageMenu(
                                '약사회원 인증', context, PharmacistAuthPage()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                        _myPageMenu('기타', context, Others()),
                        Container(
                          color: gray50,
                          height: 2,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Loading();
                }
              },
            ),
          );
  }

  Widget _topMyInfo(userData) {
    TheUser user = Provider.of<TheUser>(context);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: gray900),
                        children: <TextSpan>[
                          TextSpan(
                            text: userData.isPharmacist
                                ? '${userData.pharmacistName}'
                                : '${userData.nickname}',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: gray900),
                          ),
                          TextSpan(
                            text: userData.isPharmacist
                                ? ' 약사님, \n오늘도 건강하세요!'
                                : '님, \n오늘도 건강하세요!',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                        _auth.userEmail.toString() == 'null'
                            ? ''
                            : _auth.userEmail,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
                // TODO: image picker
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: primary300_main,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<List<Review>>(
                    stream: ReviewService().getUserReviews(user.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Review> reviews = snapshot.data;
                        return StreamBuilder<List<Tip>>(
                            stream: TipService()
                                .getPharmacistTips(user.uid.toString()),
                            builder: (context, snapshot2) {
                              List<Tip> tips = snapshot2.data;

                              return Row(
                                children: [
                                  userData.isPharmacist
                                      ? _myMenu(
                                          '약사의 한마디',
                                          tips.length.toString(),
                                          context,
                                          MyTips())
                                      : _myMenu('리뷰', reviews.length.toString(),
                                          context, MyReviews()),
                                  SizedBox(width: 10)
                                ],
                              );
                            });
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                  Container(
                    height: 44,
                    child: VerticalDivider(
                      color: gray75,
                    ),
                  ),
                  StreamBuilder<UserData>(
                    stream: DatabaseService(uid: user.uid).userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List favoriteList = snapshot.data.favoriteList;
                        return Row(
                          children: [
                            SizedBox(width: 10),
                            _myMenu('찜', favoriteList.length.toString(),
                                context, MyFavorites()),
                          ],
                        );
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                  //_myMenu('1:1 문의', '0', context, MyReviews())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _myMenu(String name, String count, BuildContext context, var nextPage) {
  return InkWell(
    child: Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: gray500)),
          Text(count,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: primary500_light_text)),
        ],
      ),
    ),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    ),
  );
}

Widget _myPageMenu(String name, BuildContext context, var nextPage) {
  return InkWell(
      child: Container(
        height: 48,
        padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900, fontWeight: FontWeight.normal)),
            Icon(
              Icons.navigate_next,
              color: gray100,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      });
}
