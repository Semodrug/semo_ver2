import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/drug_info/set_expiration.dart';
import 'package:semo_ver2/review/review_page.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/models/drug.dart';

import 'package:semo_ver2/home/home_edit.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/home/home_add_button_stack.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/shared/category_button.dart';
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

    int count = snapshot.length;
    return Column(
      children: [
        SearchBar(),
        Container(
          height: 45,
          margin: EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Text('나의 상비약'),
                  SizedBox(width: 8),
                  Container(
                      width: 20,
                      height: 17,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.6, color: Colors.grey[400])
                          // //bottom:BorderSide(width: 0.6, color: Colors.grey[500]))
                          ),
                      child: Center(
                        child: Text(count.toString(),
                            style: TextStyle(
                              color: Colors.tealAccent[700],
                            )),
                      )),
                  // theme 추가
                  Spacer(),
                  FlatButton(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('+ 추가하기',
                        style: TextStyle(color: Colors.tealAccent[700])),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddButton()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Expanded(
          child: ListView(
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, SavedDrug data) {
    TheUser user = Provider.of<TheUser>(context);
    num++;

    /*너무 긴 이름들 잘라서 보여주기 정보를 바꾸는 건 아님*/
    String _checkLongName(SavedDrug data) {
      String newName = data.itemName;
      List splitName = [];

      if (data.itemName.contains('(수출') || data.itemName.contains('(군납')) {
        if (newName.contains('')) {
          splitName = newName.split('(');
          newName = splitName[0];
        }
      }

      if (newName.length > 15) {
        newName = newName.substring(0, 12);
        newName = newName + '...';
      }
      return newName;
    }

    /*혹시라도 카테고리가 없는 애들을 위해서 임시로 만들어 놓음*/
//    String _checkCategory(SavedDrug data) {
//      String newCategory = '카테고리 지정 없음';
//      if (data.category == '')
//        return newCategory;
//      else
//        return data.category;
//    }

    //TODO: 지금 클라우드에 적히지가 않아서 이따 적어야함
    String _checkCategoryName(String data) {
      String newName = '';
      //TODO: 이부분 0 --> 7로 바꿔주기 pattern이 0-6까지가 카테고리 이름
      newName = data.substring(7,(data.length));
      return newName;
    }
    String onlyCategoryName = _checkCategoryName(data.category);

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
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16.0),
              width: double.infinity,
              height: 90,
              child: Material(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        width: 20,
                        child: Center(
                          child: Text(
                            num.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        //이미지는 고정값
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                            width: 80,
                            child: AspectRatio(
                                aspectRatio: 3.5 / 2,
                                child: DrugImage(drugItemSeq: data.itemSeq)))),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                _checkLongName(data),
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            //SizedBox(height: 2,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Container(
                                height: 20,
                                 child: CategoryButton(str: data.category)
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              data.expiration,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            )
                          ],
                        )),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.more_vert, size: 20),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                    child: Container(
                                        child: Wrap(
                                  children: <Widget>[
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) =>
                                                      Expiration(
                                                        drugItemSeq:
                                                            data.itemSeq,
                                                      )));
                                        },
                                        child: Center(
                                            child: Text("수정하기",
                                                style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontSize: 16)))),
                                    MaterialButton(
                                        onPressed: () {
                                          FirebaseFirestore
                                              .instance //user가 가지고 있는 약 data
                                              .collection('users')
                                              .doc(user.uid)
                                              .collection('savedList')
                                              .doc(data.itemSeq)
                                              .delete();
                                        },
                                        child: Center(
                                            child: Text("삭제하기",
                                                style: TextStyle(
                                                    color: Colors.red[600],
                                                    fontSize: 16)))),
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(
                                            child: Text("취소",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16))))
                                  ],
                                )));
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            '$str',
            style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
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

    //이 search bar에서 바로 검색을 하게 할 것인가?
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
          //width: searchWidth,
          height: 35,
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
                    style: BorderStyle.solid, width: 1.0, color: Colors.white),
                borderRadius: new BorderRadius.circular(8.0)),
          )),
    );
  }
}
