import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/services/db.dart';
import 'test_tile.dart';

class DrugList extends StatefulWidget {
  @override
  _DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  String _filterOrSort = "이름순";
  int totalNum = 0;

  @override
  Widget build(BuildContext context) {
    final drugs = Provider.of<List<Drug>>(context) ?? [];
    totalNum = drugs.length;
    Query query = DatabaseService().getDrugQuery();

    Stream<QuerySnapshot> data = query.snapshots();


    switch (_filterOrSort) {
      case "이름순":
        query = query.orderBy('ITEM_NAME', descending: false);
        break;

      case "리뷰 많은 순":
        query = query.orderBy('review', descending: false);
        break;
    }
    return _buildBody(context, data);

    /*
    return Column(
      children: [
        _countDropDown(context, totalNum),
        Expanded(
          child:
          ListView.builder(
              itemCount: drugs.length,
              itemBuilder: (context, index){
                return DrugTile(drug: drugs[index], index: (index+1));
              },
          ),
        ),
      ],
    );
    */
    /*
    return ListView(
      padding: EdgeInsets.all(5.0),
      children: drugs.map((data) => DrugTile(drug: data)).toList(),
    );
    */
  }

  Widget _buildBody(BuildContext context, Stream<QuerySnapshot> drugs) {
    return StreamBuilder<QuerySnapshot>(
        stream: drugs,
        builder: (context, stream) {
          if (!stream.hasData) return LinearProgressIndicator();

          return _buildList(context, drugs);
        });
  }

  Widget _buildList(BuildContext context, Stream<QuerySnapshot> drugs) {
    //final drugs = Provider.of<List<Drug>>(context) ?? [];

    return Column(
      children: [
        _countDropDown(context, totalNum),
        Expanded(
            child:
          ListView.builder(
            itemCount: drugs.length,
            itemBuilder: (context, index){
              return DrugTile(drug: drugs[index], index: (index+1));
            },
          ),

//        ListView(
//          padding: EdgeInsets.all(5.0),
//          children: drugs.map((data) => DrugTile(drug: data)).toList(),
//        )
        ),
      ],
    );
  }

  Widget _countDropDown(context, num) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 19, top: 1),
              child: Row(
                children: <Widget>[
                  Text('총 ${totalNum} 개 약'), // theme 추가
                ],
              ),
            ),
            SizedBox(width: 220),
            DropdownButton<String>(
              value: _filterOrSort,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
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
        Divider(
          thickness: 1,
        )
      ],
    );
  }
}
