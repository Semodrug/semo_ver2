import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/camera/camera_page.dart';
import 'package:semo_ver2/drug_info/general_edit.dart';
import 'package:semo_ver2/drug_info/prepared_edit.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/theme/colors.dart';

class HomePage extends StatefulWidget {
  String appBarForSearch;

  HomePage({this.appBarForSearch});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //widget.appBarForSearch = false;

    if (widget.appBarForSearch == 'search') {
      return Scaffold(
        // appBar: AppBar(
        //   // centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     '이약모약',
        //     style: TextStyle(
        //         fontSize: 20.0,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black),
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(
        //         Icons.person,
        //         color: Colors.teal[200],
        //       ),
        //     ),
        //     //for test home
        //   ],
        //
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: <Color>[
        //           Color(0xFFE9FFFB),
        //           Color(0xFFE9FFFB),
        //           Color(0xFFFFFFFF),
        //         ])),
        //   ),
        // ),
        backgroundColor: Colors.white,
        body: _buildBody(context),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(context),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<SavedDrug>>(
        stream: DatabaseService(uid: user.uid).savedDrugs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildList(context, snapshot.data);
        });
  }

  Widget _buildList(BuildContext context, List<SavedDrug> snapshot) {
    int count = snapshot.length;
    if (count == 0) {
      return _noDrugPage();
    }

    return Column(
      children: [
        SearchBar(),
        Container(
          height: 45,
          margin: EdgeInsets.only(left: 16, top: 0, bottom: 8, right: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Text('나의 약 보관함',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: gray800)),
                  SizedBox(width: 8),
                  // theme 추가
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      // await Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => AddButton()));
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return _popUpAddDrug(context);
                          });
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        width: 95,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary400_line),
                          color: primary300_main,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: gray0_white, size: 16),
                            Text(
                              '추가하기',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: gray0_white),
                            ),
                            SizedBox(width: 2)
                          ],
                        ))),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 3, thickness: 0.5, indent: 1, endIndent: 0),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot[index], index + 1, count);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
      BuildContext context, SavedDrug data, int index, int totalNum) {
    TheUser user = Provider.of<TheUser>(context);

    double mw = MediaQuery.of(context).size.width;

    String _checkLongName(SavedDrug data) {
      String newName = data.itemName;
      List splitName = [];

      if (data.itemName.contains('(수출') || data.itemName.contains('(군납')) {
        if (newName.contains('')) {
          splitName = newName.split('(');
          newName = splitName[0];
        }
      }
      return newName;
    }

    //TODO: 시간 계산하기 위한 코드 시작
    String dateOfUserDrug = '';
    List<String> getOnlyDate = data.expiration.split('.');

    for (int i = 0; i < getOnlyDate.length; i++) {
      dateOfUserDrug = dateOfUserDrug + getOnlyDate[i];
    }

    String dateWithT = dateOfUserDrug.substring(0, 8) + 'T' + '000000';
    DateTime expirationTime = DateTime.parse(dateWithT);

    String dateNow = DateFormat('yyyyMMdd').format(DateTime.now());
    List<String> getOnlyDateOfNow = dateNow.split('.');

    for (int i = 0; i < getOnlyDateOfNow.length; i++) {
      dateNow = dateNow + getOnlyDateOfNow[i];
    }

    String dateNowWithT = dateNow.substring(0, 8) + 'T' + '000000';
    DateTime rightNowTime = DateTime.parse(dateNowWithT);

    final difference = expirationTime.difference(rightNowTime).inDays;

    //사용기한 7일 남음
    if (difference < 8 && difference > -1) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0),
                        //width: double.infinity,
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 88,
                                  child: DrugImage(drugItemSeq: data.itemSeq)),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: yellow),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _warningRemainMessage(context, difference),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.6, color: gray50))),
                      height: 20,
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0),
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 88,
                                  child: DrugImage(drugItemSeq: data.itemSeq)),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: yellow),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _warningRemainMessage(context, difference),
                      ),
                    )
                  ],
                ),
              ),
      );
    }
    //사용기한 지남
    else if (difference < 0) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0),
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                      width: 88,
                                      child: DrugImage(
                                          drugItemSeq: data.itemSeq))),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: warning),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _warningOverDayMessage(context, difference),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.6, color: gray50))),
                      height: 20,
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0),
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                      width: 88,
                                      child: DrugImage(
                                          drugItemSeq: data.itemSeq))),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: warning),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _warningOverDayMessage(context, difference),
                      ),
                    )
                  ],
                ),
              ),
      );
    }
    //사용기한 아직 넉넉함
    else
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                        ),
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                      width: 88,
                                      child: DrugImage(
                                          drugItemSeq: data.itemSeq))),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 0.6, color: gray50))),
                        height: 20)
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                        ),
                        height: 90,
                        child: Material(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 15,
                                  child: Center(
                                    child: Text(index.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: gray600, fontSize: 11)),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Container(
                                      width: 88,
                                      child: DrugImage(
                                          drugItemSeq: data.itemSeq))),
                              Container(
                                  padding: EdgeInsets.only(left: 12, top: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: mw - 200,
                                          child: Text(_checkLongName(data),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color:
                                                          gray750_activated))),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Container(
                                            height: 23,
                                            child: CategoryButton(
                                                str: data.category,
                                                fromHome: 'home')),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text('${data.expiration}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                          Text('까지 ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: gray600,
                                                      fontSize: 11)),
                                        ],
                                      )
                                    ],
                                  )),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: gray500,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _popUpMenu(
                                              context, data, user);
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
  }

  Widget _popUpAddDrug(context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          )),
      child: Wrap(
        children: <Widget>[
          Container(
            height: 45,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    child: Text(
                      '약 추가하기',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: primary500_light_text),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () async {
                // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
                final cameras = await availableCameras();

                // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
                final firstCamera = cameras.first;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                          camera: firstCamera,
                          initial: 0,
                        ),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/barcode_icon_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "바코드 인식",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () async {
                // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
                final cameras = await availableCameras();

                // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
                final firstCamera = cameras.first;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                        camera: firstCamera,
                        initial: 1,
                        ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/case_icon_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "케이스 인식",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 20,
                    width: 55,
                    child: Center(
                      child: Text("Beta",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: primary600_bold_text, fontSize: 13)),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: gray50,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/search_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "약 이름 검색",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: gray100),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                    child: Text("닫기",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray300_inactivated)))),
          )
        ],
      ),
    );
  }

  Widget _popUpMenu(context, data, user) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          )),
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            if (data.etcOtcCode == '일반의약품') {
                              return GeneralEdit(
                                  drugItemSeq: data.itemSeq,
                                  expirationString: data.expiration);
                            } else {
                              return PreparedEdit(
                                  drugItemSeq: data.itemSeq,
                                  expirationString: data.expiration);
                            }
                          }));
                },
                child: Center(
                    child: Text(
                  "사용기한 수정하기",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray900),
                ))),
          ),
          Padding(
            // padding: EdgeInsets.only(bottom: 4.0),
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
            child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  showWarning(context, '정말 삭제하시겠어요?', '취소', '삭제',
                      'deleteUserDrug', user.uid, data.itemSeq);
                },
                child: Center(
                  child: Text("삭제하기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray900)),
                )),
          ),
          // Divider(thickness: 1, color: gray100),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    // bottom: BorderSide(color: Theme.of(context).hintColor),
                    top: BorderSide(color: gray100)),
              ),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                      child: Text("닫기",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: gray300_inactivated, fontSize: 16)))),
            ),
          )
        ],
      ),
    );
  }

  void showWarning(
      BuildContext context,
      String bodyString,
      String leftButtonName,
      String rightButtonName,
      String actionCode,
      String uid,
      String record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      leftButtonName,
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
                  ElevatedButton(
                      child: Text(
                        rightButtonName,
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

                        showOkWarning(
                          context,
                          Icon(Icons.check, color: primary300_main),
                          '약 보관함에서 삭제되었습니다',
                          '확인',
                        );

                        await DatabaseService(uid: uid)
                            .deleteSavedDrugData(record);
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void showOkWarning(BuildContext context, Widget dialogIcon, String bodyString,
      String buttonName) {
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
              dialogIcon,
              SizedBox(height: 16),
              /* BODY */
              Text(
                bodyString,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: gray700),
              ),
              SizedBox(height: 16),
              /* BUTTON */
              ElevatedButton(
                child: Text(
                  buttonName,
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

  Widget _warningRemainMessage(context, dayRemain) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 70,
      height: 30,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_yellow.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(text: '사용기한이 '),
                    TextSpan(
                      text: '$dayRemain일',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' 남았습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _warningOverDayMessage(context, difference) {
    List<String> dayOver = difference.toString().split('-');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 70,
      height: 30,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_red.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(text: '사용기한이 '),
                    TextSpan(
                      text: '${dayOver[1]}일',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' 지났습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noDrugPage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          SearchBar(),
          Container(
            height: 45,
            margin: EdgeInsets.only(left: 16, top: 0, bottom: 8, right: 16),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text('나의 약 보관함',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: gray800)),
                    SizedBox(width: 8),
                    // theme 추가
                    Spacer(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return _popUpAddDrug(context);
                            });
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          width: 95,
                          height: 26,
                          decoration: BoxDecoration(
                            border: Border.all(color: primary400_line),
                            color: primary300_main,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: gray0_white, size: 16),
                              Text(
                                '추가하기',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: gray0_white),
                              ),
                              SizedBox(width: 2)
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Spacer(),
        ]),
        Positioned(
          top: 102, //118-16
          right: 0,
          child: Container(
            margin: EdgeInsets.only(right: 13),
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: 45,
                    child:
                        Image(image: AssetImage('assets/images/msg_box.png'))),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.30, //194, //210-16 //
          child: Column(
            children: [
              SizedBox(
                  height: 150,
                  child: Image(
                      image:
                          AssetImage('assets/images/background_nothing.png'))),
            ],
          ),
        ),
        Positioned(
          bottom: 18,
          child: Container(
              child: SizedBox(
                  height: 45,
                  child: Image(
                      image: AssetImage('assets/images/bottom_msg_box.png')))),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
          height: 33,
          child: FlatButton(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 5, bottom: 4, right: 5),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/search_icon.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    "어떤 약을 찾고 계세요?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray300_inactivated),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchScreen(),
                  ));
            },
            textColor: gray300_inactivated,
            color: gray50,
            shape: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, width: 1.0, color: gray75),
                borderRadius: BorderRadius.circular(8.0)),
          )),
    );
  }
}
