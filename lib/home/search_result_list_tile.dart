import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/home/search_screen.dart';
//import 'package:semo_ver2/home/search_screen_UserDrugTest.dart'; //원상태로 복구
import 'package:semo_ver2/models/drug.dart';

import 'package:flutter/material.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/theme/colors.dart';

class SearchResultTile extends StatelessWidget {
  final Drug drug;
  final int index;
  final int totNum;

  SearchResultTile({this.drug, this.index, this.totNum});


  //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
  String _checkLongName(String data) {
    String newItemName = data;
    List splitName = [];
    if (data.contains('(')) {
      newItemName = data.replaceAll('(', '(');
      if (newItemName.contains('')) {
        splitName = newItemName.split('(');
        // print(splitName);
        newItemName = splitName[0];
      }
    }

    if (newItemName.length > 22) {
      newItemName = newItemName.substring(0, 20);
      newItemName = newItemName + '...';
    }

    return newItemName;
  }

  //(2) 하이라이팅을 위한
  Widget _highlightText(BuildContext context, String text) {
    return RichText(textScaleFactor: 1.08, text: searchMatch(text));
  }
  //(2) 여기까지

  @override
  Widget build(BuildContext context) {

    print('index =  $index');
    print('totNum =  $totNum');
    int forCheckLast = 0;
    if(index != null){
      forCheckLast = index + 1;
    }

    double mw = MediaQuery.of(context).size.width;

    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(_checkLongName(drug.itemName) != null);

        searchList = _checkLongName(drug.itemName);
        assert(searchList != null);
        //drug 이름 누르면 저장 기능
        userSearchList.add({
          'searchList': searchList,
          'time': DateTime.now(),
          'itemSeq': drug.itemSeq
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    QuerySnapshot _query;
    return GestureDetector(
      onTap: () async => {
        _query = await userSearchList
            .where('searchList', isEqualTo: _checkLongName(drug.itemName))
            .get(),
        if (_query.docs.length == 0)
          {
            addRecentSearchList(),
          },
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(drug.itemSeq),
            )),
      },
      child: StreamBuilder<Drug>(
          stream: DatabaseService(itemSeq: drug.itemSeq).drugData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Drug drugStreamData = snapshot.data;
              String newName = drugStreamData.category;
              //카테고리 길이 체크
              if (newName.length > 30) {
                newName = newName.substring(0, 27);
                newName = newName + '...';
              }
              return forCheckLast == totNum ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(width: 0.6, color: gray50))),
                    height: 70.0,
                    child: Material(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 5, 15, 5),
                              width: 90,
                              child: Container(
                                  padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                                  child: SizedBox(
                                      child: DrugImage(
                                          drugItemSeq: drugStreamData.itemSeq))),
                            ),
                            Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw > 390 ? mw - 130 : mw - 200,
                                    child:
                                        // Text(
                                        //     _checkLongName(drugStreamData.itemName),
                                        //     maxLines: 1,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: Theme.of(context).textTheme.headline6.copyWith(color: gray900)
                                        //
                                        // ),
                                        _highlightText(
                                            context,
                                            _checkLongName(
                                                drugStreamData.itemName))),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: SizedBox(
                                      height: 25,
                                      child: CategoryButton(
                                        str: newName,
                                        forsearch: true,
                                      )),
                                ),
                              ],
                            )),
                          ],
                        )),
                  ),
                  Container(height: 40)
                ],
              )
              : Container(
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(width: 0.6, color: gray50))),
                height: 70.0,
                child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 5, 15, 5),
                          width: 90,
                          child: Container(
                              padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                              child: SizedBox(
                                  child: DrugImage(
                                      drugItemSeq: drugStreamData.itemSeq))),
                        ),
                        Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw > 390 ? mw - 130 : mw - 200,
                                    child:
                                    // Text(
                                    //     _checkLongName(drugStreamData.itemName),
                                    //     maxLines: 1,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: Theme.of(context).textTheme.headline6.copyWith(color: gray900)
                                    //
                                    // ),
                                    _highlightText(
                                        context,
                                        _checkLongName(
                                            drugStreamData.itemName))),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: SizedBox(
                                      height: 25,
                                      child: CategoryButton(
                                        str: newName,
                                        forsearch: true,
                                      )),
                                ),
                              ],
                            )),
                      ],
                    )),
              );
            } else
              return Container(); //LinearProgressIndicator();
          }),
    );
  }
}
