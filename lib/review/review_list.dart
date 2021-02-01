import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/report_review.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'edit_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  String searchText;
  String filter;
  ReviewList(this.searchText, this.filter);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {

  @override
  Widget build(BuildContext context) {
    //TODO LIMIT!!
    final reviews = Provider.of<List<Review>>(context) ?? [];
    List<Review> searchResults = [];
    for (Review review in reviews) {
      if (review.effectText.toString().contains(widget.searchText) ||
          review.sideEffectText.toString().contains(widget.searchText) ||
          review.overallText.toString().contains(widget.searchText)
      ) {
        searchResults.add(review);
      } else
        print('    RESULT Nothing     ');
    }
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
        return _buildListItem(context, searchResults[index]);
    },
//      children: searchResults.map((data) => _buildListItem(context, data)).toList(),
    );



//    return ListView.builder(
//      itemCount: reviews.length,
//      itemBuilder: (context, index) {
//        return ReviewContainer(review: reviews[index]);
//      },
//    );
  }

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
      padding: EdgeInsets.fromLTRB(0,10,0,21.5),
        //padding: EdgeInsets.fromLTRB(20,10,20,21.5),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.6, color: gray75))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _starAndIdAndMore(review, context, auth),
              _review(review),
              Container(height: 11.5),
              _dateAndFavorite(regDate, names, auth, review)

            ]));
  }

  Widget _starAndIdAndMore(review, context, auth) {
    TheUser user = Provider.of<TheUser>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20,0,5,0),
      child: Row(
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
          Text(review.nickName,
              style: Theme.of(context).textTheme.caption.copyWith(
                color: gray500,
                fontSize: 12
              )
          ),
          Expanded(child: Container()),
          IconButton(
           padding: EdgeInsets.only(right:0),
           // constraints: BoxConstraints(),
            icon: Icon(Icons.more_horiz, color: gray500, size: 19),
            onPressed: () {
//            if(auth.currentUser.uid == review.uid) {
              if(user.uid == review.uid) {
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
                                            builder: (context) => EditReview(review, "edit")
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
      ),
    );
  }

  Widget _reviewBox(review, type) {
    return Container(
      padding: EdgeInsets.all(9.5),
      decoration: BoxDecoration(
        color: gray50,
        border: Border.all(color: gray50),
        borderRadius: BorderRadius.all(Radius.circular(4.0))),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                type == "effect" ? "효과" : type == "sideEffect" ? "부작용" : "총평",
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: gray900
                ),),
              Container(width:3),
              _face(type == "effect" ? review.effect : type == "sideEffect" ? review.sideEffect : "overall",),
            ],
          ),
          Container(height:4),
          Text(type == "effect" ? review.effectText : type == "sideEffect" ? review.sideEffectText : review.overallText,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: gray600,
              fontSize: 14
            ),),
        ],
      )
    );
  }

  Widget _face(face) {
    if(face == "good" || face == "no")
      return Icon(
        Icons.sentiment_satisfied,
        color: warning,
        size: 16,
      );
    if(face == "soso")
      return Icon(
        Icons.sentiment_neutral,
        color: yellow_line,
        size: 16,
      );
    if(face == "bad" || face == "yes")
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: primary300_main,
        size: 16,
      );
    if(face == "overall")
      return Container();
  }

  Widget _review(review) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,0,20,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //effect
          widget.filter == "sideEffectOnly" ? Container()
           : _reviewBox(review, "effect"),
          Container(height:4),


          //side effect
          widget.filter == "effectOnly" ? Container()
           : _reviewBox(review, "sideEffect"),
          Container(height:4),

          //overall
          widget.filter == "sideEffectOnly" || widget.filter == "effectOnly" ? Container()
            : _reviewBox(review, "overall"),
          Container(height:4),
        ],
      ),
    );
  }

  Widget _dateAndFavorite(regDate, names, auth, review) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,0,5,0),
      child: Row(
        children: <Widget>[
          Text(regDate,
          style: Theme.of(context).textTheme.caption.copyWith(
              color: gray500,
              fontSize: 12
          )),
//        Padding(padding: EdgeInsets.all(18)),
          Expanded(child: Container( )),
          Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                    child: new Icon(
                      names.contains(auth.currentUser.uid) ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt,
                      color: names.contains(auth.currentUser.uid) ? primary400_line : Color(0xffDADADA),
                      size: 20,
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
          Container(width:3),
          Text((review.noFavorite).toString(),
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: gray400,
                  fontSize: 12
              )),
          SizedBox(width: 15)
        ],
      ),
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
                Center(child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('삭제',style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await ReviewService(documentId: record.documentId).deleteReviewData();
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
                    child: Center(child: Text("신고하기",
                        style: TextStyle(color: Colors.blue[700],
                            fontSize: 16)))
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(child: Text("취소",
                        style: TextStyle(color: Colors.blue[700],
                            fontSize: 16)))
                ),
              ],
            )
        )
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

/*  final _reviewSnapshot = <DocumentSnpashot>[];


  Future fecthNextRevies() async {
    String _errorMessage = '';

    try {
      final snap = await ReviewService.newgetReviews();
      _
    }
  }*/


//  Future fetchNextUsers() async {
//    if (_isFetchingUsers) return;
//
//    _errorMessage = '';
//    _isFetchingUsers = true;
//
//    try {
//      final snap = await FirebaseApi.getUsers(
//        documentLimit,
//        startAfter: _usersSnapshot.isNotEmpty ? _usersSnapshot.last : null,
//      );
//      _usersSnapshot.addAll(snap.docs);
//
//      if (snap.docs.length < documentLimit) _hasNext = false;
//      notifyListeners();
//    } catch (error) {
//      _errorMessage = error.toString();
//      notifyListeners();
//    }
//
//    _isFetchingUsers = false;
//  }

}
