import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/review/phil_info.dart';
import 'home.dart';

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
        print('=== CHANGED === ');
        print(_filter.value);
      });
    });
  }

  Widget _buildBodyOfAll(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('drug').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
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
    } else if (searchResults.length != 0) {
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

    return ListDrugOfAll(drug_snapshot.item_name, drug_snapshot.category,
        drug_snapshot.item_seq);
  }

  Widget _buildBodyOfUser(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .collection('savedList')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
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
    return ListDrugOfUser(
      drugFromUser.item_name,
      drugFromUser.item_seq,
      drugFromUser.expiration,
    );
  }

  @override
  Widget build(BuildContext context) {
    String searchList;

    Future<void> addRecentSearchList() async {
      try {
        assert(_searchText != null);

        searchList = _searchText;
        assert(searchList != null);

        userSearchList.add({'searchList': searchList});

        print('DONE !!!! saved searchList');
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bottom_bar');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 20,
                          )),
                    ),
                    Container(
                      width: 320,
                      height: 35,
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              //flex: 5,
                              child: TextField(
                            focusNode: focusNode,
                            style: TextStyle(fontSize: 15),
                            autofocus: true,
                            controller: _filter,
                            decoration: InputDecoration(
                              fillColor: Colors.white12,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                  });
                                },
                              ),
                              hintText: '어떤 약을 찾고 계세요?',
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
                          )),
                        ],
                      ),
                    ),
                    focusNode.hasFocus
                        ? Expanded(
                            child: FlatButton(
                              child: Text(
                                '확인', //TODO: 확인 눌렀을 때, 결과 값 보여주기
                                style: TextStyle(fontSize: 13),
                              ),
                              onPressed: () {
                                setState(() {
                                  //_searchText = "";
                                  //TODO: Update the recentSearchList[]
                                  addRecentSearchList();
                                  print(searchList);
                                  _filter.clear();
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
            child: _myTab(),
          )
        ],
      ),
    );
  }

  Widget _myTab() {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
              //indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                /*여기는 일단 버튼 형식처럼 해놓은 TabBar
                Tab(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('전체 검색',
                                style: TextStyle(color: Colors.black))))),
                Tab(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('나의 상비약 검색 ',
                                style: TextStyle(color: Colors.black))))),
                indicator: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFFE9FFFB),
                  Color(0xFFE9FFFB),
                ]),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
              ),
                */
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
                children: [_buildBodyOfAll(context), _buildBodyOfUser(context)],
              ),
            )
          ],
        ));
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
                builder: (context) =>
                    PhilInfoPage(drugItemSeq: widget.item_seq))),
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
                builder: (context) =>
                    PhilInfoPage(drugItemSeq: widget.item_seq))),
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
