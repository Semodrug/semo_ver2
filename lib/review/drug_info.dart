import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/drug_info/general_expiration.dart';
import 'package:semo_ver2/drug_info/prepared_expiration.dart';
import 'package:semo_ver2/drug_info/search_highlighting.dart';
import 'package:semo_ver2/drug_info/warning_highlighting.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/mypage/my_favorites.dart';
import 'package:semo_ver2/ranking/Page/ranking_content_page.dart';
import 'package:semo_ver2/review/review_policy_more.dart';
import 'package:semo_ver2/review/see_my_review.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/review/all_review.dart';
import 'package:semo_ver2/review/get_rating.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/review/write_review.dart';
import 'package:semo_ver2/shared/shortcut_dialog.dart';
import 'package:semo_ver2/theme/colors.dart';

List infoEE;
List infoNB;
List infoUD;
String storage;
String entpName;

class ReviewPage extends StatefulWidget {
  final String drugItemSeq;
  String fromRankingTile = '';
  final String filter;
  final String type;

  ReviewPage(this.drugItemSeq, {this.fromRankingTile, this.filter, this.type});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  _ReviewPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();
  // GlobalKey _key4 = GlobalKey();

  double _getReviewSizes() {
    final RenderBox renderBox1 = _key1.currentContext.findRenderObject();
    final RenderBox renderBox2 = _key2.currentContext.findRenderObject();
    final RenderBox renderBox3 = _key3.currentContext.findRenderObject();
    // final RenderBox renderBox4 = _key4.currentContext.findRenderObject();
    double height = renderBox1.size.height + /*renderBox2.size.height +*/
        renderBox3.size.height +
        // renderBox4.size.height +
        30;
    return height;
  }

