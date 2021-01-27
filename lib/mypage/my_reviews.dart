import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("리뷰",  style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        // elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StreamBuilder<List<Review>>(
              stream: ReviewService().getUserReviews(user.uid.toString()),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Review> reviews = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _review(context, reviews[index]);
                      });

                }
                else return Loading();
              },
            ),
          )
        ],
      )
    );
  }


  Widget _review(BuildContext context,  review) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.6, color: Colors.grey[300]),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30, width: 60,
                child: DrugImage(drugItemSeq: review.seqNum),
              ),
              Container(height: 10,),
              Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.grey,
                    size: 18,),
                  Container(width: 5,),
                  //TODO: 좋아요 개수
                  Text(review.noFavorite.toString())
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(review.entpName)
            ],
          )
        ],
      ),
    );



    //   Text(
    //   review.effectText.toString(),
    // );
  }


}
