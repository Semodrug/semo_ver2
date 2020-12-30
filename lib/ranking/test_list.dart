import 'package:flutter/material.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:provider/provider.dart';
import 'test_tile.dart';

class DrugList extends StatefulWidget {
  @override
  _DrugListState createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  @override
  Widget build(BuildContext context) {
    String _filterOrSort = "높은 평점 순";
    final drugs = Provider.of<List<Drug>>(context) ?? [];

//    switch (_filterOrSort) {
//      case "높은 평점 순":
//        drugs = drugs.orderBy('name', descending: false);
//        break;
//
//      case "이름순":
//        drugs = drugs.orderBy('group', descending: false);
//        break;
//    }


    return ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index){
          return DrugTile(drug: drugs[index], index: (index+1));
        },
    );

    /*
    return ListView(
      padding: EdgeInsets.all(5.0),
      children: drugs.map((data) => DrugTile(drug: data)).toList(),
    );
    */
  }
}
