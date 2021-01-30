import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/drug_info/expiration_s.dart';
import 'package:semo_ver2/drug_info/warning_highlighting.dart';
//

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
  // bool _isCareful;

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
        20;
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
        duration: Duration(milliseconds: 100), curve: Curves.linear);
    setState(() {
      pillInfoTab = true;
    });
  }

  void _onTapReview() {
    _scrollController.animateTo(_getReviewSizes(),
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    setState(() {
      pillInfoTab = false;
    });
  }

  bool pillInfoTab = false;

  bool _ifZeroReview = false;
  void _ifNoReview() {
    _ifZeroReview = true;
  }

  bool checkIfNoReview() {
    return _ifZeroReview;
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
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
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
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
        backgroundColor: Colors.white,
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
                                  flexibleSpace: Row(
                                    key: _key2,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: InkWell(
                                          child: Center(child: Text("약정보")),
                                          onTap: _onTapPillInfo,
                                          // onTap: () {
                                          //   _onTapPillInfo;
                                          // },
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black87,
                                                    width: pillInfoTab == true
                                                        ? 2.0
                                                        : 1.0))),
                                      ),
                                      Container(
                                        child: InkWell(
                                          child: Center(child: Text("리뷰")),
                                          onTap: _onTapReview,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black87,
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
                                        color: Colors.grey[200],
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


                  return Stack(
                    children: [
                      Padding(
                        key: _key1,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Center(
                                child: Container(
                                  width: 200,
                                  child: AspectRatio(
                                      aspectRatio: 3.5 / 2,
                                      child:
                                          DrugImage(drugItemSeq: drug.itemSeq)),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    drug.etcOtcCode,
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: gray300_inactivated,
                                      fontSize: 14
                                    )
                                  ),
                                  Text(
                                    '  |  ',
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 14
                                      )
                                  ),
                                  Text(
                                    drug.entpName,
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 14
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * (0.8),
                                child: Text(
                                  _shortenName(drug.itemName),
                                  style: Theme.of(context).textTheme.headline4.copyWith(
                                      color: gray750_activated,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(children: <Widget>[
                                Text(
                                  drug.totalRating.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                        color: gray900,
                                        fontSize: 14
                                    )
                                ),
                                Text(
                                  " (" +
                                      drug.numOfReviews.toStringAsFixed(0) +
                                      '개)',
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: gray750_activated,
                                        fontSize: 12,
                                    )
                                )
                              ]),
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    CategoryButton(str: drug.category)
                                  ]),
                              SizedBox(
                                height: 20,
                              )
                            ]),
                      ),
                      _isCareful
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: FlatButton(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: Image.asset(
                                            'assets/icons/warning_icon.png'),
                                        width: 32,
                                        height: 32,
                                      ),
                                      Text(
                                        '주의',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    _showWarning(
                                        context,
                                        _carefulDiseaseList(
                                            userData.diseaseList,
                                            drug.nbDocData),
                                        drug.itemSeq);
                                  }))
                          : Container(),
                      Positioned(
                          top: 140,
                          right: 20,
                          child: IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite ? Colors.redAccent : null,
                              ),
                              onPressed: () async {
                                if (_isFavorite) {
                                  await DatabaseService(uid: user.uid)
                                      .removeFromFavoriteList(drug.itemSeq);
                                } else {
                                  _showFavoriteDone(context);
                                  await DatabaseService(uid: user.uid)
                                      .addToFavoriteList(drug.itemSeq);
                                  // _showFavoriteWell(context);
                                }
                              })),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: ButtonTheme(
                          minWidth: 20,
                          height: 30,
                          child: FlatButton(
                            color: Colors.teal[300],
                            child: Text(
                              '+ 담기',
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                  color: gray0_white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (0.8),
                        child: Text(
                          _shortenName(drug.itemName),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(children: <Widget>[
                        Text(
                          drug.totalRating.toStringAsFixed(1),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (" + drug.numOfReviews.toStringAsFixed(0) + '개)',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ]),
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        CategoryButton(str: drug.category)
                      ]),
                      SizedBox(
                        height: 20,
                      )
                    ]),
              ),
              // _isCareful
              //     ? Positioned(
              //         top: 0,
              //         right: 0,
              //         child: FlatButton(
              //             child: Column(
              //               children: [
              //                 SizedBox(
              //                   child: Image.asset(
              //                       'assets/icons/warning_icon.png'),
              //                   width: 32,
              //                   height: 32,
              //                 ),
              //                 Text(
              //                   '주의',
              //                   style: TextStyle(
              //                     color: Colors.grey,
              //                   ),
              //                 )
              //               ],
              //             ),
              //             onPressed: () {
              //               _showWarning(
              //                   context,
              //                   _carefulDiseaseList(
              //                       userData.diseaseList,
              //                       drug.nbDocData),
              //                   drug.itemSeq);
              //             }))
              //     : Container(),
              Positioned(
                  top: 140,
                  right: 20,
                  child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.redAccent : null,
                      ),
                      onPressed: () async {
                        if (_isFavorite) {
                          await DatabaseService(uid: user.uid)
                              .removeFromFavoriteList(drug.itemSeq);
                        } else {
                          _showFavoriteDone(context);
                          await DatabaseService(uid: user.uid)
                              .addToFavoriteList(drug.itemSeq);
                          // _showFavoriteWell(context);
                        }
                      })),
              Positioned(
                bottom: 20,
                right: 20,
                child: ButtonTheme(
                  minWidth: 20,
                  height: 30,
                  child: FlatButton(
                    color: Colors.teal[300],
                    child: Text(
                      '+ 담기',
                      style: TextStyle(color: Colors.white),
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
    List newList = new List();

    for (int i = 0; i < nbDocData.length; i++) {
      for (int j = 0; j < diseaseList.length; j++) {
        if (nbDocData[i].contains(diseaseList[j])) {
          if (!newList.contains(diseaseList[j])) newList.add(diseaseList[j]);
        }
      }
    }

    return newList;
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
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${carefulDiseaseList.join(", ")}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '에 관한 주의사항이 있습니다.'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text(
              '자세히보기',
              style: TextStyle(fontSize: 12, color: primary600_bold_text),
            ),
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
        _carefulDiseaseList(userData.diseaseList, drug.nbDocData).isNotEmpty;

        stream: DatabaseService(itemSeq: drugItemSeq).drugData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Drug drug = snapshot.data;
            return Padding(
              key: _key3,
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '효능효과',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: gray750_activated,
                        )
                    ),
                    _drugDocInfo(context, drugItemSeq, 'EE'),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '용법용량',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: gray750_activated,
                        )
                    ),
                    _drugDocInfo(context, drugItemSeq, 'UD'),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '저장방법',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )
                    ),
                    Text(drug.storageMethod,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: gray600,
                        )),
                    Container(
                      height: 10,
                    ),
                    FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailInfo(
                                        drugItemSeq: drugItemSeq,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('자세히 보기',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  color: gray500,
                                  fontSize: 12
                                )),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        )),
                  ]),
            );
          } else {
            return Loading();
          }
        });
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
                    return Text(
                      drug.eeDocData[index].toString(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: gray600,
                        )
                    );
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
                    return Text(
                      drug.udDocData[index].toString(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: gray600,
                        )
                    );
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
          color: Colors.grey[200],
        ),
      ],
    );
  }

  /* Review */
  Widget _drugReviews() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //TODO EDIT num of reviews
              StreamBuilder<Drug>(
                  stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Drug drug = snapshot.data;
                      if (drug.numOfReviews == 0) _ifNoReview();
                      return Text(
                          "리뷰 " + drug.numOfReviews.toStringAsFixed(0) + "개",
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                          ));
                    } else
                      return Loading();
                  }),

              checkIfNoReview() == true
                  ? Container()
                  : InkWell(
                      child: Text('전체리뷰 보기',
                          style: TextStyle(
                            fontSize: 14.5,
                          )),
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
        checkIfNoReview() == true ? Container() : _searchBar(),
        checkIfNoReview() == true
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
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
//        width: 370,
//        width: MediaQuery.of(context).size.width*0.9,
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.grey[200],
        ),
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
                      fillColor: Colors.white12,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
//                      suffixIcon: focusNode.hasFocus
//                          ? IconButton(
//                        icon: Icon(Icons.cancel, size: 20),
//                        onPressed: () {
//                          setState(() {
//                            _filter.clear();
//                            _searchText = "";
//                          });
//                        },
//                      )
//                          : Container(),
                      hintText: '검색',
                      contentPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent))),
                )),
//            focusNode.hasFocus
//                ? Expanded(
//              child: FlatButton(
//                child: Text(
//                  'clear',
//                  style: TextStyle(fontSize: 13),
//                ),
//                onPressed: () {
//                  setState(() {
//                    _filter.clear();
//                    _searchText = "";
//                    focusNode.unfocus();
//                  });
//                },
//              ),
//            )
//                : Expanded(
//              flex: 0,
//              child: Container(),
//            )
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
