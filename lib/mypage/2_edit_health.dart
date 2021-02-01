import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/auth.dart';
import 'package:semo_ver2/services/db.dart';

bool _isFind = false;

class EditHealthPage extends StatefulWidget {
  final UserData userData;

  const EditHealthPage({Key key, this.userData}) : super(key: key);
  @override
  _EditHealthPageState createState() => _EditHealthPageState();
}

class _EditHealthPageState extends State<EditHealthPage> {
  final AuthService _auth = AuthService();

  TextEditingController _selfWritingController = TextEditingController();
  List<bool> _isPregnant = List.generate(2, (_) => false);
  List<bool> _isDisease = List.generate(7, (_) => false);
  List<String> _diseaseList = [];

  void initState() {
    super.initState();
    _isPregnant =
        (widget.userData.isPregnant == true) ? [true, false] : [false, true];
    if (widget.userData.keywordList.contains('고혈압')) {
      _isDisease[0] = true;
      _diseaseList.add('고혈압');
    }
    if (widget.userData.keywordList.contains('심장질환')) {
      _isDisease[1] = true;
      _diseaseList.add('심장질환');
    }
    if (widget.userData.keywordList.contains('고지혈증')) {
      _isDisease[2] = true;
      _diseaseList.add('고지혈증');
    }
    if (widget.userData.keywordList.contains('당뇨병')) {
      _isDisease[3] = true;
      _diseaseList.add('당뇨병');
    }
    if (widget.userData.keywordList.contains('간장애')) {
      _isDisease[4] = true;
      _diseaseList.add('간장애');
    }
    if (widget.userData.keywordList.contains('콩팥장애')) {
      _isDisease[5] = true;
      _diseaseList.add('콩팥장애');
    }
    if (widget.userData.keywordList.contains('신장')) {
      _isDisease[5] = true;
      _diseaseList.add('신장');
    }

    if (widget.userData.keywordList.isNotEmpty &&
        !['고혈압', '심장질환', '고지혈증', '당뇨병', '간장애', '콩팥장애', '신장']
            .contains(widget.userData.keywordList.last)) {
      _isFind = true;
      _selfWritingController.text = widget.userData.keywordList.last;
    }
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
            '나의 건강정보 관리',
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
                  topTitle(widget.userData),
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
              _multiButton(5, _isDisease, '콩팥장애'),
              SizedBox(width: 6),
              _multiButton(6, _isDisease, '신장'),
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

            await DatabaseService(uid: user.uid).updateUserHealth(_diseaseList);

            _showEditedWell(context);
          },
        ),
      ),
    );
  }

  void _showEditedWell(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          // Navigator.pushReplacementNamed(context, '/bottom_bar');
        }); // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 17,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '건강 정보',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '가 수정되었습니다.'),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                // Text(
                //   '홈에서 확인하실 수 있습니다',
                //   style: TextStyle(fontSize: 14, color: Colors.grey),
                // ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
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
