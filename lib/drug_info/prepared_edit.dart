import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/ok_dialog.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

class PreparedEdit extends StatefulWidget {
  final String drugItemSeq;
  final String expirationString;

  const PreparedEdit({Key key, this.drugItemSeq, this.expirationString})
      : super(key: key);

  @override
  _PreparedEditState createState() => _PreparedEditState();
}

class _PreparedEditState extends State<PreparedEdit> {
  // variables for prepared case
  DateTime _madeDateTime = DateTime.now();
  int _addDays = 0;
  DateTime _finalDateTime = DateTime.now().add(Duration(days: 60));
  String _finalString =
      DateFormat('yyyy.MM.dd').format(DateTime.now().add(Duration(days: 60)));
  bool _isSelf = false;

  @override
  void initState() {
    _isSelf = true;

    // change String to DateTime
    String dateOfUserDrug = '';
    List<String> getOnlyDate = widget.expirationString.split('.');

    for (int i = 0; i < getOnlyDate.length; i++) {
      dateOfUserDrug = dateOfUserDrug + getOnlyDate[i];
    }

    String dateWithT = dateOfUserDrug.substring(0, 8) + 'T' + '000000';
    DateTime expirationTime = DateTime.parse(dateWithT);

    _finalDateTime = expirationTime;
    _finalString = DateFormat('yyyy.MM.dd').format(_finalDateTime);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('사용기한 수정하기', Icon(Icons.close), 0.5),
      backgroundColor: gray0_white,
      body: StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
        builder: (context, snapshot) {
          TheUser user = Provider.of<TheUser>(context);
          Drug drug = snapshot.data;

          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _topInfo(context, drug),
                    SizedBox(height: 20),
                    _pickPreparedDay(),
                    SizedBox(height: 20),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: _pickDuration()),
                    SizedBox(height: 20),
                    _isSelf ? _pickSelf() : Container(),
                    _showExpiration(),
                    SizedBox(height: 20),
                    _submitButton(context, user, drug, _finalString),
                  ],
                ),
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }

  String _shortenName(String drugName) {
    List splitName = [];

    if (drugName.contains('(')) {
      splitName = drugName.split('(');
      return splitName[0];
    } else
      return drugName;
  }

  Widget _topInfo(BuildContext context, drug) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          child: DrugImage(drugItemSeq: drug.itemSeq),
        ),
        SizedBox(height: 20),
        Text(
          drug.entpName,
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 2),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            _shortenName(drug.itemName),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
        CategoryButton(str: drug.category),
      ],
    );
  }

  Widget _pickPreparedDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '언제 약을 조제받으셨나요?',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 4),
        FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2030, 12, 31),
                  onChanged: (date) {}, onConfirm: (date) async {
                setState(() {
                  _madeDateTime = date;
                  _finalDateTime = _madeDateTime.add(Duration(days: _addDays));
                  _finalString =
                      DateFormat('yyyy.MM.dd').format(_finalDateTime);
                });
              },
                  currentTime: _madeDateTime,
                  locale: LocaleType.ko); // need currentTime setting?
            },
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: gray75),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('yyyy').format(_madeDateTime)}년 ${DateFormat('MM').format(_madeDateTime)}월 ${DateFormat('dd').format(_madeDateTime)}일',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray750_activated),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ))
      ],
    );
  }

  Widget _pickDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약 종류에 따른 예상 사용가능기간을 선택해주세요',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          height: 45,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: gray75),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButton(
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down),
            underline: SizedBox.shrink(),
            value: _addDays,
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                value: 60,
                child: Text(
                  '[2개월] 약국에서 처방받은 알약',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 14,
                child: Text(
                  '[2주] 개봉된 액체상태의 시럽',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 30,
                child: Text(
                  '[1개월] 개봉된 액체상태의 안약',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 180,
                child: Text(
                  '[6개월] 개봉된 연고',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 0,
                child: Text(
                  '직접 입력하기',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                onTap: () {
                  setState(() {
                    _isSelf = true;
                  });
                },
              ),
            ],
            onChanged: (value) {
              setState(() {
                _addDays = value;

                _finalDateTime = _madeDateTime.add(Duration(days: _addDays));
                _finalString = DateFormat('yyyy.MM.dd').format(_finalDateTime);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _pickSelf() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '유효기한 직접 입력',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: 4,
        ),
        FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 12, 31),
                  onChanged: (date) {}, onConfirm: (date) async {
                setState(() {
                  _finalDateTime = date;
                  _finalString =
                      DateFormat('yyyy.MM.dd').format(_finalDateTime);
                });
              },
                  currentTime: _finalDateTime,
                  locale: LocaleType.ko); // need currentTime setting?
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: gray75),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('yyyy').format(_finalDateTime)}년 ${DateFormat('MM').format(_finalDateTime)}월 ${DateFormat('dd').format(_finalDateTime)}일',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray750_activated),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            )),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _showExpiration() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '예상 유효기간은 ',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              TextSpan(
                  text: _finalString,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal[400])),
              TextSpan(
                text: ' 입니다',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  Widget _submitButton(
      context, TheUser user, Drug drug, String expirationString) {
    String newName = drug.itemName;
    List splitName = [];

    if (newName.contains('(')) {
      splitName = newName.split('(');
      newName = splitName[0];
    }

    List<String> searchNameList = newName.split('');
    List<String> searchListOutput = [];

    for (int i = 0; i < searchNameList.length; i++) {
      if (i != searchNameList.length - 1) {
        searchListOutput.add((searchNameList[i]));
      }
      List<String> temp = [searchNameList[i]];
      for (int j = i + 1; j < searchNameList.length; j++) {
        temp.add(searchNameList[j]);
        searchListOutput.add((temp.join()));
      }
    }

    return IYMYSubmitButton(
      context: context,
      isDone: true,
      textString: '수정하기',
      onPressed: () async {
        IYMYOkDialog(
          context: context,
          dialogIcon: Icon(Icons.check, color: primary300_main),
          bodyString: '사용기한이 수정되었습니다',
          buttonName: '확인',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ).showWarning();
        await DatabaseService(uid: user.uid).addSavedList(
            drug.itemName,
            drug.itemSeq,
            drug.category,
            drug.etcOtcCode,
            expirationString,
            searchListOutput);
      },
    );
  }
}
