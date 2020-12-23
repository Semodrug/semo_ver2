import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;
//final String auth_id = _auth.currentUser.uid;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<bool> isSelected = List.generate(2, (_) => false);

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

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('drug')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }
    return Expanded(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0,10,0,0),
        children:
            searchResults.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final drug_snapshot = Drugs.fromSnapshot(data);
    final drugFromUser = DrugFromUser.fromSnapshot(data);

    String docID = data.id;

    return ListDrug(
        drug_snapshot.item_name,
        drug_snapshot.category,
        //drugFromUser.expiration
       );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 7),
        child: Column(
          children: [
            //Padding(padding: EdgeInsets.all(30)),
            Row(
              children: [
//                IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
//                  Navigator.pushNamed(context, '/home');}
//                ),
                Container(
                  width: 330,
                  height: 45,
                  padding: EdgeInsets.only(top: 3,),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                suffixIcon: focusNode.hasFocus
                                    ? IconButton(
                                        icon: Icon(Icons.cancel, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _filter.clear();
                                            _searchText = "";
                                          });
                                        },
                                      )
                                    : Container(),
                                hintText: '어떤 약을 찾고 계세요?',
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
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
                        _filter.clear();
                        _searchText = "";
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
            SizedBox(height: 7,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  ToggleButtons(
                    constraints: BoxConstraints(
                      minWidth: 185,
                      minHeight: 30,
                    ),
                    children: [Text('전체 검색'), Text('나의 상비약 검색')],
                    //selectedColor: Colors.teal[400],
                    //fillColor: Colors.teal[100],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),

              ],
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }
}

class ListDrug extends StatefulWidget {
  final String item_name;
  final String category;
  //final String expiration;

  const ListDrug(
      this.item_name,
      this.category,
      //this.expiration,
      {
        Key key,
      }) : super(key: key);

  @override
  _ListDrugState createState() => _ListDrugState();
}

class _ListDrugState extends State<ListDrug> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        print("   ==> pushed")
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => PhilInfoPage(index))),
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
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ]),
                        SizedBox(
                          height: 3,
                        ),
//                        Expanded(
//                          child: Text(
//                            widget.expiration,
//                            style: TextStyle(
//                                color: Colors.grey[600], fontSize: 13),
//                          ),
//                        )
                      ],
                    )),
              ],
            )),
      ),
    );
  }

}

