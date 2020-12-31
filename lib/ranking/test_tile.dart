import 'package:semo_ver2/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/review/phil_info.dart';


class DrugTile extends StatelessWidget {

  final Drug drug;
  final int index;

  DrugTile({this.drug, this.index});


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () =>
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhilInfoPage(drug_item_seq: drug.item_seq),
              ),
            ),
            print('===> pushed'),
            print(drug.item_seq),

            print(' 리뷰 개수 잘 받아오느닞 확인 ${drug.review.toString()} ')
          },
          child: Container(
            width: double.infinity,
            height: 100.0,
            child: Material(
                color: Colors.white,
                child: Row(
                  children: [
                   SizedBox(
                      width: 40,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        //padding: EdgeInsets.only(left: 0, right: 5),
                          child: Text(' ${index.toString()}위', style: TextStyle(fontSize: 12),)),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: AspectRatio(
                          aspectRatio: 2/2,
                            child: Image.network(drug.image,)),),
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drug.entp_name,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                            Expanded(
                              child: Row(children: [
                                Text(
                                  drug.item_name,
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                )
                              ]),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '별 아이콘',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                  ),
                                  Text(
                                    '별점 4.5',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                  ),
                                  Text(
                                    '( ${drug.review} 개)',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Expanded(
                                child: Row(
                                  children: [
                                    _categoryButton((drug.category))
                                  ],
                                )),
                          ],
                        )),
                  ],
                )),
          ),
        )
    );
  }
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
          style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
        ),
        onPressed: () => print('$str!'),
        color: Colors.white,
      ),
    ),
  );
}







