import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';

import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/theme/colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400]),
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
                child: Text(
                  '찾고자 하는 약을 검색해주세요',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400]),
                )),
          );
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    child: Center(
                        child: Text(
                      '    최근검색어',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                FlatButton(
                  child: Text('전체삭제'),
                  onPressed: () {
                    //print('삭제되었음');
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('searchList')
                        .get()
                        .then((snapshot) {
                      for (DocumentSnapshot ds in snapshot.docs) {
                        ds.reference.delete();
                      }
                    });
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

  Widget _drugFromUserInAll( context, userDrug ) {
    //여기는 user 안에 있는 친구들 불러오는 거!!
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: gray400),
          borderRadius: BorderRadius.circular(10)),
      height: 68,
      width: MediaQuery.of(context).size.width - 20,
      //color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 20,
                  ),
                  Text('나의 약'),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  userDrug.itemName,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: primary500_light_text),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userDrug.expiration,
                  style: TextStyle(color: gray500, fontSize: 10),
                )
              ],
            ),
          ],
        ),
      ),
    );
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
        //   return _buildListOfAll(context, stream.data);
        else {
          var streamFromAll = stream.data;
          return StreamBuilder<Object>(
              stream: DatabaseService(
                      uid: user.uid) //categoryName: widget.categoryName
                  .setForSearchFromUser(searchVal, 30),
              builder: (context, snapshot) {
                return _buildListOfAll(context, streamFromAll, snapshot.data);
              });
        }
      },
    );
    //}
  }

  Widget _buildListOfAll(
      BuildContext context, List<Drug> drugs, List<SavedDrug> userDrugs) {
    if (_searchText.length < 2) {
      return _noResultContainer();
    } else if (_searchText.length != 0) {
      if (userDrugs != null) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userDrugs.length,
                itemBuilder: (context, index) {
                  return _drugFromUserInAll(context, userDrugs[index]);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: drugs.length,
                itemBuilder: (context, index) {
//////////////////////////////
                  //if (userDrugs != null) {
                    for (int j = 0; j < userDrugs.length; j++) {
                      if (drugs[index].itemName == userDrugs[j].itemName) {
                        print(userDrugs[j].itemName);
                        return Container(height: 0.5);
                      } else {
                        return ListDrugOfAll(
                            _checkLongName(drugs[index].itemName),
                            drugs[index].category,
                            drugs[index].itemSeq);
                      }
                    }
                 // }
////////////////////////////
                  return ListDrugOfAll(
                      _checkLongName(drugs[index].itemName),
                      drugs[index].category,
                      drugs[index]
                          .itemSeq); //DrugTile(drug: drugs[index], index: (index + 1));
                },
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index) {
//////////////////////////////
          //Saved Drug에 저장이 되어있던 친구라면 안보여준다
          if (userDrugs != null) {
            for (int j = 0; j < userDrugs.length; j++) {
              if (drugs[index].itemName == userDrugs[j].itemName) {
                return Container(height: 0.5);
              } else {
                return ListDrugOfAll(_checkLongName(drugs[index].itemName),
                    drugs[index].category, drugs[index].itemSeq);
              }
            }
          }
////////////////////////////
          return ListDrugOfAll(
              _checkLongName(drugs[index].itemName),
              drugs[index].category,
              drugs[index]
                  .itemSeq); //DrugTile(drug: drugs[index], index: (index + 1));
        },
      );
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
        } else
          return _buildListOfUser(context, stream.data);
      },
    );
  }

  Widget _buildListOfUser(BuildContext context, List<SavedDrug> drugs) {
    if (_searchText.length < 2) {
      return _noResultContainer();
    } else if (_searchText.length != 0) {
      return ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index) {
          return ListDrugOfUser(
              _checkLongName(drugs[index].itemName),
              drugs[index].itemSeq,
              drugs[index]
                  .expiration); //DrugTile(drug: drugs[index], index: (index + 1));
        },
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
                    //flex: 5,
                    child: TextFormField(
                  cursorColor: Colors.teal[400],
                  onFieldSubmitted: (val) {
                    if (val != '' || val.length > 2) {
                      addRecentSearchList();
                      focusNode.unfocus();
                    }
                  },
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 15),
                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                    //여기서 언덜라인 없애주기
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.white12,
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      icon: Icon(
                        Icons.cancel,
                        size: 20,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        setState(() {
                          _filter.clear();
                          _searchText = "";
                        });
                      },
                    ),
                    hintText: '두 글자 이상 검색해주세요',
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
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
                //Navigator.pushNamed(context, '/bottom_bar');
              },
              child: Text('취소')),
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
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
              tabs: [
                Tab(
                    child:
                        Text('전체 검색', style: TextStyle(color: Colors.black))),
                Tab(
                    child: Text('나의 상비약 검색',
                        style: TextStyle(color: Colors.black))),
              ],
              indicatorColor: Colors.teal[400],
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              width: double.infinity,
              height: height - 200, //440.0,
              child: TabBarView(
                children: [
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

    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            //print('search ==> ${searchSnapshot.recent}'),
            _searchText = searchSnapshot.recent,
            _filter.text = _searchText
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
                  child: Text(
                    searchSnapshot.recent,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 25,
                  child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        //print(docID);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('searchList')
                            .doc(docID)
                            .delete();
                      },
                      child: Text('X')),
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
        //drug 이름 누르면 저장 기능 array로 저장해주기
        userSearchList.add({'searchList': searchList, 'time': DateTime.now()});
      } catch (e) {
        print('Error: $e');
      }
    }

    return GestureDetector(
      onTap: () => {
        addRecentSearchList(),
        Navigator.pop(context),
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
        height: 45.0,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item_name,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListDrugOfUser extends StatelessWidget {
  final String item_name;
  final String item_seq;
  final String expiration;

  const ListDrugOfUser(
    this.item_name,
    this.item_seq,
    this.expiration, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pop(context),
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
        height: 45.0,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item_name,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              child: Text(
                expiration,
                style: TextStyle(color: Colors.grey),
              ),
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

  final DocumentReference reference;

  RecentSearch.fromMap(Map<String, dynamic> map, {this.reference})
      : recent = map['searchList'],
        time = map['time'];

  RecentSearch.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
