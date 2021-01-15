import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/review/review_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  CollectionReference userSearchList = FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser.uid)
      .collection('searchList');

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  Widget _buildBodyOfAll(BuildContext context, String searchVal) {
    return StreamBuilder<QuerySnapshot>(
      //현재 2만개 정도 들어와있는 데이터 //todo:안먹음 그래서 조치가 필요 검색어에 따른 정보만 보여주게끔 해야한다.
      stream: FirebaseFirestore.instance
          .collection('Drugs')
          .where('ITEM_NAME', isGreaterThanOrEqualTo: searchVal)
          .limit(10)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
       // if (!snapshot.hasData) return LinearProgressIndicator();
        if (searchVal == '') {
          return StreamBuilder<QuerySnapshot>(
            stream: userSearchList.snapshots(),
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.data.docs.length == 0) return Container(
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
                      //SizedBox(width: 20,),
                      Container(
                          height: 30,
                          child: Center(child: Text('    최근검색어', style: TextStyle(fontWeight: FontWeight.bold),))
                      ),
                      FlatButton(
                        child: Text('전체삭제'),
                        onPressed: (){
                          print('삭제되었음');
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser.uid)
                              .collection('searchList')
                              .get().then((snapshot) {
                            for (DocumentSnapshot ds in snapshot.docs){
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
        return _buildListOfAll(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildListOfAll(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }

    if (searchResults.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              '일치하는 약이 없습니다',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400]),
            )),
      );
    }
    else if (searchResults.length != 0) {
      return ListView(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        children: searchResults
            .map((data) => _buildListItemOfAll(context, data))
            .toList(),
      );
    }
  }

  Widget _buildListItemOfAll(BuildContext context, DocumentSnapshot data) {
    final drug_snapshot = Drugs.fromSnapshot(data);

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

    String cutName = _checkLongName(drug_snapshot.item_name);

    return ListDrugOfAll(
        cutName, drug_snapshot.category, drug_snapshot.item_seq);
  }

  Widget _buildBodyOfUser(BuildContext context, String searchVal) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .collection('savedList')
          .where('ITEM_NAME', isGreaterThanOrEqualTo: searchVal)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (searchVal == '') {
          return StreamBuilder<QuerySnapshot>(
            stream: userSearchList.snapshots(),
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.data.docs.length == 0) return Container(
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
                      //SizedBox(width: 20,),
                      Container(
                          height: 30,
                          child: Center(child: Text('    최근검색어', style: TextStyle(fontWeight: FontWeight.bold),))
                      ),
                      FlatButton(
                        child: Text('전체삭제'),
                        onPressed: (){
                          print('삭제되었음');
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser.uid)
                              .collection('searchList')
                              .get().then((snapshot) {
                            for (DocumentSnapshot ds in snapshot.documents){
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

        return _buildListOfUser(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildListOfUser(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }
    if (searchResults.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              '일치하는 약이 없습니다',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400]),
            )),
      );
    } else {
      return ListView(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        children: searchResults
            .map((data) => _buildListItemOfUser(context, data))
            .toList(),
      );
    }
  }

  Widget _buildListItemOfUser(BuildContext context, DocumentSnapshot data) {
    final drugFromUser = DrugFromUser.fromSnapshot(data);

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

    String cutName = _checkLongName(drugFromUser.item_name);

    return ListDrugOfUser(
      cutName,
      drugFromUser.item_seq,
      drugFromUser.expiration,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double searchWidth =  width / 33 * 24;
    double searchHeight =  height / 17;

    String searchList;

    Future<void> addRecentSearchList() async {
      try {
        assert(_searchText != null);

        searchList = _searchText;
        assert(searchList != null);

        userSearchList.add({'searchList': searchList});

        print('DONE !!!! saved searchList $searchList');
      } catch (e) {
        print('Error: $e');
      }
    }

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
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/bottom_bar');
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 20,
                        )),
                    Container(
                      width: searchWidth,
                      height: searchHeight,
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                      //margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            //flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  focusNode: focusNode,
                                  style: TextStyle(fontSize: 15),
                                  autofocus: true,
                                  controller: _filter,
                                  decoration: InputDecoration(
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
                                      padding: EdgeInsets.fromLTRB(0,0,0,0),
                                      icon: Icon(Icons.cancel, size: 20, color: Colors.teal,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _filter.clear();
                                          _searchText = "";
                                        });
                                      },
                                    ),
                                    hintText: '어떤 약을 찾고 계세요?',
                                    contentPadding: EdgeInsets.fromLTRB(0,0,0,0),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                        borderSide:
                                        BorderSide(color: Colors.transparent)),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    focusNode.hasFocus
                        ? Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          '확인', //TODO: 확인 눌렀을 때, 결과 값 보여주기
                          style: TextStyle(fontSize: 13),
                        ),
                        onPressed: () {
                          setState(() {
                            //_searchText = "";
                            //TODO: Update the recentSearchList[]
                            addRecentSearchList();
                            //print(searchList);
                            //_filter.clear();
                            focusNode.unfocus();
                          });
                        },
                      ),
                    )
                        : Expanded(
                      flex: 0,
                      child: Container(),
                    )
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _myTab(_searchText),
          )
        ],
      ),
    );
  }

  Widget _myTab(String searchVal) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
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
              height: 500.0,
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


    return
      Column(
        children: [
          GestureDetector(
            onTap: () => {
              print('search ==> ${searchSnapshot.recent}'),
              _searchText = searchSnapshot.recent,
              _filter.text = _searchText
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              child: Material(
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                  searchSnapshot.recent,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ]),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ),
          Divider(thickness: 1,)
        ],
      );

  }

}

class ListDrugOfAll extends StatefulWidget {
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
  _ListDrugState createState() => _ListDrugState();
}

class ListDrugOfUser extends StatefulWidget {
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
  _ListDrugUserState createState() => _ListDrugUserState();
}

class _ListDrugState extends State<ListDrugOfAll> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
//                builder: (context) =>
//                    PhilInfoPage(drugItemSeq: widget.item_seq)
              builder: (context) => ReviewPage(widget.item_seq),
            )),
      },
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: Material(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            widget.item_name,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ]),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}

class _ListDrugUserState extends State<ListDrugOfUser> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
//                builder: (context) =>
//                    PhilInfoPage(drugItemSeq: widget.item_seq)
              builder: (context) => ReviewPage(widget.item_seq),
            )),
      },
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: Material(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            widget.item_name,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            widget.expiration,
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ]),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}

class DrugFromUser {
  final String item_name;
  final String item_seq;
  final String expiration;

  final DocumentReference reference;

  DrugFromUser.fromMap(Map<String, dynamic> map, {this.reference})
      :
  //assert(map['expiration'] != null),
        item_name = map['ITEM_NAME'],
        item_seq = map['ITEM_SEQ'],
        expiration = map['expiration'];

  DrugFromUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Drugs {
  final String item_name;
  final String image;
  final String entp_name;
  final String item_seq;
  final String valid_term;
  final String category;

  final DocumentReference reference;

  Drugs.fromMap(Map<String, dynamic> map, {this.reference})
      : item_name = map['ITEM_NAME'],
        image = map['image'],
        entp_name = map['ENTP_NAME'],
        item_seq = map['ITEM_SEQ'],
        valid_term = map['VALID_TERM'],
        category = map['category'];

  Drugs.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class RecentSearch{
  final String recent;

  final DocumentReference reference;

  RecentSearch.fromMap(Map<String, dynamic> map, {this.reference})
      : recent = map['searchList'];

  RecentSearch.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

}
