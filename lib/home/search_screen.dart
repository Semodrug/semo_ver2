import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';

import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/theme/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  //전체삭제했을 때 dialog
  void showWarning(BuildContext context, String bodyString, String actionName1,
      String actionName2, String actionCode, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18),
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      actionName1,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: Text(
                      actionName2,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: gray0_white),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: primary300_main,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () async {
                      if (actionCode == 'deleteSearchedList') {
                        await Navigator.of(context).pop();
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('searchList')
                            .get()
                            .then((snapshot) {
                          for (DocumentSnapshot ds in snapshot.docs) {
                            ds.reference.delete();
                          }
                        });
                      }
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
  String _checkLongName(String data) {
    String newName = data;
    List splitName = [];
    if (data.contains('(')) {
      newName = data.replaceAll('(', '(');
      if (newName.contains('')) {
        splitName = newName.split('(');
        // print(splitName);
        newName = splitName[0];
      }
    }
    return newName;
  }

  Widget _noResultContainer() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '검색 결과가 없습니다',
            style:
                Theme.of(context).textTheme.headline5.copyWith(color: gray500),
          )),
    );
  }

  Widget _streamOfSearch(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    return StreamBuilder<QuerySnapshot>(
      stream: userSearchList.orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Container(
            padding: EdgeInsets.only(top: 30),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('찾고자 하는 약을 검색해주세요',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: gray500))),
          );
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    child: Center(
                        child: Text('    최근검색어',
                            style: Theme.of(context).textTheme.subtitle1))),
                FlatButton(
                  child: Text('전체삭제',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 13)),
                  onPressed: () {
                    //print('삭제되었음');
                    showWarning(context, '전체 삭제 하시겠습니까?', '취소', '삭제',
                        'deleteSearchedList', user.uid);
                  },
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                children: snapshot.data.docs
                    .map((data) => _buildRecentSearchList(context, data))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _drugListFromUser(context, userDrug) {
    //여기는 user 안에 있는 친구들 불러오는 거!!
    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(userDrug.itemName != null);

        searchList = userDrug.itemName;
        assert(searchList != null);
        //drug 이름 누르면 저장 기능
        userSearchList.add({
          'searchList': searchList,
          'time': DateTime.now(),
          'itemSeq': userDrug.itemSeq
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    QuerySnapshot _query;
    return GestureDetector(
        onTap: () async => {
          _query = await userSearchList
              .where('searchList', isEqualTo: userDrug.itemName)
              .get(),
          if (_query.docs.length == 0)
            {
              addRecentSearchList(),
            },
              //Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(userDrug.itemSeq),
                  )),
            },
        child: Container(
          padding: EdgeInsets.only(left: 16, bottom: 4),
          height: 40,
          child: Row(
            children: [
              Text(
                _checkLongName(userDrug.itemName),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: primary500_light_text),
              ),
              SizedBox(
                width: 10,
              ),
              Text(userDrug.expiration,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 10, color: gray300_inactivated))
            ],
          ),
        ));
  }

  Widget _buildBodyOfAll(BuildContext context, String searchVal) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<Drug>>(
      stream: DatabaseService() //categoryName: widget.categoryName
          .setForSearchFromAll(searchVal, 30),
      builder: (context, stream) {
        if (!stream.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (searchVal == '' || searchVal.length < 2) {
          return _streamOfSearch(context);
        }
        // else
        else if (stream.data.isEmpty) {
          return _noResultContainer();
        } else {
          var streamFromAll = stream.data;
          return StreamBuilder<Object>(
              stream: DatabaseService(
                      uid: user.uid) //categoryName: widget.categoryName
                  .setForSearchFromUser(searchVal, 30),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            //유저가 가지고 있는 부분
                            _buildListOfAll(
                                context, streamFromAll, snapshot.data, 'USER'),
                            _buildListOfAll(context, streamFromAll,
                                snapshot.data, 'withoutUser'),
                          ],
                        ),
                      ),
                    ],
                  );
              });
        }
      },
    );
    //}
  }

  Widget _buildListOfAll(BuildContext context, List<Drug> drugs,
      List<SavedDrug> userDrugs, String type) {
    if (_searchText.length < 2) {
      return _noResultContainer();
    } else if (_searchText.length != 0) {
      if (!userDrugs.isEmpty) {
        if (type == 'USER') {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFCACCCC)),
                borderRadius: BorderRadius.circular(5),
              ),
              //padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0, left: 12, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          color: Color(0xFFCACCCC),
                          size: 22,
                        ),
                        Text(
                          ' 나의 약 리스트',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: gray500),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: userDrugs.length,
                    itemBuilder: (context, index) {
                      return _drugListFromUser(context, userDrugs[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (type == 'withoutUser') {
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: drugs.length,
            itemBuilder: (context, index) {
              for (int j = 0; j < userDrugs.length; j++) {
                if (drugs[index].itemName == userDrugs[j].itemName) {
                  return Container();
                }
              }
              return ListDrugOfAll(_checkLongName(drugs[index].itemName),
                  drugs[index].category, drugs[index].itemSeq);
            },
          );
        }
      } else if (type == 'withoutUser') {
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: drugs.length,
          itemBuilder: (context, index) {
            for (int j = 0; j < userDrugs.length; j++) {
              if (drugs[index].itemName == userDrugs[j].itemName) {
                return Container();
              }
            }
            return ListDrugOfAll(_checkLongName(drugs[index].itemName),
                drugs[index].category, drugs[index].itemSeq);
          },
        );
      } else
        return Container();
    }
  }

  Widget _buildBodyOfUser(BuildContext context, String searchVal) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<SavedDrug>>(
      stream: DatabaseService(uid: user.uid) //categoryName: widget.categoryName
          .setForSearchFromUser(searchVal, 10),
      builder: (context, stream) {
        if (!stream.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (searchVal == '' || searchVal.length < 2) {
          return _streamOfSearch(context);
        } else if (stream.data.isEmpty) {
          return _noResultContainer();
        } else
          //return _buildListOfUser(context, stream.data);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    //유저가 가지고 있는 부분
                    _buildListOfUser(context, stream.data)
                  ],
                ),
              ),
            ],
          );
      },
    );
  }

  Widget _buildListOfUser(BuildContext context, List<SavedDrug> userDrugs) {
    if (_searchText.length < 2) {
      return _noResultContainer();
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFCACCCC)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12, bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      color: Color(0xFFCACCCC),
                      size: 22,
                    ),
                    Text(
                      ' 나의 약 리스트',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: gray500),
                    )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: userDrugs.length,
                itemBuilder: (context, index) {
                  return _drugListFromUser(context, userDrugs[index]);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [_searchBar(context)],
            ),
          ),
          SliverToBoxAdapter(
            child: _myTab(_searchText),
          )
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(_searchText != null);

        searchList = _searchText;
        assert(searchList != null);
        //검색어 저장 기능 array로 저장해주기
        userSearchList.add({'searchList': searchList, 'time': DateTime.now()});
      } catch (e) {
        print('Error: $e');
      }
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            width: 300,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: TextFormField(
                      cursorColor: primary300_main,
                      onFieldSubmitted: (val) async {
                        if (val != '' || val.length > 2) {
                          QuerySnapshot _query = await userSearchList
                              .where('searchList', isEqualTo: val)
                              .get();
                          if (_query.docs.length == 0) {
                            addRecentSearchList();
                          }
                          focusNode.unfocus();
                        }
                      },
                      focusNode: focusNode,
                      style: Theme.of(context).textTheme.bodyText2,
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(
                              Icons.cancel,
                              size: 20,
                              color: primary300_main,
                            ),
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
                            },
                          ),
                          fillColor: gray50,
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child:
                                  Image.asset('assets/icons/search_grey.png'),
                            ),
                          ),
                          hintText: '두 글자 이상 입력해주세요',
                          hintStyle:
                              Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: gray300_inactivated,
                                  ),
                          contentPadding: EdgeInsets.zero,
                          labelStyle:
                              Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: gray300_inactivated,
                                  ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: gray75)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
        ),
        Spacer(),
        SizedBox(
          width: 50,
          child: FlatButton(
              padding: EdgeInsets.only(right: 10),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '취소',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: gray700),
              )),
        )
      ],
    );
  }

  Widget _myTab(String searchVal) {
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelStyle: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w100),
              tabs: [
                Tab(
                    child: Text(
                  '전체 검색',
                  style: Theme.of(context).textTheme.subtitle1,
                )),
                Tab(
                    child: Text(
                  '나의 약 검색',
                  style: Theme.of(context).textTheme.subtitle1,
                )),
              ],
              indicatorColor: Colors.teal[400],
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              width: double.infinity,
              height: height - 200, //440.0,
              child: TabBarView(
                children: [
                  //_buildWithUserOfAll(context, searchVal),
                  _buildBodyOfAll(context, searchVal),
                  _buildBodyOfUser(context, searchVal)
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildRecentSearchList(BuildContext context, DocumentSnapshot data) {
    final searchSnapshot = RecentSearch.fromSnapshot(data);
    final docID = data.id;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    return Column(
      children: [
        GestureDetector(
          onTap: () async => {
            if (searchSnapshot.itemSeq != null)
              {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(searchSnapshot.itemSeq),
                    )),
              }
            //print('search ==> ${searchSnapshot.recent}'),
            else
              {_searchText = searchSnapshot.recent, _filter.text = _searchText}
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.4, color: Colors.grey[400]))),
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: 45.0,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(searchSnapshot.recent,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
                Spacer(),
                SizedBox(
                  width: 25,
                  child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        //print(docID);
                        userSearchList.doc(docID).delete();
                      },
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xffB1B2B2),
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ListDrugOfAll extends StatelessWidget {
  final String item_name;
  final String category;
  final String item_seq;

  const ListDrugOfAll(
    this.item_name,
    this.category,
    this.item_seq, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(item_name != null);

        searchList = item_name;
        assert(searchList != null);
        //drug 이름 누르면 저장 기능
        userSearchList.add({
          'searchList': searchList,
          'time': DateTime.now(),
          'itemSeq': item_seq
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    QuerySnapshot _query;
    return GestureDetector(
      onTap: () async => {
        _query = await userSearchList
            .where('searchList', isEqualTo: item_name)
            .get(),
        if (_query.docs.length == 0)
          {
            addRecentSearchList(),
          },
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(item_seq),
            )),
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.4, color: Colors.grey[400]))),
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 40.0,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text(item_name, style: Theme.of(context).textTheme.bodyText2),
            )
          ],
        ),
      ),
    );
  }
}

class RecentSearch {
  final String recent;
  final Timestamp time;
  final String itemSeq;

  final DocumentReference reference;

  RecentSearch.fromMap(Map<String, dynamic> map, {this.reference})
      : recent = map['searchList'],
        itemSeq = map['itemSeq'],
        time = map['time'];

  RecentSearch.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
