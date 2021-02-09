import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/review_list.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/review_pill_info.dart';
import 'package:semo_ver2/theme/colors.dart';

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
      appBar: CustomAppBarWithGoToBack("리뷰", Icon(Icons.arrow_back), 3),
        backgroundColor: gray0_white,
      body: StreamBuilder<List<Review>>(
        stream: ReviewService().findUserReview(widget.drugItemSeq, user.uid),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Review> reviews = snapshot.data;
            // return Text(review[0].effectText);
            return Column(
              children: [
                ReviewPillInfo(reviews[0]),
                ReviewList("", "none", widget.drugItemSeq),
              ],
            );
          }
          else {
              print("FAIL");
            return Container();
          }
        }
      )
    );
  }


//   Widget _pillInfo(review) {
//     //TODO: Bring pill information
//     return Container(
//         padding: EdgeInsets.fromLTRB(20,30,20,15),
//         decoration: BoxDecoration(
//             border: Border(
//                 bottom:
//                 BorderSide(width: 12, color: gray50, ))),
//         child: Row(
//           children: <Widget>[
// //            Container(
// //              width: 100, height: 100,
// //              color: Colors.teal[100],
// //            ),
//             SizedBox(
//               child: DrugImage(drugItemSeq: review.seqNum),
//               width: 100.0,
//               height: 100.0,
//             ),
//             Padding(padding: EdgeInsets.only(left: 15)),
//
//             // Text(widget.review.effectText),
//
//
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 StreamBuilder<Drug>(
//                     stream: DatabaseService(itemSeq: widget.review.seqNum).drugData,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         Drug drug = snapshot.data;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(drug.entpName,
//                                 style: Theme.of(context).textTheme.overline.copyWith(
//                                     color: gray300_inactivated, fontSize: 10)),
//                             Container(
//                               width: MediaQuery.of(context).size.width-155,
//                               padding: new EdgeInsets.only(right: 10.0),
//                               child: Text(_shortenName(drug.itemName),
//                                   overflow: TextOverflow.ellipsis,
//                                   style: Theme.of(context).textTheme.headline6.copyWith(
//                                       color: gray900)
//                               ),
//                             ),
//                             Container(height: 2,),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 RatingBar.builder(
//                                   itemSize: 16,
//                                   initialRating: drug.totalRating ,
//                                   minRating: 0,
//                                   direction: Axis.horizontal,
//                                   allowHalfRating: true,
//                                   itemCount: 5,
//                                   unratedColor: gray75,
//                                   itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                                   itemBuilder: (context, _) => ImageIcon(
//                                     AssetImage('assets/icons/star.png'),
//                                     color: yellow,
//                                   ),
//                                 ),
//                                 Container(width:5),
//                                 Text(drug.totalRating.toStringAsFixed(2),
//                                   style: Theme.of(context).textTheme.subtitle2.copyWith(
//                                       color: gray900, fontSize: 12),),
//                                 Container(width:3),
//                                 Text("("+drug.numOfReviews.toStringAsFixed(0)+"개)",
//                                     style: Theme.of(context).textTheme.overline.copyWith(
//                                         color: gray300_inactivated, fontSize: 10)),
//                               ],
//                             ),
//                             CategoryButton(str: drug.category)
//                           ],
//                         );
//                         // Text(drug.totalRating.toStringAsFixed(2)+drug.numOfReviews.toStringAsFixed(0) + "개",
//                         //   style: TextStyle(
//                         //     fontSize: 16.5,
//                         //     fontWeight: FontWeight.bold,
//                         //   ));
//                       } else
//                         return Container();
//                     }),
//               ],
//             )
//           ],
//         )
//     );
//   }

}
