import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/review/review_page.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/models/drug.dart';

import 'package:semo_ver2/home/home_edit.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/home/home_add_button_stack.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/shared/image.dart';

/*약들의 개수를 length 만큼 보여주고 싶은데 그 length의 인덱스를 어떻게 넘겨주지..?*/
int num = 0;

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
        appBar: AppBar(
          // centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            '이약모약',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.teal[200],
              ),
            ),
            //for test home
          ],

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
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data);
        });
  }

  Widget _buildList(BuildContext context, List<SavedDrug> snapshot) {
    num = 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    int count = snapshot.length;
    return Column(
      children: [
        SearchBar(),
        Container(
          margin: EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 16),
          child: Row(
            children: <Widget>[
              Row(
                children: [
                  Text('나의 상비약'),
                  SizedBox(width: 10),
                  Text(count.toString())
                ],
              ),
              // theme 추가

//              SizedBox(
//                width: width/2.3
//              ),
              Spacer(),
              TextButton(
                child: Text(
                  '편집',
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeEditPage()));
                },
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Expanded(
          child:

          ListView(
            //padding: EdgeInsets.symmetric(horizontal : 20.0),
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: double.infinity, //width/33 * 28.7,
          height: height / 10,
          //buttonColor: Colors.redAccent,
          child: FlatButton.icon(
            color: Color(0XFFEEEEEE),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddButton()));
            },
            //padding: EdgeInsets.fromLTRB(20, 5, 5, 15),
            label: Text('상비약 추가하기'),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, SavedDrug data) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    num++;

    /*너무 긴 이름들 잘라서 보여주기 정보를 바꾸는 건 아님*/
    String _checkLongName(SavedDrug data) {
      String newName = data.itemName;
      List splitName = [];
      if (data.itemName.contains('(') || data.itemName.contains('(군납') ) {
        newName = data.itemName.replaceAll('(', '(');
        if (newName.contains('')) {
          splitName = newName.split('(');
          print(splitName);
          newName = splitName[0];
        }
      }
      return newName;
    }

    /*혹시라도 카테고리가 없는 애들을 위해서 임시로 만들어 놓음*/
    String _checkCategory(SavedDrug data) {
      String newCategory = '카테고리 지정 없음';
      if (data.category == '')
        return newCategory;
      else
        return data.category;
    }

    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
//            builder: (context) => PhilInfoPage(drugItemSeq: data.itemSeq),
            builder: (context) => ReviewPage(data.itemSeq),
          ),
        ),
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: double.infinity,
            height: 100.0,
            child: Material(
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: width / 20,
                    child: Center(
                      child: Text(num.toString()),
                    ),
                  ),
                  Container(
                      //이미지는 고정값
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                          height: 70,
                          width: 88,
                          child: AspectRatio(
                              aspectRatio: 2.3 / 2,
                              child: DrugImage(drugItemSeq: data.itemSeq)))),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              _checkLongName(data),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ]),
                          Expanded(
                              child: Row(
                            children: [_categoryButton((_checkCategory(data)))],
                          )),
                          SizedBox(
                            height: 3,
                          ),
                          Expanded(
                            child: Text(
                              data.expiration,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  Widget _categoryButton(str) {
    return Container(
      width: 24 + str.length.toDouble() * 10,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: ButtonTheme(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        minWidth: 10,
        height: 22,
        child: RaisedButton(
          child: Text(
            '#$str',
            style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
          ),
          onPressed: () => print('$str!'),
          color: Colors.white,
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double searchWidth =  width / 33 * 30.1;
    double searchHeight =  height / 20;

    //이 search bar에서 바로 검색을 하게 할 것인가?
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: SizedBox(
              width: searchWidth,
              height: searchHeight,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(child: Icon(Icons.search, size: 20)),
                    SizedBox(
                      width: 10,
                    ),
                    Text("어떤 약을 찾고 계세요? "),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchScreen(),
                    ),
                  );
                },
                textColor: Colors.grey[500],
                color: Colors.grey[200],
                shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 1.0,
                        color: Colors.white),
                    borderRadius: new BorderRadius.circular(8.0)),
              )),
        ),
//        SizedBox(
//          width: 10,
//        ),
      ],
    );
  }
}
