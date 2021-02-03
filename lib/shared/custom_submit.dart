import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final BuildContext context;
  final String textString;
  final Function onPressed;

  const CustomButton({
    Key key,
    this.context,
    @required this.textString,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 44.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: primary400_line,
          width: 1,
        ),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              gradient_button_long_start,
              gradient_button_long_end,
            ]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                textString,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray0_white),
              ),
            )),
      ),
    );
  }
}
