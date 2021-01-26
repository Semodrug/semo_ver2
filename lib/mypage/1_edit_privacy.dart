import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/services/db.dart';

var birthYearMaskFormatter =
    new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});
bool _isGenderFilled = true;
bool _isBirthYearFilled = true;
bool _isNicknameFilled = true;

class EditPrivacyPage extends StatefulWidget {
  final String title = '개인 정보 수정';
  final UserData userData;

  const EditPrivacyPage({Key key, this.userData}) : super(key: key);

  @override
  _EditPrivacyPageState createState() => _EditPrivacyPageState();
}

class _EditPrivacyPageState extends State<EditPrivacyPage> {
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<bool> _isSelected;
  TextEditingController _birthYearController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _birthYearController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _isSelected =
        (widget.userData.sex == 'female') ? [false, true] : [true, false];
    _birthYearController.text = widget.userData.birthYear;
    _nicknameController.text = widget.userData.nickname;
  }

  @override
  Widget build(BuildContext context) {
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
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: GestureDetector(
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
                  topTitle(widget.userData),
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
      ),
    );
  }

  Widget topTitle(userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userData.nickname}님',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _auth.userEmail,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
        // TODO: image picker
        IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.teal[200],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget nickname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: _nicknameController,
          cursorColor: Colors.teal[400],
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
            hintText: '닉네임 입력 (2자 이상)',
            hintStyle: TextStyle(color: Colors.grey[300], fontSize: 16.0),
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
        ),
      ],
    );
  }

  Widget birthYear() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '출생년도',
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: _birthYearController,
          cursorColor: Colors.teal[400],
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
              hintText: '출생년도',
              hintStyle: TextStyle(color: Colors.grey[300], fontSize: 16.0)),
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
        ),
      ],
    );
  }

  Widget gender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성별',
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            exclusiveButton(0, _isSelected, '남'),
            SizedBox(width: 10),
            exclusiveButton(1, _isSelected, '여'),
          ],
        ),
      ],
    );
  }

  Widget submit(context) {
    TheUser user = Provider.of<TheUser>(context);

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: Text(
            '저장',
            style: TextStyle(color: Colors.white),
          ),
          color: (_isGenderFilled && _isBirthYearFilled && _isNicknameFilled)
              ? Colors.teal[400]
              : Colors.grey,
          onPressed: () async {
            if (_isGenderFilled && _isBirthYearFilled && _isNicknameFilled) {
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
                  Navigator.pop(context);
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
