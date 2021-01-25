import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/services/db.dart';
import 'ranking_tile.dart';

class DrugList extends StatefulWidget {
  final String categoryName;


  DrugList({this.categoryName});

  @override
  _DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  String _filterOrSort = "리뷰 많은 순";
  //var totalNum = 0; //DatabaseService().getRankingNum();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        //_countDropDown(context, totalNum),
        _countDropDown(context),
        _buildBody(context, _filterOrSort)
      ],
    );

    /*
    return ListView(
      padding: EdgeInsets.all(5.0),
      children: drugs.map((data) => DrugTile(drug: data)).toList(),
    );
    */
  }

//  Widget getNumOfRanking(BuildContext context){
//    return Container(
//      child: FutureBuilder(
//          future: DatabaseService().,//.getRankingNum(),
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              print('이게바로 데이타지');
//              print('${snapshot.data}');
//              return Text(snapshot.data);
//            } else if (snapshot.hasError) {
//              return Text(snapshot.error);
//            } else {
//              print('');
//              return Center(
//                child: Text('NONONO'),
//                  //child: LinearProgressIndicator()
//              );
//            }
//          }
//      ),
//    );
//  }

  Widget _buildBody(BuildContext context, String _filterOrSort) {
    return StreamBuilder<List<Drug>>(
        stream: DatabaseService(categoryName: widget.categoryName)//categoryName: widget.categoryName
            .setForRanking(_filterOrSort),
        builder: (context, stream) {
          if (!stream.hasData) {
            return Center(child: CircularProgressIndicator());
            /*
            return Container(
              padding: EdgeInsets.only(top: 30),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '데이터를 불러오는 중입니다.',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  )),
            );
            */
          } else {
            return _buildList(context, _filterOrSort, stream.data);
          }
        });
  }

  Widget _buildList(
      BuildContext context, String _filterOrSort, List<Drug> drugs) {
    return Expanded(
      child: ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index) {
          return DrugTile(drug: drugs[index], index: (index + 1));
        },
      ),
    );
  }

  String _checkCategoryName(String data) {
    String newName = '';
    //TODO: 이부분 0 --> 7로 바꿔주기 pattern이 0-6까지가 카테고리 이름
    newName = data.substring(7,(data.length));
    return newName;
  }


  Widget _countDropDown(context) {
    String onlyCategoryName = _checkCategoryName(widget.categoryName);

    //Widget _countDropDown(context, num) {
      return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            //샘이가 elevation을 요청했ㄷ
//            decoration: BoxDecoration(
//              border: Border(
//                  bottom: BorderSide( //
//                    color: Colors.grey,
//                    width: 0.5,)
//              ),
//            ),
            height: 35,
            child: Row(
              children: <Widget>[
                //TODO: No sql에서는 count가 현재 지원이 안되고 있어서 일단 1차적으로는 제외하고 가는 거로
//              Container(
//                margin: EdgeInsets.only(left: 20, top: 1),
//                child: Row(
//                  children: <Widget>[
//                    Text('총 ${num} 개 약'), // theme 추가
//                    //getNumOfRanking(context)
//                  ],
//                ),
//              ),
//                Container(
//                  child: Text(onlyCategoryName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
//                ),
                Spacer(),
                DropdownButton<String>(
                  value: _filterOrSort,
                   icon: Icon(Icons.arrow_drop_down),
                   iconSize: 24,
                   elevation: 16,
                  style: TextStyle(color: Colors.black),
//                  underline: Container(
//                    height: 1,
//                    color: Colors.black12,
//                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _filterOrSort = newValue;
                    });
                  },
                  items: <String>['이름순', '리뷰 많은 순']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
        )
      ],
    );
  }
}
