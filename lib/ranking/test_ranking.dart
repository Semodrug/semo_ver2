import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/home/search_screen.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/services/db.dart';
import 'ranking_list.dart';

class TestRanking extends StatelessWidget {
  final String categoryName;

  TestRanking({this.categoryName});

  String _checkCategoryName(String data) {
    String newName = '';

    newName = data.substring(7,(data.length));
    print('newName = $newName ');
    return newName;
  }


  @override
  Widget build(BuildContext context) {
    String onlyName = _checkCategoryName(categoryName);
    return
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.teal[400],
                ),
                onPressed: () => Navigator.pushNamed(context, '/bottom_bar'),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    onlyName,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              actions: [
                //for search
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.teal[200],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                      print('     PRESSED  ');
                    }),
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
            body:
//            StreamProvider<List<Drug>>.value(
//              value: DatabaseService().drugs, //데이타를 여기서 불러옴
//              child:
            DrugList(categoryName: categoryName),
           // )
        );
  }
}
