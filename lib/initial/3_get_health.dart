import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/theme/colors.dart';

bool _isChoose = false;
bool _isFind = false;

class GetHealthPage extends StatefulWidget {
  @override
  _GetHealthPageState createState() => _GetHealthPageState();
}

class _GetHealthPageState extends State<GetHealthPage> {
  TextEditingController _selfWritingController = TextEditingController();

  List<bool> _isKeyword = List.generate(10, (_) => false);
  List<String> _keywordList = [];

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
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 0.0),
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
                              chooseKeywords(),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                child: Text(
                                  '원하는 키워드가 없으신가요?',
                                  style: TextStyle(
                                    fontFamily: 'Noto Sans KR',
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFind = !_isFind;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: Theme.of(context).textTheme.headline3,
              children: <TextSpan>[
                TextSpan(
                  text: '단어를 선택해주시면\n',
                ),
                TextSpan(
                  text: '맞춤형 키워드 알림',
                  style: Theme.of(context).textTheme.headline2,
                ),
                TextSpan(
                  text: '을 드려요',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseKeywords() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('알림을 받고싶은 키워드를 선택해주세요 ',
                  style: Theme.of(context).textTheme.subtitle1),
              Text('(복수선택가능)',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w100))
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            children: [
              _exclusiveMultiButton(0, _isKeyword, '없음'),
              SizedBox(width: 6),
              _exclusiveMultiButton(1, _isKeyword, '임산부'),
              SizedBox(width: 6),
              _exclusiveMultiButton(2, _isKeyword, '고령자'),
              SizedBox(width: 6),
              _exclusiveMultiButton(3, _isKeyword, '소아'),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              _exclusiveMultiButton(4, _isKeyword, '간'),
              SizedBox(width: 6),
              _exclusiveMultiButton(5, _isKeyword, '신장(콩팥)'),
              SizedBox(width: 6),
              _exclusiveMultiButton(6, _isKeyword, '심장'),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              _exclusiveMultiButton(7, _isKeyword, '고혈압'),
              SizedBox(width: 6),
              _exclusiveMultiButton(8, _isKeyword, '당뇨'),
              SizedBox(width: 6),
              _exclusiveMultiButton(9, _isKeyword, '유당분해요소 결핍증'),
            ],
          ),
        ],
      ),
    );
  }

  Widget selfWrite() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      height: 30,
      child: TextField(
        controller: _selfWritingController,
        cursorColor: primary400_line,
        decoration: textInputDecoration.copyWith(hintText: '키워드 직접 입력하기'),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget submit() {
    TheUser user = Provider.of<TheUser>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
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
            _isChoose ? '완료' : '건너뛰기',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: gray0_white, fontSize: 15),
          ),
          color: primary400_line,
          onPressed: () async {
            if (_isKeyword[1] == true) _keywordList.add('임산부');
            if (_isKeyword[2] == true) _keywordList.add('고령자');
            if (_isKeyword[3] == true) _keywordList.add('소아');
            if (_isKeyword[4] == true) _keywordList.add('간');
            if (_isKeyword[5] == true) _keywordList.add('신장');
            if (_isKeyword[6] == true) _keywordList.add('심장');
            if (_isKeyword[7] == true) _keywordList.add('고혈압');
            if (_isKeyword[8] == true) _keywordList.add('당뇨');
            if (_isKeyword[9] == true) _keywordList.add('유당불내증');

            if (_selfWritingController.text.isNotEmpty)
              _keywordList.add(_selfWritingController.text);

            await DatabaseService(uid: user.uid).updateUserHealth(_keywordList);

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/start', (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }

  Widget _exclusiveMultiButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 40.0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
                color: isPressed[index] ? primary300_main : gray200)),
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        onPressed: () {
          _isChoose = true;

          setState(() {
            // 0번 버튼을 누르면 나머지 버튼 값은 모두 false
            if (index == 0) {
              isPressed[0] = true;
              for (int i = 1; i < isPressed.length; i++) {
                isPressed[i] = false;
              }
            }
            // 0번 버튼이 아닌 버튼을 누르면 0번 버튼은 false
            else {
              isPressed[index] = !isPressed[index];
              isPressed[0] = false;
            }
          });
        },
        child: Text(buttonName,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: isPressed[index] ? primary500_light_text : gray400,
                )),
      ),
    );
  }
}
