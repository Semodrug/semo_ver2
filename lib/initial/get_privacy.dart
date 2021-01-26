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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<bool> _isSelected = List.generate(2, (_) => false);
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _birthYearController = TextEditingController();

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
                      nickname(),
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
      children: [
        Text('성별', style: TextStyle(color: Colors.grey, fontSize: 16.0)),
        SizedBox(
          width: 20,
        ),
        exclusiveButton(0, _isSelected, '남'),
        SizedBox(width: 10),
        exclusiveButton(1, _isSelected, '여'),
        // ToggleButtons(
        //   constraints: BoxConstraints(
        //     minWidth: 40,
        //     minHeight: 20,
        //   ),
        //   children: [Text('남'), Text('여')],
        //   selectedColor: Colors.teal[400],
        //   fillColor: Colors.teal[100],
        //   onPressed: (int index) {
        //     setState(() {
        //       _isGenderFilled = true;
        //
        //       for (int buttonIndex = 0;
        //           buttonIndex < _isSelected.length;
        //           buttonIndex++) {
        //         if (buttonIndex == index) {
        //           _isSelected[buttonIndex] = true;
        //         } else {
        //           _isSelected[buttonIndex] = false;
        //         }
        //       }
        //     });
        //   },
        //   isSelected: _isSelected,
        // ),
      ],
    );
  }

  Widget birthYear() {
    return TextFormField(
      controller: _birthYearController,
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

  Widget nickname() {
    return TextFormField(
      controller: _nicknameController,
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
                    await DatabaseService().isUnique(_nicknameController.text);
                if (result == false) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('이미 존재하는 닉네임입니다')));
                } else {
                  await DatabaseService(uid: user.uid).updateUserPrivacy(
                    _isSelected[0] ? 'male' : 'female',
                    _birthYearController.text,
                    _nicknameController.text,
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

  Widget exclusiveButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 70.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
                color: isPressed[index] ? Colors.teal[200] : Colors.grey)),
        color: Colors.white,
        textColor: isPressed[index] ? Colors.teal[200] : Colors.grey,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        onPressed: () {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < isPressed.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isPressed[buttonIndex] = true;
              } else {
                isPressed[buttonIndex] = false;
              }
            }
          });
        },
        child: Text(
          buttonName,
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
