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
        padding: type == "reason" ? EdgeInsets.all(5): EdgeInsets.all(9.5),
        decoration: BoxDecoration(
            color: type == "reason" ? gray0_white : gray50,
            border: Border.all(color: gray50),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type == "reason" ? " #"+review.reasonForTakingPill : type == "effect" ? "효과" : type == "sideEffect" ? "부작용" : "총평",
                  style: type == "reason" ?
                  Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Color(0xff005841), fontSize: 12
                  ) :
                  Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray900, fontSize: 12
                  ),
                ),
                Container(width:3),
                _face(type == "effect" ? review.effect : type == "sideEffect" ? review.sideEffect : "overall",),
              ],
            ),
            type == "reason" ? Container(): Container(height:4),

            // if(review.reasonForTakingPill!="")


            if(type == "effect")
              Text(review.effectText),
            if(type == "sideEffect" && review.sideEffect == "yes")
              Text(review.sideEffectText),
            if(type == "sideEffect" && review.sideEffect == "no")
              Container(),
            if(type == "overall") Text(review.overallText)

            // Text(
            //   type == "effect" ? review.effectText
            //       : (type == "sideEffect" && review.sideEffect == "no") ?
            //   "" : (type == "sideEffect" && review.sideEffect == "yes") ?
            //   review.sideEffectText : review.overallText,
            //   style: Theme.of(context).textTheme.bodyText2.copyWith(
            //       color: gray600,
            //       fontSize: 14
            //   ),),
          ],
        )
    );


  }

  Widget _face(face) {
    if(face == "good")
      return Row(
        children: [
          Icon(
            Icons.sentiment_satisfied_rounded,
            color: primary300_main,
            size: 16,
          ),
          SizedBox(width:1),
          Text("좋아요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: primary400_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "no")
      return Row(
        children: [
          Icon(
            Icons.sentiment_satisfied_rounded,
            color: primary300_main,
            size: 16,
          ),
          SizedBox(width:1),
          Text("없어요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: primary400_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "soso")
      return Row(
        children: [
          Icon(
            Icons.sentiment_neutral_rounded,
            color: yellow_line,
            size: 16,
          ),
          SizedBox(width:1),
          Text("보통이에요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: yellow_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "bad")
      return Row(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color:  warning,
            size: 16,
          ),
          SizedBox(width:1),
          Text("별로에요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: warning, fontSize: 12
            ),
          )
        ],
      );
    if(face == "yes")
      return Row(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color:  warning,
            size: 16,
          ),
          SizedBox(width:1),
          Text("있어요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: warning, fontSize: 12
            ),
          )
        ],
      );
    if(face == "overall")
      return Container();
  }
}