import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/drug_info/expiration_s.dart';
import 'package:semo_ver2/drug_info/warning_highlighting.dart';

import 'package:semo_ver2/drug_info/detail_info.dart';
import 'package:semo_ver2/drug_info/expiration_g.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/ranking/Page/ranking_content_page.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/review/all_review.dart';
import 'package:semo_ver2/review/get_rating.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/review/write_review.dart';
import 'package:semo_ver2/theme/colors.dart';

class ReviewPage extends StatefulWidget {
  final String drugItemSeq;
  String fromRankingTile = '';

  ReviewPage(this.drugItemSeq, {this.fromRankingTile});

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
  GlobalKey _key4 = GlobalKey();

  double _getReviewSizes() {
    final RenderBox renderBox1 = _key1.currentContext.findRenderObject();
    final RenderBox renderBox2 = _key2.currentContext.findRenderObject();
    final RenderBox renderBox3 = _key3.currentContext.findRenderObject();
    final RenderBox renderBox4 = _key4.currentContext.findRenderObject();
    double height = renderBox1.size.height /*+ renderBox2.size.height*/ +
        renderBox3.size.height +
        renderBox4.size.height +
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

  void _onTapPillInfo() {
    _scrollController.animateTo(_getPillInfoSize(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {
      pillInfoTab = true;
    });
  }

  void _onTapReview() {
    _scrollController.animateTo(_getReviewSizes(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {
      pillInfoTab = false;
    });
  }

  bool pillInfoTab = false;

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

    return Scaffold(
        backgroundColor: gray0_white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.teal[200],
              ),
              //onPressed: () => Navigator.pop(context),
              //다시 카테고리 페이지로 가기 위함 provider 를 다시 불러오려면 페이지를 다시 여는 방법
              onPressed: () async {
                if (widget.fromRankingTile == 'true') {
                  var result =
                      await DatabaseService(itemSeq: widget.drugItemSeq)
                          .getCategoryOfDrug();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RankingContentPage(categoryName: result)));
                } else
                  Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            '약 정보',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Color(0xFFE9FFFB),
                  Color(0xFFE9FFFB),
                  Color(0xFFFFFFFF),
                ])),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Colors.teal[200],
            elevation: 0.0,
            onPressed: () async {
              if (await ReviewService()
                      .findUserWroteReview(widget.drugItemSeq, user.uid) ==
                  false)
                _dialogIfAlreadyExist();
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
                                          onTap: _onTapPillInfo,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                          );
                        } else {
                          return Loading();
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
                      Center(
                        child: Container(
                          width: 200,
                          child: AspectRatio(
                              aspectRatio: 3.5 / 2,
                              child: DrugImage(drugItemSeq: drug.itemSeq)),
                        ),
                      ),
                      SizedBox(height: 20),
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
                        RatingBar.builder(
                          initialRating: drug.totalRating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 18,
                          glow: false,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0),
                          unratedColor: gray50,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: yellow,
                          ),
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
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        CategoryButton(str: drug.category),
                        Expanded(
                          child: Container(),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_isFavorite) {
                              await DatabaseService(uid: user.uid)
                                  .removeFromFavoriteList(drug.itemSeq);
                            } else {
                              _showFavoriteDone(context);
                              await DatabaseService(uid: user.uid)
                                  .addToFavoriteList(drug.itemSeq);
                              // _showFavoriteWell(context);
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: gray75),
                              color: gray50,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  _isFavorite ? warning : gray300_inactivated,
                              size: 20,
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                        ),
                        ButtonTheme(
                          minWidth: 20,
                          height: 30,
                          child: FlatButton(
                            color: primary300_main,
                            child: Text(
                              '+ 담기',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: gray0_white,
                                  ),
                            ),
                            onPressed: () {
                              if (_isSaved) {
                                _alreadySaved(context);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) {
                                          if (drug.etcOtcCode == '일반의약품') {
                                            return ExpirationG(
                                              drugItemSeq: drug.itemSeq,
                                            );
                                          } else {
                                            return ExpirationS(
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
          return Loading();
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
    print(diseaseList);

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

    print(_resultList);
    return _resultList;
  }

  /* Top Information - Dialogs */
  Widget _warningMessage(context, carefulDiseaseList, drugItemSeq) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      decoration: BoxDecoration(
        // shape: OutlineInputBorder(
        //     borderSide: BorderSide(
        //         style: BorderStyle.solid,
        //         width: 1.0,
        //         color: gray200),
        //     borderRadius: BorderRadius.circular(8.0)),
        color: primary50,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_icon.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
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
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('자세히보기',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: primary600_bold_text, fontSize: 12)),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(68, 24),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
        ],
      ),
    );
  }

  void _showFavoriteDone(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        }); // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 17,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '찜 목록',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '에 추가되었습니다.'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '마이페이지에서 확인하실 수 있습니다',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _alreadySaved(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        }); //
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Icon(
            Icons.warning,
            color: Colors.orangeAccent,
            size: 17,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '이미 '),
                      TextSpan(
                          text: '보관함',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '에 저장되어있습니다.'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '약보관함에서 확인하실 수 있습니다',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /* Under Information */
  Widget _underInfo(BuildContext context, Drug drug, UserData userData) {
    bool _isCareful =
        _carefulDiseaseList(userData.keywordList, drug.nbDocData).isNotEmpty;

    return Padding(
      key: _key3,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isCareful
                ? _warningMessage(
                    context,
                    _carefulDiseaseList(userData.keywordList, drug.nbDocData),
                    drug.itemSeq)
                : Container(),
            _isCareful ? SizedBox(height: 20) : Container(),
            Text('효능효과',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: gray750_activated,
                    )),
            _drugDocInfo(context, drug.itemSeq, 'EE'),
            SizedBox(
              height: 10,
            ),
            Text('용법용량',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: gray750_activated,
                    )),
            _drugDocInfo(context, drug.itemSeq, 'UD'),
            SizedBox(
              height: 10,
            ),
            Text('저장방법',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: gray750_activated,
                    )),
            Text(drug.storageMethod,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray600,
                    )),
            SizedBox(
              height: 10,
            ),
            FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailInfo(
                                drugItemSeq: drug.itemSeq,
                              )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Text('약 정보 전체보기',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: gray500, fontSize: 12)),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )),
          ]),
    );
  }

  Widget _drugDocInfo(BuildContext context, String drugItemSeq, String type) {
    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            if (type == 'EE') {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: drug.eeDocData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(drug.eeDocData[index].toString(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: gray600,
                            ));
                  });
            } else if (type == 'NB') {
              return ListView.builder(
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
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drug.udDocData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(drug.udDocData[index].toString(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: gray600,
                            ));
                  });
            } else {
              return Container();
            }
          } else {
            return Loading();
          }
        });
  }

  Widget _totalRating() {
    return Column(
      key: _key4,
      children: [
        GetRating(widget.drugItemSeq),
        Container(
          height: 4,
          color: gray50,
        ),
      ],
    );
  }

  /* Review */
  Widget _drugReviews() {
    return StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            if (drug.numOfReviews > 0) _existReview();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //TODO EDIT num of reviews
                      Text(
                          "리뷰 " + drug.numOfReviews.toStringAsFixed(0) + "개",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: gray750_activated,
                          )),
                      //Text("EEEEE"+checkReviewIsZero().toString()),
                      checkReviewIsZero() == true
                          ? Container()
                          : InkWell(
                          child: Text('전체리뷰 보기',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: gray500, fontSize: 12)),
                          onTap: () {
                            //TODO GET ALL REVIEW
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllReview(widget.drugItemSeq)));
                          }),
                    ],
                  ),
                ),
                // _searchBar(),
                // ReviewList(_searchText, "all"),
                checkReviewIsZero() == true ? Container() : _searchBar(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 36,
                    decoration: BoxDecoration(
                      // shape: OutlineInputBorder(
                      //     borderSide: BorderSide(
                      //         style: BorderStyle.solid,
                      //         width: 1.0,
                      //         color: gray200),
                      //     borderRadius: BorderRadius.circular(8.0)),
                      color: gray50,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: Image.asset('assets/icons/warning_icon_green.png'),
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
                                .copyWith(color: gray600, fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "효과 및 부작용은 개인에 따라 다를 수 있습니다.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: gray600, fontSize: 12)),
                              // TextSpan(text: '은 개인에 따라 다를 수 있습니다.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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
                          'assets/images/Group 257.png',
                        ),
                        Container(
                          height: 10,
                        ),
                        Text("아직 작성된 리뷰가 없어요")
                      ],
                    ))
                    : ReviewList(_searchText, "all"),
              ],
            );

          } else
            return Loading();
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
//                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                      fillColor: gray50,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      hintText: '어떤 리뷰를 찾고계세요?',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,),
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
                                          borderRadius: BorderRadius.circular(8.0))
                  ),
                )
            ),

          ],
        ),
      ),
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
