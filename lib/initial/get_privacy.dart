import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/initial/get_health.dart';

// var phoneMaskFormatter = new MaskTextInputFormatter(
//     mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});
// var birthMaskFormatter = new MaskTextInputFormatter(
//     mask: '####.##.##', filter: {"#": RegExp(r'[0-9]')});
var birthYearMaskFormatter =
    new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});
bool _isGenderFilled = false;
bool _isBirthYearFilled = false;
bool _isNicknameFilled = false;
//print(maskFormatter.getMaskedText()); // -> "+0 (123) 456-78-90"
//print(maskFormatter.getUnmaskedText()); // -> 01234567890

class GetPrivacyPage extends StatefulWidget {
  final String title = '회원가입';

  @override
  _GetPrivacyPageState createState() => _GetPrivacyPageState();
}

class _GetPrivacyPageState extends State<GetPrivacyPage> {
  List<bool> isSelected = List.generate(2, (_) => false);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController birthYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.teal[200],
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Color(0xFFE9FFFB),
                  Color(0xFFE9FFFB),
                  Color(0xFFFFFFFF),
                ])),
          ),
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      topTitle(),
                      SizedBox(
                        height: 40,
                      ),
                      gender(),
                      SizedBox(
                        height: 20.0,
                      ),
                      birthYear(),
                      SizedBox(
                        height: 20.0,
                      ),
                      nickname(user),
                      SizedBox(height: 50.0),
                      submit(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget topTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '개인 정보 설정',
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          '서비스 이용을 도와드려요.',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12.0,
              fontWeight: FontWeight.w200),
        ),
      ],
    );
  }

  Widget gender() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: TextStyle(color: Colors.grey, fontSize: 16.0)),
        SizedBox(
          width: 20,
        ),
        ToggleButtons(
          constraints: BoxConstraints(
            minWidth: 40,
            minHeight: 20,
          ),
          children: [Text('남'), Text('여')],
          selectedColor: Colors.teal[400],
          fillColor: Colors.teal[100],
          onPressed: (int index) {
            setState(() {
              _isGenderFilled = true;

              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }

  Widget birthYear() {
    return TextFormField(
      controller: birthYearController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          hintText: '출생년도',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
      keyboardType: TextInputType.number,
      inputFormatters: [birthYearMaskFormatter],
      onChanged: (value) {
        if (value.length >= 4) {
          setState(() {
            _isBirthYearFilled = true;
          });
        } else {
          setState(() {
            _isBirthYearFilled = false;
          });
        }
      },
      validator: (String value) {
        if (value.isEmpty) return "생년월일을 입력하세요.";
        return null;
      },
    );
  }

  Widget nickname(user) {
    return TextFormField(
      controller: nicknameController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        hintText: '닉네임 (2자 이상)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
        // suffixIcon: _checkButton('중복확인')
        //    OutlineButton(
        //   color: _isFilled ? Colors.teal : Colors.grey,
        //   child: Text(
        //     "중복확인",
        //     style: TextStyle(color: _isFilled ? Colors.teal : Colors.grey),
        //   ),
        //   onPressed: () async {
        //     bool result =
        //         await DatabaseService().isUnique(nicknameController.text);
        //
        //     setState(() {
        //       if (result == true) _isError = true;
        //     });
        //   },
        // )

        //     TextButton(
        //   child: Text(
        //     "중복확인",
        //     style: TextStyle(color: _isFilled ? Colors.teal : Colors.grey),
        //   ),
        //   onPressed: () {},
        // )
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (value.length >= 2) {
          setState(() {
            _isNicknameFilled = true;
          });
        } else {
          setState(() {
            _isNicknameFilled = false;
          });
        }
      },
      validator: (String value) {
        if (value.isEmpty) return "닉네임을 입력하세요.";
        return null;
      },
    );
  }

  Widget submit(context) {
    TheUser user = Provider.of<TheUser>(context);

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: Text(
            '다음',
            style: TextStyle(color: Colors.white),
          ),
          color: (_isGenderFilled && _isBirthYearFilled && _isNicknameFilled)
              ? Colors.teal[400]
              : Colors.grey,
          onPressed: () async {
            if (_isGenderFilled && _isBirthYearFilled && _isNicknameFilled) {
              // phoneMaskFormatter.getUnmaskedText().length != 11 ||
              if (birthYearMaskFormatter.getUnmaskedText().length != 4)
                showSnackBar(context);
              else {
                var result =
                    await DatabaseService().isUnique(nicknameController.text);
                if (result == false) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('이미 존재하는 닉네임입니다')));
                } else {
                  await DatabaseService(uid: user.uid).updateUserPrivacy(
                    isSelected[0] ? 'male' : 'female',
                    birthYearController.text,
                    nicknameController.text,
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GetHealthPage()));
                }
              }
            }
          },
        ),
      ),
    );
  }

  // Widget _checkButton(str) {
  //   return Container(
  //     width: 24 + str.length.toDouble() * 10,
  //     padding: EdgeInsets.symmetric(horizontal: 2),
  //     child: ButtonTheme(
  //       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
  //       minWidth: 10,
  //       height: 22,
  //       child: FlatButton(
  //         child: Text(
  //           '#$str',
  //           style: TextStyle(color: Colors.teal[400], fontSize: 12.0),
  //         ),
  //         //padding: EdgeInsets.all(0),
  //         onPressed: () => print('$str!'),
  //         color: Colors.grey[200],
  //       ),
  //     ),
  //   );
  // }

  Widget _checkButton(str) {
    return ButtonTheme(
      minWidth: 40.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
                color: _isNicknameFilled ? Colors.teal[200] : Colors.grey)),
        color: Colors.white,
        textColor: _isNicknameFilled ? Colors.teal[200] : Colors.grey,
        onPressed: () async {
          var result =
              await DatabaseService().isUnique(nicknameController.text);
          if (result == false) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('이미 존재하는 닉네임입니다')));
          } else {}
        },
        child: Text(
          str,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('입력하신 항목을 다시 확인해주세요', textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.teal[100],
  ));
}