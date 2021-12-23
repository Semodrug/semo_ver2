import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/constants.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/ok_dialog.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

bool _isPharmacistNameFilled = false;
bool _isPharmacistDateFilled = false;
final _UsNumberTextInputFormatter _birthDate =
    new _UsNumberTextInputFormatter();

class PharmacistGetInfo extends StatefulWidget {
  @override
  _PharmacistGetInfoState createState() => _PharmacistGetInfoState();
}

class _PharmacistGetInfoState extends State<PharmacistGetInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('추가정보 입력', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: PharmacistGetInfoForm(),
          ),
        );
      }),
    );
  }
}

class PharmacistGetInfoForm extends StatefulWidget {
  @override
  _PharmacistGetInfoFormState createState() => _PharmacistGetInfoFormState();
}

class _PharmacistGetInfoFormState extends State<PharmacistGetInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
              child: Text('약사님의\n추가 정보를 입력해주세요:)',
                  style: Theme.of(context).textTheme.headline3),
            ),
            SizedBox(
              height: 24,
            ),
            pharmacistNameField(),
            SizedBox(
              height: 20,
            ),
            pharmacistDateField(),
            SizedBox(height: 42),
            announceField(),
            SizedBox(height: 50),
            submitField(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  Widget pharmacistNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약사님의 성함',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _nameController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(
            hintText: '이름 입력',
          ),
          onChanged: (value) {
            if (value.length >= 2) {
              setState(() {
                _isPharmacistNameFilled = true;
              });
            } else {
              setState(() {
                _isPharmacistNameFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty) {
              return '이름을 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget pharmacistDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약사면허 발급일',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          maxLength: 10,
          keyboardType: TextInputType.number,
          controller: _dateController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(
            hintText: '발급일 입력(ex.1900.10.12)',
            counterText: '',
          ),
          inputFormatters: <TextInputFormatter>[
            //WhitelistingTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.digitsOnly,
            // Fit the validating format.
            _birthDate,
          ],
          onChanged: (value) {
            if (value.length >= 10) {
              setState(() {
                _isPharmacistDateFilled = true;
              });
            } else {
              setState(() {
                _isPharmacistDateFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty || value.length < 8) {
              return '발급일을 올바르게 입력해주세요';
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
        Text('약사의 한마디(리뷰) 작성 시', style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 4),
        Text(
            '* 성함의 중간글자는 암호화됩니다. (예: 홍길동 > 홍*동 약사)\n* 면허발급일 기준으로 경력이 표시됩니다. (예: 경력 3년차)',
            style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Widget submitField(context) {
    TheUser user = Provider.of<TheUser>(context);

    return IYMYSubmitButton(
        context: context,
        isDone: _isPharmacistNameFilled && _isPharmacistDateFilled,
        textString: '완료',
        onPressed: () async {
          /* 입력을 모두 완료 한 경우 */
          if (_isPharmacistNameFilled && _isPharmacistDateFilled) {
            // 출생년도 검사: 1900보다 크고 2021 보다 작아야, 월은 12보다 작고, 일은 31보다 작아야
            if (2021 < int.parse(_dateController.text.substring(0, 4)) ||
                int.parse(_dateController.text.substring(0, 4)) <= 1900 ||
                int.parse(_dateController.text.substring(5, 7)) > 12 ||
                int.parse(_dateController.text.substring(8, 10)) > 31) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '면허 발급일을 올바르게 입력해주세요',
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            }

            /* 출생년도 올바르게 입력한 경우, 유저 정보 업데이트 */
            else {
              // print(_nameController.text);
              // print(_dateController.text);

              await DatabaseService(uid: user.uid).setPharmacistInfo(
                true,
                _nameController.text,
                _dateController.text,
              );

              //TODO: 리뷰에서 닉네임도 변경 되어야 함
              // await ReviewService().updateNickname(
              //   user.uid,
              //   _nicknameController.text,
              // );

              /* update 완료 후 */
              IYMYOkDialog(
                context: context,
                dialogIcon: Icon(Icons.check, color: primary300_main),
                bodyString: '약사 인증이 완료되었습니다',
                buttonName: '확인',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BottomBar()));
                },
              ).showWarning();
            }
          }
        });
  }
}

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 4) + '.');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 6) + '.');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8));
      if (newValue.selection.end >= 8) selectionIndex++;
    }
// Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
