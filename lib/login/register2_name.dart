import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/login/register3_health.dart';

// var phoneMaskFormatter = new MaskTextInputFormatter(
//     mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});
var birthMaskFormatter = new MaskTextInputFormatter(
    mask: '####.##.##', filter: {"#": RegExp(r'[0-9]')});

//print(maskFormatter.getMaskedText()); // -> "+0 (123) 456-78-90"
//print(maskFormatter.getUnmaskedText()); // -> 01234567890

class RegisterSecondPage extends StatefulWidget {
  final String title = '회원가입';

  @override
  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  List<bool> isSelected = List.generate(2, (_) => false);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthController = TextEditingController();

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
                      Container(
                        child: Text('이제 곧 회원가입이 \n완료됩니다 :)',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      nameGender(),
                      SizedBox(
                        height: 10.0,
                      ),
                      nickname(),
                      SizedBox(
                        height: 10.0,
                      ),
                      birth(),
                      SizedBox(height: 50.0),
                      submit(context),

                      /* 로그인 뛰어넘기 */
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterThirdPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget nameGender() {
    return Row(
      children: [
        Container(
          width: 200,
          child: TextFormField(
            controller: nameController,
            cursorColor: Colors.teal[400],
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                hintText: '이름',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
            keyboardType: TextInputType.text,
            validator: (String value) {
              if (value.isEmpty) return "이름을 입력하세요.";
              return null;
            },
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('성별', style: TextStyle(color: Colors.grey, fontSize: 16.0)),
            SizedBox(
              width: 10,
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
        ),
      ],
    );
  }

  Widget nickname() {
    return TextFormField(
      controller: nicknameController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          hintText: '닉네임',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) return "닉네임을 입력하세요.";
        return null;
      },
    );
  }

  Widget birth() {
    return TextFormField(
      controller: birthController,
      cursorColor: Colors.teal[400],
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          hintText: '생년월일',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
      keyboardType: TextInputType.number,
      inputFormatters: [birthMaskFormatter],
      validator: (String value) {
        if (value.isEmpty) return "생년월일을 입력하세요.";
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
          onPressed: () async {
            // phoneMaskFormatter.getUnmaskedText().length != 11 ||
            if (birthMaskFormatter.getUnmaskedText().length != 8)
              showSnackBar(context);
            else {
              await DatabaseService(uid: user.uid).updateUserInfo(
                  nameController.text,
                  isSelected[0] ? 'male' : 'female',
                  nicknameController.text,
                  birthController.text);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterThirdPage()));
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: const Text(
            '다음',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal[400],
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
