import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/services/review_service.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/review/review_pill_info.dart';
import 'package:semo_ver2/theme/colors.dart';

class SeeMyReview extends StatefulWidget {
  final String drugItemSeq;

  SeeMyReview(
    this.drugItemSeq,
  );

  @override
  _SeeMyReviewState createState() => _SeeMyReviewState();
}

class _SeeMyReviewState extends State<SeeMyReview> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack("약사의 한마디", Icon(Icons.arrow_back), 0.5),
        backgroundColor: gray0_white,
        body: StreamBuilder<List<Review>>(
            stream:
                ReviewService().findUserReview(widget.drugItemSeq, user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Review> reviews = snapshot.data;
                // return Text(review[0].effectText);
                return ListView(
                  children: [
                    ReviewPillInfo(widget.drugItemSeq),
                    reviews.length == 0
                        ? Container()
                        : ReviewList("", "none", widget.drugItemSeq,
                            type: "mine", review: reviews[0]),
                  ],
                );
              } else {
                print("FAIL");
                return Container();
              }
            }));
  }
}
