import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'register_3.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final fireInstance = FirebaseFirestore.instance;

var phoneMaskFormatter = new MaskTextInputFormatter(
    mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});
var birthMaskFormatter = new MaskTextInputFormatter(
    mask: '####.##.##', filter: {"#": RegExp(r'[0-9]')});

//print(maskFormatter.getMaskedText()); // -> "+0 (123) 456-78-90"
//print(maskFormatter.getUnmaskedText()); // -> 01234567890

void createRecode(Map<String, dynamic> data) async {
  User user = await _auth.currentUser;

  //user.uid;
  await fireInstance.collection('users').document('1').setData(data);

//  DocumentReference ref = await fireInstance.collection('privacy').add(data);
//  print(ref.documentID);
}

class RegisterSecondPage extends StatefulWidget {
  @override
  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  List<bool> isSelected = List.generate(2, (_) => false);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입',
            style: TextStyle(
                color: Colors.black, letterSpacing: 2.0, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1.0,
          leading: Icon(
            Icons.arrow_back,
            color: Colors.teal[400],
          ),
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '이제 곧 회원가입이\n완료됩니다:D',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Form(
                        child: Theme(
                            data: ThemeData(
                              primaryColor: Colors.teal[400],
                              inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(
                                color: Colors.teal[400],
                                fontSize: 18.0,
                              )),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      labelText: '이름', hintText: '홍길동'),
                                  keyboardType: TextInputType.text,
//                                  validator: (String value) {
//                                    if (value.isEmpty) return "이름을 입력하세요.";
//                                    return null;
//                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text('성별',
                                    style: TextStyle(
                                        color: Colors.teal[400],
                                        fontSize: 18.0)),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ToggleButtons(
                                  constraints: BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 20,
                                  ),
                                  children: [Text('남'), Text('여')],
                                  //selectedColor: Colors.teal[400],
                                  //fillColor: Colors.teal[100],
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
//                              SizedBox(
//                                height: 20.0,
//                              ),
                                TextFormField(
                                  controller: birthController,
                                  decoration: InputDecoration(
                                      labelText: '생년월일',
                                      hintText: '2020.01.01'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [birthMaskFormatter],
//                                  validator: (String value) {
//                                    if (value.isEmpty) return "생년월일을 입력하세요.";
//                                    return null;
//                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                      labelText: '전화번호',
                                      hintText: '010-1234-5678'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [phoneMaskFormatter],
//                                  validator: (String value) {
//                                    if (value.isEmpty) return "전화번호를 입력하세요.";
//                                    return null;
//                                  },
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Center(
                                  child: ButtonTheme(
                                      minWidth: 400.0,
                                      height: 40.0,
                                      //buttonColor: Colors.teal[400],
                                      child: FlatButton(
                                        color: Colors.teal[400],
                                        child: Text(
                                          '다음',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                        onPressed: () {
                                          if (phoneMaskFormatter
                                                      .getUnmaskedText()
                                                      .length !=
                                                  11 ||
                                              birthMaskFormatter
                                                      .getUnmaskedText()
                                                      .length !=
                                                  8)
                                            showSnackBar(context);
                                          else {
                                            if (isSelected[0] = true)
                                              createRecode(
                                                {
                                                  'name': nameController.text,
                                                  'sex': 'male',
                                                  'phone': phoneController.text,
                                                  'birth': birthController.text
                                                },
                                              );
                                            else
                                              createRecode(
                                                {
                                                  'name': nameController.text,
                                                  'sex': 'female',
                                                  'phone': phoneController.text,
                                                  'birth': birthController.text
                                                },
                                              );

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterThirdPage()));
                                          }
                                        },
                                      )),
                                ),
                              ],
                            ))),
                  )
                ],
              ),
            ),
          );
        }));
  }
}

void showSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('입력하신 항목을 다시 확인해주세요', textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.teal[100],
  ));
}
