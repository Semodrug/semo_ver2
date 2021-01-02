import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/models/review.dart';
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
    final reviews = Provider.of<List<Review>>(context) ?? [];
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
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
//        children:
//        searchResults.map((data) => _buildListItem(context, data)).toList(),
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


//  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
/*  Widget _buildListItem(BuildContext context, Review review) {
//    final record = Record.fromSnapshot(data);
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(review.favoriteSelected);
    String docID = review.uid;
    //print(docID);

    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.6, color: Colors.grey[300]))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
*//*              _starAndIdAndMore(record, context, auth),
              _review(record),*//*
              //Container(height: size.height * 0.01),
//              _dateAndLike(record),
              Row(
                children: <Widget>[
                  //Container(height: size.height * 0.05),
                  Text("2020.08.11",
                      style: TextStyle(color: Colors.grey[500], fontSize: 13)),
//        Container(width: size.width * 0.63),
                  Padding(padding: EdgeInsets.all(18)),
                  Padding(padding: EdgeInsets.only(left: 235)),
                  Container(
                    //width: 500.0,
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
                            //when 2 people click this
                            onTap:() {
//                                            List<String> names = List.from(data["favoriteSelected"]);
                              if(names.contains(auth.currentUser.uid)) {
                                print("UID: "+auth.currentUser.uid);
                                review.reference.update({
                                  'favoriteSelected': FieldValue.arrayRemove([auth.currentUser.uid]),
                                  'noFavorite': FieldValue.increment(-1),
                                });
                              }
                              else {
                                record.reference.update({
                                  'favoriteSelected': FieldValue.arrayUnion([auth.currentUser.uid]),
                                  'noFavorite': FieldValue.increment(1),
                                });
                              }
                            }
                        )
                      ],
                    ),
                  ),
                  Text((record.noFavorite).toString(),
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              )
            ]));
  }*/


}
