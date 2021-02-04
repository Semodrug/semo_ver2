import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
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

  SearchResultTile({this.drug});

  //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
  String _checkLongName(String data) {
    String newName = data;
    List splitName = [];
    if (data.contains('(')) {
      newName = data.replaceAll('(', '(');
      if (newName.contains('')) {
        splitName = newName.split('(');
        // print(splitName);
        newName = splitName[0];
      }
    }
    return newName;
  }

  @override
  Widget build(BuildContext context) {
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
      child:StreamBuilder<Drug>(
          stream: DatabaseService(itemSeq: drug.itemSeq).drugData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Drug drugStreamData = snapshot.data;
              String drugRating = drugStreamData.totalRating.toStringAsFixed(2);
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.6, color: gray50))),
                height: 70.0,
                child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 5, 5, 5),
                          child: AspectRatio(
                            aspectRatio: 1.5 / 1.5,
                            // TODO: show storage image - if null, defalut image
                            child: Container(
                                padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                                child: SizedBox(
                                    child: DrugImage(drugItemSeq: drugStreamData.itemSeq))),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width - 170,
                                  child: Text(
                                      _checkLongName(drugStreamData.itemName),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.headline6.copyWith(color: gray900)

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:3.0),
                                  child: SizedBox(
                                    height: 25,
                                      child: CategoryButton(str: drugStreamData.category)),
                                ),
                              ],
                            )),
                      ],
                    )),
              );
            }
            else return Container();//LinearProgressIndicator();
          }
      ),
    );
  }

}
