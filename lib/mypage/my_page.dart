import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/ok_dialog.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

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
                        //_myPageMenu('1:1 문의', context, InquiryPage()),
                        _myPageForEmil('1:1 문의', context),
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
                  // TODO: 리뷰 갯수뷰
                  StreamBuilder<List<Review>>(
                    stream: ReviewService().getUserReviews(user.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Review> reviews = snapshot.data;
                        return Row(
                          children: [
                            _myMenu('리뷰', reviews.length.toString(), context,
                                MyReviews()),
                            SizedBox(width: 10)
                          ],
                        );
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

Widget _myPageForEmil(String name, BuildContext context) {
  Future<String> _getEmailBody() async {

    String body = "";

    body += "아래 항목에서 골라서 문의 제목에 적어주세요!\n";
    body += "==============\n";
    body += '1 의약품 정보 문의 및 요청\n';
    body += '2 서비스 불편 오류 제보 \n';
    body += '3 사용 방법, 기타문의 \n';
    body += '4 의견 제안, 칭찬 \n';
    body += '5 제휴 문의\n';
    body += "==============\n";

    return body;
  }
  void _sendEmail() async {
    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[이약모약 문의]',
      recipients: ['iymy.dev@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = "기본 메일 앱을 사용할 수 없기 때문에\n 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면\n  감사하겠습니다 :)\n\niymy.dev@gmail.com";
      String message = "";
      //_showErrorAlert(title: title, message: message);
      IYMYOkDialog(
        context: context,
        dialogIcon: Icon(Icons.check, color: primary300_main),
        bodyString: title,
        buttonName: '확인',
        onPressed: () {
          Navigator.pop(context);
          //Navigator.pop(context);
        },
      ).showWarning();
    }
  }

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
        _sendEmail();
      });

}

