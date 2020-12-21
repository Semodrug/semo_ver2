import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/home/home.dart';

final fireInstance = Firestore.instance;

void createRecode(Map<String, dynamic> data) async {
  await fireInstance.collection('users').document('1').updateData(data);

  // await fireInstance.collection('user_info').document('1').updateData(data);

//  DocumentReference ref = await
//  //fireInstance.collection('privacy').add(data);
//  print(ref.documentID);
}

class RegisterThirdPage extends StatefulWidget {
  @override
  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  List<bool> isPregnant = List.generate(2, (_) => false);
  List<bool> isDisease = List.generate(7, (_) => false);
  List<String> disease_list = [];

  Widget _ExclusiveButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 40.0,
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

  Widget _MultiButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 40.0,
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
            isPressed[index] = !isPressed[index];
            isPressed[index]
                ? disease_list.add(buttonName)
                : disease_list.remove(buttonName);
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
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '건강 정보 설정',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '맞춤형 주의사항을 알려드려요.',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
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
                              Text('임산부이신가요?',
                                  style: TextStyle(fontSize: 14.0)),
                              SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                children: [
                                  _ExclusiveButton(0, isPregnant, '해당없음'),
                                  SizedBox(width: 10),
                                  _ExclusiveButton(1, isPregnant, '임산부'),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('특이사항', style: TextStyle(fontSize: 14.0)),
                              SizedBox(
                                height: 4.0,
                              ),
                              Row(
                                children: [
                                  _MultiButton(0, isDisease, '고혈압'),
                                  SizedBox(width: 6),
                                  _MultiButton(1, isDisease, '심장질환'),
                                  SizedBox(width: 6),
                                  _MultiButton(2, isDisease, '고지혈증'),
                                  SizedBox(width: 6),
                                  _MultiButton(3, isDisease, '당뇨병'),
                                ],
                              ),
                              Container(
                                height: 36.0,
                                child: Row(
                                  children: [
                                    _MultiButton(4, isDisease, '간장애'),
                                    SizedBox(width: 6),
                                    _MultiButton(5, isDisease, '콩팥장애'),
                                    SizedBox(width: 6),
                                    _MultiButton(6, isDisease, '신장'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '찾으시는 질병이 없으신가요?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(
                                height: 80.0,
                              ),
                              Center(
                                child: ButtonTheme(
                                    minWidth: 400.0,
                                    height: 40.0,
                                    child: FlatButton(
                                        color: Colors.teal[400],
                                        child: Text(
                                          '이약모약 시작하기',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                        onPressed: () {
                                          createRecode(
                                            {
                                              'isPregnant': isPregnant[1],
                                              'disease_list': disease_list,
                                            },
                                          );
/* 여기에 랭킹 페이지 넣기! */
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        })),
                              ),
                            ],
                          )))
                ],
              ),
            ),
          );
        }));
  }
}
