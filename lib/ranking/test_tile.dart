import 'package:semo_ver2/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/drug_info/phil_info.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/image.dart';

class DrugTile extends StatelessWidget {
  final Drug drug;
  final int index;

  DrugTile({this.drug, this.index});

  @override
  Widget build(BuildContext context) {
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

    //리뷰 개수를 받아오기 위한 스트림
//    return StreamBuilder <List<Review>>(
//        stream: ReviewService().getReviews(drug.itemSeq),
//        builder: (context, snapshot) {
//          List<Review> reviews = snapshot.data;
//          int length = 0 ;
//          num sum = 0;
//          num ratingResult = 0;
//
//          if(snapshot.hasData){
//            length = reviews.length;
//
//            reviews.forEach((review) {
//              sum += review.starRating;
//            });
//
//            ratingResult = sum / length;
//
//          }
//
//        });
    //이부분은 그냥 놔두고 Drug DB 수정 되면 그 때 맞춰서 보여주기!!
    return StreamBuilder(
        stream: ReviewService().getReviews(drug.itemSeq),
        builder: (context, snapshot) {
          List<Review> reviews = snapshot.data;
          int len = 0;
          num sum = 0;
          double ratingResult = 0;

          if (snapshot.hasData) {
            len = reviews.length;

            reviews.forEach((review) {
              sum += review.starRating;
            });
            ratingResult = sum / len;
            print('rating Result ==> $ratingResult');

            return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhilInfoPage(drugItemSeq: drug.itemSeq),
                      ),
                    ),
                    print('===> pushed'),
                    print(drug.itemSeq),
                    // TODO: 리뷰개수
                    // print(' 리뷰 개수 잘 받아오는 확인 ${drug.review.toString()} ')
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
                                  child: Text(
                                    ' ${index.toString()}위',
                                    style: TextStyle(fontSize: 12),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: AspectRatio(
                                aspectRatio: 2 / 2,
                                // TODO: show storage image - if null, defalut image
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: SizedBox(
                                        width: 88,
                                        height: 66,
                                        child: DrugImage(
                                            drugItemSeq: drug.itemSeq))),
                                // Image.network(
                                //   drug.image,
                                // )
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drug.entpName,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Row(children: [
                                        Text(
                                          _checkLongName(drug.itemName),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            '별 아이콘',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
                                          ),
                                          Text(
                                            '별점 $ratingResult',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13),
                                          ),
                                          Text(
                                            '( $len 개)',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 10),
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
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });

    /*
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage(drug.itemSeq),
              ),
            ),
            print('===> pushed'),
            print(drug.itemSeq),
            // TODO: 리뷰개수
            // print(' 리뷰 개수 잘 받아오는 확인 ${drug.review.toString()} ')
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
                          child: Text(
                            ' ${index.toString()}위',
                            style: TextStyle(fontSize: 12),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: AspectRatio(
                        aspectRatio: 2 / 2,
                        // TODO: show storage image - if null, defalut image
                        child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: SizedBox(
                                width: 88, height: 66, child: DrugImage(drugItemSeq:drug.itemSeq))),
                        // Image.network(
                        //   drug.image,
                        // )
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drug.entpName,
                              style:
                              TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            Expanded(
                              child: Row(children: [
                                Text(
                                  _checkLongName(drug.itemName),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
                                    '( 4 개)',
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
                                  children: [_categoryButton((drug.category))],
                                )),
                          ],
                        )),
                  ],
                )),
          ),
        ));
    */
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
}

/*App theme*/
/*MDC 103 theme 적용하는 거
MDC 104는 custom 하는 작업임
style 에 있는 애들이 다 달라가고
app theme에 있는 이름으로 불러올 수 있게끔 해둠

* */
