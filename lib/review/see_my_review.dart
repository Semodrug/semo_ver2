import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class SeeMyReview extends StatefulWidget {
  final String drugItemSeq;

  SeeMyReview(this.drugItemSeq,);

  @override
  _SeeMyReviewState createState() => _SeeMyReviewState();
}

class _SeeMyReviewState extends State<SeeMyReview> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: CustomAppBarWithGoToBack("MY REVIEW", Icon(Icons.arrow_back), 3),
      body: StreamBuilder<List<Review>>(
        stream: ReviewService().findUserReview(widget.drugItemSeq, user.uid),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Review> review = snapshot.data;
            return Text(review[0].effectText);
            // return IYMYGotoSeeOrCheckDialog();
          }
          else {
              print("FAIL");
            return Container();
          }
        }
      )
    );
  }
}
