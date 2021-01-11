import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/login/register2_name.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/review/report_review.dart';
import 'package:semo_ver2/services/review.dart';
import 'edit_review.dart';
import 'review_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  String searchText;
  ReviewList(this.searchText);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    final reviews = Provider.of<List<Review>>(context, listen: true) ?? [];
    List<Review> searchResults = [];
    for (Review review in reviews) {
      if (review.toString().contains(widget.searchText)) {
        searchResults.add(review);
      } else
        print('    RESULT Nothing     ');
    }
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        children:
            searchResults.map((data) => _buildListItem(context, data)).toList(),
//       return ReviewContainer(review: reviews[index]);
      ),
    );

//    return ListView.builder(
//      itemCount: reviews.length,
//      itemBuilder: (context, index) {
//        return ReviewContainer(review: reviews[index]);
//      },
//    );
  }

/*
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    List<DocumentSnapshot> searchResults = [];
//    for (DocumentSnapshot d in snapshot) {
//      if (d.data().toString().contains(_searchText)) {
//        searchResults.add(d);
//      } else
//        print('    RESULT Nothing     ');
//    }
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        children:
        searchResults.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }
*/

  Widget _buildListItem(BuildContext context, Review review) {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(review.favoriteSelected);
    String year = review.registrationDate.toDate().year.toString();
    String month = review.registrationDate.toDate().month.toString();
    if(month.length == 1) month = '0'+ month;
    String day = review.registrationDate.toDate().day.toString();
    if(day.length == 1) day = '0'+ day;
    String regDate =  year + "." + month + "." + day;
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.6, color: Colors.grey[300]))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _starAndIdAndMore(review, context, auth),
          _review(review),
          //Container(height: size.height * 0.01),
//              _dateAndLike(record),

          
        
              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Container(height: size.height * 0.05),
                  //TODO: DATE!!!!!!!
                  Text(regDate,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  Padding(padding: EdgeInsets.all(18)),
                  Expanded(child: Container( )),
                  Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new GestureDetector(
                            child: new Icon(
                              names.contains(auth.currentUser.uid) ? Icons.favorite
                                  : Icons.favorite_border,
//                                            color: names.contains(auth.currentUser.uid) ?
//                                                Colors.redAccent[200] : Colors.grey[300],
                              color: Colors.redAccent[200],
                              size: 21,
                            ),
                            onTap:() async{
                              if(names.contains(auth.currentUser.uid)) {
                                await ReviewService(documentId: review.documentId).decreaseFavorite(review.documentId, auth.currentUser.uid);
                              }
                              else {
                                await ReviewService(documentId: review.documentId).increaseFavorite(review.documentId, auth.currentUser.uid);
                              }
                            }
                        )
                      ],
                    ),
                  ),
                  Text((review.noFavorite).toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  SizedBox(width: 15)
                ],
              )
            ]));
  }

//  Widget _starAndIdAndMore(record, context, auth) {
  Widget _starAndIdAndMore(review, context, auth) {
    return Row(
      children: <Widget>[

        RatingBar.builder(
          initialRating: review.starRating*1.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 14,
          glow: false,
          itemPadding: EdgeInsets.symmetric(horizontal: 0),
          unratedColor: Colors.grey[300],
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amberAccent,
          ),
        ),
        SizedBox(width: 10),
        Text(review.id, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
//            SizedBox(width: 145),
        Expanded(child: Container()),
        IconButton(
          icon: Icon(Icons.more_horiz, color: Colors.grey[700], size: 19),
          onPressed: () {
            if(auth.currentUser.uid == review.uid) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                        child: Container(
                            child: Wrap(
                              children: <Widget>[
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                        //TODO
                                          builder: (context) => EditReview(review)
                                      ));
                                    },
                                    child: Center(child: Text("수정하기",
                                        style: TextStyle(color: Colors.blue[700],
                                            fontSize: 16)))
                                ),
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showDeleteDialog(review);
                                    },
                                    child: Center(child: Text("삭제하기",
                                        style: TextStyle(color: Colors.red[600],
                                            fontSize: 16)))
                                ),
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Center(child: Text("취소",
                                        style: TextStyle(color: Colors.grey[600],
                                            fontSize: 16)))
                                )
                              ],
                            )
                        )
                    );
                  });
            }
            else if(auth.currentUser.uid != review.uid) {
              showModalBottomSheet(
                  context: context,
                  builder: buildBottomSheetAnonymous);
            }
          },
        )
      ],
    );
  }

  Future<void> _showDeleteDialog(record) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Center(child: Text('AlertDialog Title')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text('정말 삭제하시겠습니까?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('삭제',
                          style: TextStyle(
                              color: Colors.teal[00],
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await ReviewService(documentId: record.documentId)
                            .deleteReviewData();
//                        record.reference.delete();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

//  Widget buildBottomSheetWriter(BuildContext context, record) {
//    return SizedBox(
//        child: Container(
////                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//          child: Wrap(
//            children: <Widget>[
//              MaterialButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Center(child: Text("수정하기",
//                    style: TextStyle(color: Colors.blue[700],
//                    fontSize: 16)))
//              ),
//              MaterialButton(
//                  onPressed: () {
//                    _showDeleteDialog(record);
//                  },
//                  child: Center(child: Text("취소",
//                      style: TextStyle(color: Colors.red[600],
//                      fontSize: 16)))
//              ),
//            ],
//          )
//        )
//    );
//  }

  Widget buildBottomSheetAnonymous(BuildContext context) {
    return SizedBox(
        child: Container(
//                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(

              children: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(
                        //TODO
                          builder: (context) => ReportReview()
//                                              builder: (context) => EditReview(review)
                      ));
            },
            child: Center(
                child: Text("신고하기",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16)))),
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Center(
                child: Text("취소",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16)))),
      ],
    )));
  }

  Widget _review(review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //effect
        Row(
          children: <Widget>[
            Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("효과",
                        style:
                            TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                    Padding(padding: EdgeInsets.all(2.5)),
                    //Container(width: size.width * 0.015),
                    Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                            //TODO: COlor: Based on effect color
                            color: review.effect == "soso"
                                ? Color(0xffFFDD66)
                                : review.effect == "bad"
                                    ? Color(0xffFF7070)
                                    : Color(0xff88F0BE),
                            shape: BoxShape.circle)),
                  ],
                )),
            //Container(width: size.width * 0.025),
            Padding(padding: EdgeInsets.all(5)),
            Text(review.effectText, style: TextStyle(fontSize: 17.0)),
          ],
        ),

        SizedBox(height: 13),

        //side effect
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 28,
                width: 80,
                //width: 5, height: 5,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("부작용",
                        style:
                            TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                    Padding(padding: EdgeInsets.all(2.5)),
                    Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                            color: review.sideEffect == "yes"
                                ? Color(0xffFF7070)
                                : Color(0xff88F0BE),
//                            color: Colors.redAccent[100],
                            shape: BoxShape.circle)),
                  ],
                )),
            Padding(padding: EdgeInsets.all(5)),
            Text(review.sideEffectText, style: TextStyle(fontSize: 17.0)),
          ],
        ),

        SizedBox(height: 13),
        Row(
          children: <Widget>[
            Container(
                height: 25,
                width: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400], width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("총평",
                        style:
                            TextStyle(fontSize: 14.5, color: Colors.grey[600])),
                  ],
                )),
            Padding(padding: EdgeInsets.all(5)),
            Text(review.overallText, style: TextStyle(fontSize: 17.0)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 6.0)),
      ],
    );
  }
}
