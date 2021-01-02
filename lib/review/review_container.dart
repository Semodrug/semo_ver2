import 'package:semo_ver2/models/review.dart';
import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {

  final Review review;
  ReviewContainer({ this.review });

  @override
  Widget build(BuildContext context) {
    return
      Card(
//        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(review.effect),
          subtitle: Text('Takes ${review.effect} sugar(s)'),
        ),
      );
  }
}