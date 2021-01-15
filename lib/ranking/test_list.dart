import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/services/db.dart';
import 'test_tile.dart';

class DrugList extends StatefulWidget {
  final String categoryName;

  DrugList({this.categoryName});

  @override
  _DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  String _filterOrSort = "이름순";
  int totalNum = 0;

  @override
  Widget build(BuildContext context) {
    print('build');
    print(' ');
    //일단 total num을 위해 임시로 열어둔 프로바이더
    //List<Drug> drugs = Provider.of<List<Drug>>(context) ?? [];
    //totalNum = drugs.length;

    return Column(
      children: [
        _countDropDown(context, totalNum),
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

  Widget _buildBody(BuildContext context, String _filterOrSort) {
    print('BODY');
    print(' ');
    return StreamBuilder<List<Drug>>(
        stream: DatabaseService(categoryName: widget.categoryName)
            .setter(_filterOrSort),
        builder: (context, stream) {
          if (!stream.hasData) {
            print('데이터를 불러오는 중입니다.');
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
            //return LinearProgressIndicator();
          } else {
            print('데이터 있음');
            return _buildList(context, _filterOrSort, stream.data);
          }
        });
  }

  Widget _buildList(
      BuildContext context, String _filterOrSort, List<Drug> drugs) {
    //print('길이 알려주기 !! '+ '${drugs.length}');
    //totalNum = drugs.length;
    List<Drug> drugList = [];
    drugList = drugs;
    print('   길이  ${drugList.length.toString()}');
    print(drugList[0].itemName);
    print(drugList[0].itemSeq);

    print('  ');
    return Expanded(
      child: ListView.builder(
        itemCount: drugList.length,
        itemBuilder: (context, index) {
          return DrugTile(drug: drugList[index], index: (index + 1));
        },
      ),
    );
  }

  Widget _countDropDown(context, num) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 1),
                child: Row(
                  children: <Widget>[
                    Text('총 ${totalNum} 개 약'), // theme 추가
                  ],
                ),
              ),
              Spacer(),
              DropdownButton<String>(
                value: _filterOrSort,
                // icon: Icon(Icons.arrow_drop_down),
                // iconSize: 24,
                // elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 1,
                  color: Colors.black12,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _filterOrSort = newValue;
                    print('NEW == $_filterOrSort');
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
        Divider(
          thickness: 1,
        )
      ],
    );
  }
}
