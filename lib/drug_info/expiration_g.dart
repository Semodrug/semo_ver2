import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/bottom_bar.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/shortcut_dialog.dart';
import 'package:semo_ver2/shared/submit_button.dart';
import 'package:semo_ver2/theme/colors.dart';

class ExpirationG extends StatefulWidget {
  final String drugItemSeq;

  const ExpirationG({Key key, this.drugItemSeq}) : super(key: key);

  @override
  _ExpirationGState createState() => _ExpirationGState();
}

class _ExpirationGState extends State<ExpirationG> {
  bool _isGeneral = true;

  DateTime _pickDateTime = DateTime.now();

  int _durationInt = 60;
  String _expectedDateString =
      DateFormat('yyyy.MM.dd').format(DateTime.now().add(Duration(days: 60)));
  bool _isSelf = false;
  DateTime _pickSelfDateTime = DateTime.now();

  String _expirationDateString =
      DateFormat('yyyy.MM.dd').format(DateTime.now());

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
          '약 추가하기',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: StreamBuilder<Drug>(
        stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
        builder: (context, snapshot) {
          TheUser user = Provider.of<TheUser>(context);
          Drug drug = snapshot.data;

          if (snapshot.hasData) {
            if (_isGeneral) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  _topInfo(context, drug),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _datePickG(),
                  ),
                  SizedBox(height: 13),
                  _tip(),
                  SizedBox(height: 58),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          child: Text(
                            '처방받은 약인가요?',
                            style: TextStyle(
                              color: primary500_light_text,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isGeneral = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _submitButton(
                        context, user, drug, _expirationDateString),
                  )
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _topInfo(context, drug),
                    SizedBox(height: 20),
                    _datePick(),
                    SizedBox(height: 20),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: _durationPick()),
                    SizedBox(height: 20),
                    _isSelf ? _expirationPick() : Container(),
                    // SizedBox(height: 20),
                    _expectedDuration(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            child: Text(
                              '상비약인가요?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isGeneral = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _submitButton(
                          context, user, drug, _expectedDateString),
                    )
                  ],
                ),
              );
            }
          } else {
            return Loading();
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
          child: AspectRatio(
              aspectRatio: 3.5 / 2,
              child: DrugImage(drugItemSeq: drug.itemSeq)),
        ),
        SizedBox(
          height: 20,
        ),
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

  Widget _datePickG() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사용기한',
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
                  minTime: DateTime(2020, 1, 1),
                  maxTime: DateTime(2100, 12, 31),
                  onChanged: (date) {}, onConfirm: (date) async {
                setState(() {
                  _pickDateTime = date;
                });

                _expirationDateString = DateFormat('yyyy.MM.dd').format(date);
              },
                  currentTime: _pickDateTime,
                  locale: LocaleType.ko); // need currentTime setting?
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('yyyy').format(_pickDateTime)}년 ${DateFormat('MM').format(_pickDateTime)}월 ${DateFormat('dd').format(_pickDateTime)}일',
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

  Widget _datePick() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '언제 약을 제조받으셨나요?',
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
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2030, 12, 31),
                    onChanged: (date) {}, onConfirm: (date) async {
                  setState(() {
                    _pickDateTime = date;
                  });
                },
                    currentTime: DateTime.now(),
                    locale: LocaleType.ko); // need currentTime setting?
              },
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('yyyy').format(_pickDateTime)}년 ${DateFormat('MM').format(_pickDateTime)}월 ${DateFormat('dd').format(_pickDateTime)}일',
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
      ),
    );
  }

  Widget _durationPick() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox.shrink(),
              value: _durationInt,
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
                  _durationInt = value;
                  DateTime _expectedDateTime =
                      _pickDateTime.add(Duration(days: _durationInt));
                  _expectedDateString =
                      DateFormat('yyyy.MM.dd').format(_expectedDateTime);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _expectedDuration() {
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
                  text: _expectedDateString,
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

  Widget _expirationPick() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2030, 12, 31),
                    onChanged: (date) {}, onConfirm: (date) async {
                  setState(() {
                    _pickSelfDateTime = date;
                    _expectedDateString =
                        DateFormat('yyyy.MM.dd').format(_pickSelfDateTime);
                  });
                },
                    currentTime: DateTime.now(),
                    locale: LocaleType.ko); // need currentTime setting?
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('yyyy').format(_pickSelfDateTime)}년 ${DateFormat('MM').format(_pickSelfDateTime)}월 ${DateFormat('dd').format(_pickSelfDateTime)}일',
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
      ),
    );
  }

  Widget _tip() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tip",
              style: Theme.of(context).textTheme.caption.copyWith(
                  fontWeight: FontWeight.bold, color: primary500_light_text),
            ),
            Text("약에 표시된 사용기한은 보통 1~2년 이상이지만,",
                style: Theme.of(context).textTheme.caption),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.caption,
                children: <TextSpan>[
                  TextSpan(
                    text: '개봉 후',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '에는 기간이 단축됩니다.',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.caption,
                children: <TextSpan>[
                  TextSpan(
                    text: '- 알약, 연고류: 6',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '개월 / ',
                  ),
                  TextSpan(
                    text: '크림류: 3',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '개월 / ',
                  ),
                  TextSpan(
                    text: '물약, 시럽약: 1',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '개월',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(context, user, drug, expirationTime) {
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
      textString: '추가하기',
      onPressed: () async {
        IYMYShortCutDialog(
          context: context,
          dialogIcon: Icon(Icons.check, color: primary300_main),
          boldBodyString: '나의 약 보관함',
          normalBodyString: '에 추가되었습니다',
          topButtonName: '바로가기',
          bottomButtonName: '확인',
          onPressedTop: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomBar()));
          },
          onPressedBottom: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ).showWarning();
        await DatabaseService(uid: user.uid).addSavedList(
            drug.itemName,
            drug.itemSeq,
            drug.category,
            drug.etcOtcCode,
            expirationTime,
            searchListOutput);
      },
    );
  }
}
