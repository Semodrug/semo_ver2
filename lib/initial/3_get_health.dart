import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';

bool _isFind = false;

class GetHealthPage extends StatefulWidget {
  @override
  _GetHealthPageState createState() => _GetHealthPageState();
}

class _GetHealthPageState extends State<GetHealthPage> {
  TextEditingController _selfWritingController = TextEditingController();

  List<bool> _isPregnant = List.generate(2, (_) => false);
  List<bool> _isDisease = List.generate(7, (_) => false);
  List<String> _diseaseList = [];

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
            '회원가입',
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topTitle(),
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
                              pregnant(),
                              SizedBox(
                                height: 20.0,
                              ),
                              disease(),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                child: Text(
                                  '찾으시는 질병이 없으신가요?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFind = true;
                                  });
                                },
                              ),
                              _isFind ? selfWrite() : Container(),
                              SizedBox(
                                height: 40.0,
                              ),
                              submit()
                            ],
                          )))
                ],
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
          '건강 정보 설정',
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600),
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
      ],
    );
  }

  Widget pregnant() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('임산부이신가요?', style: TextStyle(fontSize: 14.0)),
        SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            _exclusiveButton(0, _isPregnant, '해당없음'),
            SizedBox(width: 10),
            _exclusiveButton(1, _isPregnant, '임산부'),
          ],
        ),
      ],
    );
  }

  Widget disease() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('특이사항', style: TextStyle(fontSize: 14.0)),
        SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            _multiButton(0, _isDisease, '고혈압'),
            SizedBox(width: 6),
            _multiButton(1, _isDisease, '심장질환'),
            SizedBox(width: 6),
            _multiButton(2, _isDisease, '고지혈증'),
            SizedBox(width: 6),
            _multiButton(3, _isDisease, '당뇨병'),
          ],
        ),
        Container(
          height: 36.0,
          child: Row(
            children: [
              _multiButton(4, _isDisease, '간장애'),
              SizedBox(width: 6),
              _multiButton(5, _isDisease, '신장'),
              SizedBox(width: 6),
              _multiButton(6, _isDisease, '심장'),
            ],
          ),
        ),
      ],
    );
  }

  Widget selfWrite() {
    return Container(
      padding: EdgeInsets.all(8),
      height: 40,
      child: TextField(
        controller: _selfWritingController,
        cursorColor: Colors.teal[400],
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
            hintText: '질병명 직접 입력하기',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0)),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget submit() {
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
            '완료',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal[400],
          onPressed: () async {
            if (_selfWritingController.text.isNotEmpty)
              _diseaseList.add(_selfWritingController.text);

            await DatabaseService(uid: user.uid)
                .updateUserHealth(_isPregnant[1], _diseaseList);

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/start', (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }

  /* buttons */
  Widget _exclusiveButton(index, isPressed, buttonName) {
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

  Widget _multiButton(index, isPressed, buttonName) {
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
                ? _diseaseList.add(buttonName)
                : _diseaseList.remove(buttonName);
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
