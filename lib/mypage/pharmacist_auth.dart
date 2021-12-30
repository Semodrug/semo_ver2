import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/mypage/pharmacitst_getinfo.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/ok_dialog.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/shared/warning_dialog.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool _isPharmacistCodeFilled = false;

class PharmacistAuthPage extends StatefulWidget {
  @override
  _PharmacistAuthPageState createState() => _PharmacistAuthPageState();
}

class _PharmacistAuthPageState extends State<PharmacistAuthPage> {
  @override
  Widget build(BuildContext context) {
    final TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: CustomAppBarWithGoToBack('약사 인증하기', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return FutureBuilder<bool>(
          future: DatabaseService(uid: user.uid).getIsPharmacist(user.uid),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (snapshot.data == false) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: PharmacistAuthForm(),
                ),
              );
            } else {
              /* 인증 완료 page */
              return Container();
            }
          },
        );
      }),
    );
  }
}

class PharmacistAuthForm extends StatefulWidget {
  @override
  _PharmacistAuthFormState createState() => _PharmacistAuthFormState();
}

class _PharmacistAuthFormState extends State<PharmacistAuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('이약모약팀으로부터 받은\n약사 인증 코드를 입력해주세요',
                  style: Theme.of(context).textTheme.headline3),
            ),
            SizedBox(
              height: 24,
            ),
            codeField(),
            SizedBox(
              height: 20,
            ),
            announceField(),
            SizedBox(height: 50.0),
            submitField(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Widget codeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약사 인증 코드',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _codeController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(
            hintText: '약사 인증 코드 입력',
          ),
          onChanged: (value) {
            if (value.length >= 6) {
              setState(() {
                _isPharmacistCodeFilled = true;
              });
            } else {
              setState(() {
                _isPharmacistCodeFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty || value.length < 6) {
              return '6자리 이상 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget announceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('약사인증 코드를 받기 원하시면 아래 주소로 이메일을 보내주세요',
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: primary500_light_text)),
        Text('iymy.dev@gmail.com',
            style: Theme.of(context).textTheme.caption.copyWith(
                color: primary500_light_text, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget submitField(context) {
    return IYMYSubmitButton(
        context: context,
        isDone: _isPharmacistCodeFilled,
        textString: '약사 인증하기',
        onPressed: () async {
          String answerCode = await getCode();

          bool _isCorrect = false;

          if (_isPharmacistCodeFilled && _formKey.currentState.validate()) {
            if (answerCode == _codeController.text) {
              _isCorrect = true;
            } else
              _isCorrect = false;
          }

          /* code가 일치하면, 성공 알림 - isPharmacist = true && Go get info page */
          if (_isCorrect == true) {
            IYMYOkDialog(
              context: context,
              dialogIcon: Icon(Icons.check, color: primary300_main),
              bodyString: '인증되었습니다',
              buttonName: '확인',
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PharmacistGetInfo()),
                );
              },
            ).showWarning();
          }

          /* code가 일치하지 않으면 warning  */
          else {
            IYMYWarningDialog(
                context: context,
                dialogIcon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/icons/warning_icon.png')),
                bodyString: '[인증실패] 잘못된 코드 입니다',
                leftButtonName: '닫기',
                leftOnPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                rightButtonName: '재시도',
                rightOnPressed: () {
                  Navigator.pop(context);
                }).showWarning();
          }
        });
  }
}

Future<String> getCode() async {
  // print('debug');
  DocumentSnapshot ds = await FirebaseFirestore.instance
      .collection('AppInfo')
      .doc('PharmacistAuthCode')
      .get();
  // print(ds.data()["code1"]);

  return ds.data()["code1"];
  // DB에서 코드를 추가할 때는 code2, code3 등으로 추가하면 되고
  // 여기서 code1을 code2로 바꿔주면 된다
  // 혹은 다 가져와서 일치하는지 확인하는 식으로 코드를 짜면 된
}
