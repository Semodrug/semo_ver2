import 'package:flutter/material.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/theme/colors.dart';

class ReviewBox extends StatelessWidget {
  final BuildContext context;
  final Review review;
  final String type;

  const ReviewBox({
    Key key,
    // this.context,
    @required this.context,
    @required this.review,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(9.5),
        decoration: BoxDecoration(
            color: gray50,
            border: Border.all(color: gray50),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),


    //     return Padding(
    // padding: EdgeInsets.fromLTRB(20,0,20,0),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type == "effect" ? "효과" : type == "sideEffect" ? "부작용" : "총평",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: gray900, fontSize: 12
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
                      color: gray900, fontSize: 12
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
        Icons.sentiment_satisfied_rounded,
        color: primary300_main,
        size: 16,
      );
    if(face == "soso")
      return Icon(
        Icons.sentiment_neutral_rounded,
        color: yellow_line,
        size: 16,
      );
    if(face == "bad" || face == "yes")
      return Icon(
        Icons.sentiment_very_dissatisfied_rounded,
        color:  warning,
        size: 16,
      );
    if(face == "overall")
      return Container();
  }
}