  double _getPillInfoSize() {
    final RenderBox renderBox1 = _key1.currentContext.findRenderObject();
    final RenderBox renderBox2 = _key2.currentContext.findRenderObject();
    double height = renderBox1.size.height /*+ renderBox2.size.height*/;
    return height;
  }

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.offset * 1.0 > _getReviewSizes())
    //     pillInfoTab = false;
    //   else
    //     pillInfoTab = true;
    //   //print("MORE THAN 1000");
    //   print('offset = ${_scrollController.offset}');
    //   print(pillInfoTab);
    // });
  }

  // void checkScroller() {
  //   _scrollController.addListener(() {
  //     if(_scrollController.offset*1.0 < _getPillInfoSize())
  //       pillInfoTab = true;
  //     else if(_scrollController.offset*1.0 >= _getPillInfoSize())
  //       pillInfoTab = false;
  //     //print('offset = ${_scrollController.offset}');
  //   });
  //
  // }

  void _onTapPillInfo() {
    _scrollController.animateTo(_getPillInfoSize(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {
      pillInfoTab = true;
      //print("HEIGHT"+_scrollController.position.pixels.toString());
    });
  }

  void _onTapReview() {
    setState(() {
      pillInfoTab = false;
    });
    _scrollController.animateTo(_getReviewSizes(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  bool pillInfoTab = true;

  bool _ifZeroReview = true;

  void _noReview() {
    _ifZeroReview = true;
  }

  void _existReview() {
    _ifZeroReview = false;
  }

  bool checkReviewIsZero() {
    return _ifZeroReview;
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);
    String filter = 'nothing';
    bool check = false;
    if (widget.filter != null) {
      filter = widget.filter;
      check = true;
    }
    String rankingCategory = 'notFromRanking';
    if (widget.type != null) {
      rankingCategory = widget.type;
    }

    return Scaffold(
        backgroundColor: gray0_white,
        appBar: check
            ? CustomAppBarWithGoToRanking('약 정보', Icon(Icons.arrow_back), 0.5,
                filter: filter, category: rankingCategory)
            : CustomAppBarWithGoToRanking('약 정보', Icon(Icons.arrow_back), 0.5),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Color(0xff00C2AE),
            elevation: 6.0,
            onPressed: () async {
              if (await ReviewService()
                      .findUserWroteReview(widget.drugItemSeq, user.uid) ==
                  false)
                // return StreamBuilder<List<Review>>(
                //   stream: ReviewService().findUserReview(widget.drugItemSeq, user.uid),
                //   builder: (context, snapshot) {
                //     if(snapshot.hasData) {
                //       return IYMYGotoSeeOrCheckDialog();
                //     }
                //     else {
                //         print("FAIL");
                //       return Container();
                //     }
                //   }
                // );
                IYMYGotoSeeOrCheckDialog();
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WriteReview(drugItemSeq: widget.drugItemSeq)));
            }),
        body: StreamProvider<List<Review>>.value(
          value: ReviewService().getReviews(widget.drugItemSeq),
          child: StreamBuilder<Drug>(
              stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Drug drug = snapshot.data;
                  return StreamBuilder<UserData>(
                      stream: DatabaseService(uid: user.uid).userData,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          UserData userData = snapshot2.data;
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child:
                                NotificationListener<ScrollUpdateNotification>(
                              child: CustomScrollView(
                                //physics: PageScrollPhysics(),
                                controller: _scrollController,
                                slivers: <Widget>[
                                  SliverToBoxAdapter(
                                    child:
                                        _topInfo(context, drug, user, userData),
                                  ),
                                  SliverAppBar(
                                    elevation: 0,
                                    flexibleSpace: Row(
                                      key: _key2,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: InkWell(
                                              child: Center(
                                                  child: Text("약정보",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                            color: pillInfoTab ==
                                                                    true
                                                                ? primary500_light_text
                                                                : gray300_inactivated,
                                                          ))),
                                              onTap: _onTapPillInfo
                                              // onTap: () {
                                              //   _onTapPillInfo;
                                              // },
                                              ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: pillInfoTab == true
                                                          ? primary400_line
                                                          : gray100,
                                                      width: pillInfoTab == true
                                                          ? 2.0
                                                          : 1.0))),
                                        ),
                                        Container(
                                          child: InkWell(
                                            child: Center(
                                                child: Text("리뷰",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                          color: pillInfoTab ==
                                                                  true
                                                              ? gray300_inactivated
                                                              : primary500_light_text,
                                                        ))),
                                            onTap: _onTapReview,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: pillInfoTab == true
                                                          ? gray100
                                                          : primary400_line,
                                                      width: pillInfoTab == true
                                                          ? 1.0
                                                          : 2.0))),
                                        )
                                      ],
                                    ),
                                    leading: Container(),
                                    pinned: true,
                                    backgroundColor: Colors.white,
                                  ),
                                  SliverToBoxAdapter(
                                      child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      _underInfo(context, drug, userData),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 10.0,
                                        child: Container(
                                          color: gray50,
                                        ),
                                      ),
                                    ],
                                  )),
                                  SliverToBoxAdapter(
                                    child: _totalRating(),
                                  ),
                                  SliverToBoxAdapter(
                                    child: _drugReviews(),
                                  )
                                ],
                              ),
                              // onNotification: (notification) {
                              //   //List scroll position
                              //   if (_scrollController.position.pixels * 1.0 <
                              //       _getReviewSizes())
                              //     pillInfoTab = true;
                              //   else if (_scrollController.position.pixels *
                              //           1.0 >=
                              //       _getReviewSizes()) pillInfoTab = false;
                              //   // print(pillInfoTab);
                              //   // print(notification.metrics.pixels);
                              //   //print(_scrollController.position.pixels);
                              // },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Loading();
                }
              }),
        ));
  }

  /* Top Information */
  Widget _topInfo(
      BuildContext context, Drug drug, TheUser user, UserData userData) {
    bool _isFavorite = userData.favoriteList.contains(drug.itemSeq);

    return StreamBuilder<List<SavedDrug>>(
      stream: DatabaseService(uid: user.uid).savedDrugs,
      builder: (context, snapshot3) {
        if (snapshot3.hasData) {
          List<SavedDrug> savedDrugs = snapshot3.data;
          bool _isSaved = false;
          for (SavedDrug savedDrug in savedDrugs) {
            _isSaved = savedDrug.itemSeq.contains(drug.itemSeq);
            if (_isSaved == true) break;
          }

          return Column(
            children: [
              Padding(
                key: _key1,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 188,
                          child: DrugImage(drugItemSeq: drug.itemSeq),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(drug.etcOtcCode,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: gray300_inactivated,
                                  )),
                          Text('  |  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: gray300_inactivated,
                                  )),
                          Text(drug.entpName,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: gray300_inactivated,
                                  )),
                        ],
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (0.8),
                        child: Text(_shortenName(drug.itemName),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: gray750_activated, fontSize: 16)),
                      ),
                      SizedBox(height: 10),
                      Row(children: <Widget>[
                        RatingBarIndicator(
                          rating: drug.totalRating * 1.0,
                          itemBuilder: (context, index) =>
                              //     Icon(
                              //   // _selectedIcon ??
                              //       Icons.star,
                              //   color: yellow,
                              // ),
                              ImageIcon(
                            AssetImage('assets/icons/star.png'),
                            color: yellow,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          unratedColor: gray75,
                          //unratedColor: Colors.amber.withAlpha(50),
                          direction: Axis.horizontal,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        ),
                        Container(width: 5),
                        Text(drug.totalRating.toStringAsFixed(1),
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: gray900,
                                    )),
                        Text(" (" + drug.numOfReviews.toStringAsFixed(0) + '개)',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: gray300_inactivated, fontSize: 12))
                      ]),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                height: 24,
                                child: CategoryButton(
                                    str: drug.category, fromDrugInfo: true)),
                            Expanded(
                              child: Container(),
                            ),
                            InkWell(
                              onTap: () async {
                                if (_isFavorite) {
                                  await DatabaseService(uid: user.uid)
                                      .removeFromFavoriteList(drug.itemSeq);
                                } else {
                                  IYMYShortCutDialog(
                                    context: context,
                                    dialogIcon:
                                        Icon(Icons.favorite, color: warning),
                                    boldBodyString: '찜 목록',
                                    normalBodyString: '에 추가되었습니다',
                                    topButtonName: '바로가기',
                                    bottomButtonName: '확인',
                                    onPressedTop: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyFavorites()));
                                    },
                                    onPressedBottom: () {
                                      Navigator.pop(context);
                                    },
                                  ).showWarning();

                                  await DatabaseService(uid: user.uid)
                                      .addToFavoriteList(drug.itemSeq);
                                  // _showFavoriteWell(context);
                                }
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(color: gray75),
                                  color: gray50,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite
                                      ? warning
                                      : gray300_inactivated,
                                  size: 24,
                                ),
                              ),
                            ),
                            Container(
                              width: 8,
                            ),
                            ButtonTheme(
                              minWidth: 80,
                              height: 36,
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: primary300_main,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        color: gray0_white, size: 18),
                                    Text(
                                      '담기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: gray0_white),
                                    ),
                                    SizedBox(width: 2)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: primary400_line,
                                    )),
                                onPressed: () {
                                  if (_isSaved) {
                                    IYMYShortCutDialog(
                                      context: context,
                                      dialogIcon: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Image.asset(
                                              'assets/icons/warning_icon_primary.png')),
                                      boldBodyString: '',
                                      normalBodyString: '이미 저장한 약입니다',
                                      topButtonName: '나의 약 보관함 바로가기',
                                      bottomButtonName: '확인',
                                      onPressedTop: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomBar()));
                                      },
                                      onPressedBottom: () {
                                        Navigator.pop(context);
                                      },
                                    ).showWarning();
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) {
                                              if (drug.etcOtcCode == '일반의약품') {
                                                return GeneralExpiration(
                                                  drugItemSeq: drug.itemSeq,
                                                );
                                              } else {
                                                return PreparedExpiration(
                                                  drugItemSeq: drug.itemSeq,
                                                );
                                              }
                                            }));
                                  }
                                },
                              ),
                            ),
                          ]),
                    ]),
              ),
              SizedBox(
                width: double.infinity,
                height: 10.0,
                child: Container(
                  color: gray50,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _shortenName(String data) {
    String newName = data;
    List splitName = [];

    if (data.contains('(수출')) {
      splitName = newName.split('(수출');
      newName = splitName[0];
    }

    if (data.contains('(군납')) {
      splitName = newName.split('(군납');
      newName = splitName[0];
    }
    return newName;
  }

  List _carefulDiseaseList(List diseaseList, List nbDocData) {
    List _searchList = diseaseList;
    List _resultList = new List();

    if (diseaseList.contains('임산부')) {
      _searchList.add('임부');
      _searchList.add('임신');
      _searchList.add('수유');
      _searchList.add('모유');
    }

    if (diseaseList.contains('고령자')) {
      _searchList.add('노인');
    }

    if (diseaseList.contains('소아')) {
      _searchList.add('유아');
    }

    if (diseaseList.contains('신장')) {
      _searchList.add('콩팥');
      _searchList.add('신부전');
    }

    if (diseaseList.contains('유당불내증')) {
      _searchList.add('유당분해효소결핍증');
      _searchList.add('유당분해효소 결핍증');
      _searchList.add('유당 분해효소 결핍증');
      _searchList.add('유당 분해 효소 결핍증');
    }

    for (int i = 0; i < nbDocData.length; i++) {
      for (int j = 0; j < _searchList.length; j++) {
        if (nbDocData[i].contains(_searchList[j])) {
          if (!_resultList.contains(_searchList[j]))
            _resultList.add(_searchList[j]);
        }
      }
    }

    return _resultList;
  }

  //              child: Image.asset('assets/icons/warning_icon.png')

  //ElevatedButton(
  //             child: Text('자세히보기',
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .subtitle1
  //                     .copyWith(color: primary600_bold_text, fontSize: 12)),
  //             style: ElevatedButton.styleFrom(
  //                 minimumSize: Size(68, 24),
  //                 padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //                 elevation: 0,
  //                 primary: gray0_white,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(4.0),
  //                     side: BorderSide(color: Colors.grey[300]))),
  //             onPressed: () async {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => WarningInfo(
  //                             drugItemSeq: drugItemSeq,
  //                             warningList: carefulDiseaseList,
  //                           )));
  //             },
  //           )

  /* Top Information - Dialogs */
  Widget _warningMessage(context, carefulDiseaseList, drugItemSeq) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        // color: primary50,
        color: Color(0xFFDCF5F2).withOpacity(0.87),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 18,
              height: 18,
              child: Image.asset('assets/icons/warning_icon.png')),
          Container(
            width: MediaQuery.of(context).size.width - 165,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: gray600, fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                      text: '${carefulDiseaseList.join(", ")}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: gray900, fontSize: 12)),
                  TextSpan(text: '에 관한 주의사항이 있습니다.'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 68,
            height: 24,
            child: ElevatedButton(
              child: Text('자세히보기',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: primary600_bold_text, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  primary: gray0_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(color: Colors.grey[300]))),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WarningInfo(
                              drugItemSeq: drugItemSeq,
                              warningList: carefulDiseaseList,
                            )));
              },
            ),
          )
        ],
      ),
    );
  }

  /* Under Information */
  Widget _underInfo(BuildContext context, Drug drug, UserData userData) {
    bool _isCareful = _carefulDiseaseList(
            userData.keywordList + userData.selfKeywordList, drug.nbDocData)
        .isNotEmpty;

    return Padding(
      key: _key3,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isCareful
                ? _warningMessage(
                    context,
                    _carefulDiseaseList(
                        userData.keywordList + userData.selfKeywordList,
                        drug.nbDocData),
                    drug.itemSeq)
                : Container(),
            _isCareful ? SizedBox(height: 20) : Container(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('효능효과',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )),
            ),
            _drugDocInfo(context, drug.itemSeq, 'EE'),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('용법용량',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )),
            ),
            _drugDocInfo(context, drug.itemSeq, 'UD'),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('저장방법',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )),
            ),
            Text(drug.storageMethod,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray600, height: 1.6)),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('주요성분',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )),
            ),
            Text(drug.mainItemIngr,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray600, height: 1.6)),
            SizedBox(height: 22),
            Row(
              children: [
                Expanded(child: Container()),
                FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SearchHighlightingScreen(
                                      infoEE: infoEE,
                                      infoNB: infoNB,
                                      infoUD: infoUD,
                                      storage: storage,
                                      entp_name: entpName)));
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
                        Text('약 정보 전체보기',
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
            ),
          ]),
    );
  }

  Widget _drugDocInfo(BuildContext context, String drugItemSeq, String type) {
    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            storage = drug.storageMethod;
            entpName = drug.entpName;
            infoEE = drug.eeDocData;
            infoNB = drug.nbDocData;
            infoUD = drug.udDocData;
            if (type == 'EE') {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drug.eeDocData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(drug.eeDocData[index].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray600, height: 1.6));
                  });
            } else if (type == 'NB') {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drug.nbDocData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      drug.nbDocData[index].toString(),
                    );
                  });
            } else if (type == 'UD') {
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drug.udDocData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(drug.udDocData[index].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray600, height: 1.6));
                  });
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget _totalRating() {
    return Column(
      // key: _key4,
      children: [
        GetRating(widget.drugItemSeq),
        Container(
          height: 4,
          color: gray50,
        ),
      ],
    );
  }

  Widget _reviewWarning() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 5),
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 10),
          // padding: EdgeInsets.only(right: 10),
          height: 36,
          decoration: BoxDecoration(
            // color: gray50,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 15,
                height: 15,
                child: Image.asset('assets/icons/warning_icon_primary.png'),
              ),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: gray300_inactivated, fontSize: 11),
                  children: <TextSpan>[
                    TextSpan(
                        text: "효과 및 부작용은 개인에 따라 다를 수 있습니다.",
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: gray600,
                            fontSize: MediaQuery.of(context).size.width <= 320
                                ? 11
                                : 12)),
                  ],
                ),
              ),
              // Expanded(child: Container(),),
              Container(width: 5),

              InkWell(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: gray300_inactivated,
                          fontSize: MediaQuery.of(context).size.width <= 320
                              ? 10
                              : 11,
                          decoration: TextDecoration.underline,
                        ),
                    children: <TextSpan>[
                      TextSpan(text: '더 보기 '),
                    ],
                  ),
                ),

                // Text(
                //   '처방받은 약인가요?',
                //   style: TextStyle(
                //     color: primary500_light_text,
                //     fontSize: 12.0,
                //     fontWeight: FontWeight.w400,
                //     decoration: TextDecoration.underline,
                //   ),
                // ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewPolicyMore()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Review */
  Widget _drugReviews() {
    // body: StreamProvider<List<Review>>.value(
    //     value: ReviewService().getReviews(widget.drugItemSeq),
    //     child: StreamBuilder<Drug>(

    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            if (drug.numOfReviews > 0)
              _existReview();
            else
              _noReview();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //TODO EDIT num of reviews
                      Text("리뷰 " + drug.numOfReviews.toStringAsFixed(0) + "개",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: gray750_activated,
                              )),
                      checkReviewIsZero() == true
                          ? Container()
                          : Row(
                              children: [
                                FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AllReview(
                                                  widget.drugItemSeq,
                                                  drug.itemName)));
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('전체리뷰 보기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    color: gray500,
                                                    fontSize: 12)),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: gray500,
                                          size: 20,
                                        )
                                      ],
                                    )),
                              ],
                            ),
                    ],
                  ),
                ),
                checkReviewIsZero() == true ? Container() : _searchBar(),
                checkReviewIsZero() == true ? Container() : _reviewWarning(),
                checkReviewIsZero() == true
                    ? Container(
                        height: 310,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                            ),
                            Image.asset(
                              'assets/images/no_review.png',
                            ),
                            Container(
                              height: 10,
                            ),
                            Text("아직 작성된 리뷰가 없어요")
                          ],
                        ))
                    : ReviewList(_searchText, "all", widget.drugItemSeq),
              ],
            );
          } else
            return Container();
        });
  }

  Widget _searchBar() {
    // return Center(
    //   child: Column(
    //     children: [
    //       Container(
    //         margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
    //         child: SizedBox(
    //             height: 35,
    //             child: FlatButton(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Icon(Icons.search, size: 20),
    //                   Padding(
    //                     padding:
    //                     const EdgeInsets.symmetric(horizontal: 10.0),
    //                     child: Text(
    //                       "어떤 약정보를 찾고 계세요?",
    //                       style: Theme.of(context).textTheme.bodyText2,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               // onPressed: () {
    //               //   Navigator.push(
    //               //       context,
    //               //       MaterialPageRoute(
    //               //           builder: (BuildContext context) =>
    //               //               SearchHighlightingScreen(
    //               //                   infoEE: infoEE,
    //               //                   infoNB: infoNB,
    //               //                   infoUD: infoUD,
    //               //                   storage: storage,
    //               //                   entp_name: entpName)));
    //               // },
    //               textColor: gray300_inactivated,
    //               color: gray50,
    //               shape: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                       style: BorderStyle.solid,
    //                       width: 1.0,
    //                       color: gray200),
    //                   borderRadius: BorderRadius.circular(8.0)),
    //             )),
    //       ),
    //       SizedBox(height: 10)
    //     ],
    //   ),
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 35,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: TextField(
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 15),
                  controller: _filter,
                  decoration: InputDecoration(
                      fillColor: gray50,
                      filled: true,
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
                      ),
                      hintText: '어떤 리뷰를 찾고계세요?',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                      contentPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1.0,
                              color: gray75),
                          borderRadius: BorderRadius.circular(8.0))),
                )),
          ],
        ),
      ),
    );
  }

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
                    TextSpan(text: "해당 약에 대한 리뷰를\n이미 작성하셨습니다"),
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
                          "내가 작성한 리뷰 보러가기",
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
                                SeeMyReview(widget.drugItemSeq)));
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

  Future<void> _dialogIfAlreadyExist() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child:
                        Icon(Icons.star, size: 30, color: Colors.amberAccent)),
                SizedBox(height: 5),
//                Center(child: Text('별점이 반영되었습니다.', style: TextStyle(color: Colors.black45, fontSize: 14))),
                SizedBox(height: 20),
                Center(
                    child: Text('해당 약에 대한 리뷰를 \n이미 작성하셨습니다.',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
//                    TextButton(
//                      child: Text('확인', style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
//                      onPressed: () {
//                        //TODO: GOTO Edit Review
//                        Navigator.of(context).pop();
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) => WriteReview(drugItemSeq: widget.drugItemSeq, tapToRatingResult: rating)
//                        ));
//                      },
//                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
