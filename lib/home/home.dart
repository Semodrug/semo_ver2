import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/models/drug.dart';

import 'package:semo_ver2/home/home_edit.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/home/home_add_button_stack.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/shared/image.dart';

/*약들의 개수를 length 만큼 보여주고 싶은데 그 length의 인덱스를 어떻게 넘겨주지..?*/
int check = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
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
    check = 0;

    int count = snapshot.length;
    return Column(
      children: [
        SearchBar(),
        Container(
          margin: EdgeInsets.only(left: 19, top: 6, bottom: 2),
          child: Row(
            children: <Widget>[
              Text('나의 상비약'), // theme 추가
              ButtonTheme(
                //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                height: 10,
                minWidth: 20,
                child: FlatButton(
                  child: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
                  ),
                ),
              ),
              SizedBox(
                width: 180,
              ),
              FlatButton(
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
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
        ButtonTheme(
          padding: EdgeInsets.fromLTRB(50, 0, 5, 15),
          minWidth: 340.0,
          height: 70.0,
          //buttonColor: Colors.redAccent,
          child: RaisedButton.icon(
            color: Colors.white70,
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddButton()));
            },
            padding: EdgeInsets.fromLTRB(20, 5, 5, 15),
            label: Container(
              width: 340,
              padding: const EdgeInsets.all(10.0),
              child: const Text('상비약 추가하기'),
            ),
          ),
        )
      ],
    );
  }


  Widget _buildListItem(BuildContext context, SavedDrug data ) {
    check++;
    /*너무 긴 이름들 잘라서 보여주기 정보를 바꾸는 건 아님*/
    String _checkLongName(SavedDrug data) {
      String newName = data.itemName;
      List splitName = [];
      if (data.itemName.contains('(')) {
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
            builder: (context) => PhilInfoPage(drugItemSeq: data.itemSeq),
          ),
        ),
      },
      child: Container(
        width: double.infinity,
        height: 100.0,
        child: Material(
            color: Colors.white,
            child:
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                      child: Center(
                        child: Text(check.toString()),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: SizedBox(
                            width: 88, height: 66, child: DrugImage(data.itemSeq))),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 20, 5, 5),
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
                                child:
                                Row(
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

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    //이 search bar에서 바로 검색을 하게 할 것인가?
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: 10,
          ),
          margin: EdgeInsets.fromLTRB(0, 11, 0, 0),
          child: SizedBox(
              width: 390,
              height: 35,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search, size: 20),
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
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
