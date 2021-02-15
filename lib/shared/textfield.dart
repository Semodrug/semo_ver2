import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

class ReviewTextField extends StatelessWidget {

  String type;
  TextEditingController txtController;

   ReviewTextField({
    Key key,
    @required this.type,
    @required this.txtController,
  }) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    String hintText;
    if (type == "effect")
      hintText = "효과에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if (type == "sideEffect")
      hintText = "부작용에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if (type == "overall")
      hintText = "전체적인 만족도에 대한 후기를 남겨주세요(선택)\n";
    else if(type == "reason")
      hintText = "키워드 하나를 입력해주세요  예시)치통\n";

    // final bottom = MediaQuery.of(context).viewInsets.bottom;
    double bottom = 20;

    return Padding(
      padding: EdgeInsets.fromLTRB(0,20,0,bottom),

      child: Container(
          child: TextField(
              maxLength: 500,
              controller: txtController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: gray300_inactivated,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: gray75),
                  borderRadius:
                  const BorderRadius.all(const Radius.circular(4.0)),
                ),
                filled: true,
                fillColor: gray50,
              ))),
    );
  }


}
