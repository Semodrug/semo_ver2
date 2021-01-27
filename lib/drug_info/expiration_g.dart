import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/shared/image.dart';

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
          '상비약 추가하기',
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
              return Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    _topInfo(context, drug),
                    SizedBox(
                      height: 20,
                    ),
                    _datePickG(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            '조제받은 약인가요?',
                            style: TextStyle(
                              color: Colors.grey,
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
                    SizedBox(
                      height: 20,
                    ),
                    _okButton(context, user, drug, _expirationDateString)
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: SingleChildScrollView(
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
                      SizedBox(height: 20),
                      _expectedDuration(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                      SizedBox(
                        height: 20,
                      ),
                      _okButton(context, user, drug, _expectedDateString)
                    ],
                  ),
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
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          drug.itemName,
          style: TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
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
          '사용기한 입력하기',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                  maxTime: DateTime(2100, 12, 31), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) async {
                print('confirm $date');

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
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ))
      ],
    );
  }

  Widget _datePick() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약을 제조받은 일자가 언제인가요?',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ))
      ],
    );
  }

  Widget _durationPick() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약 종류에 따른 예상 사용가능기간을 선택해주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                child: Text('2개월 - 약국에서 처방받은 알약'),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 14,
                child: Text('2주 - 개봉된 액체상태의 시럽'),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 30,
                child: Text('1개월 - 개봉된 액체상태의 안약'),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 180,
                child: Text('6개월 - 개봉된 연고'),
                onTap: () {
                  setState(() {
                    _isSelf = false;
                  });
                },
              ),
              DropdownMenuItem(
                value: 0,
                child: Text('유효기한 직접 입력하기'),
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
    );
  }

  Widget _expectedDuration() {
    return Column(
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
              ),
              TextSpan(
                  text: _expectedDateString,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal[400])),
              TextSpan(
                text: '입니다',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // Widget selfWrite() {
  //   return TextFormField(
  //       controller: _selfWritingController,
  //       cursorColor: Colors.teal[400],
  //       decoration: InputDecoration(
  //           focusedBorder: UnderlineInputBorder(
  //             borderSide: BorderSide(color: Colors.teal),
  //           ),
  //           hintText: '예상 사용가능 기간이 몇일인가요? 예) 30',
  //           hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0)),
  //       keyboardType: TextInputType.number,
  //       onChanged: (value) {
  //         setState(() {
  //           DateTime _expectedDateTime =
  //               _pickDateTime.add(Duration(days: int.parse(value)));
  //           _expectedDateString =
  //               DateFormat('yyyy.MM.dd').format(_expectedDateTime);
  //         });
  //       });
  // }

  Widget _expirationPick() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '유효기한 직접 입력',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ))
      ],
    );
  }

  Widget _okButton(context, user, drug, expirationTime) {
    List<String> searchNameList = drug.itemName.split('');
    List<String> searchListOutput = [];
      for(int i =0; i< searchNameList.length; i++){
        if (i != searchNameList.length - 1) {
          searchListOutput.add((searchNameList[i]));
        }
        List<String> temp = [searchNameList[i]];
        for (int j = i + 1; j < searchNameList.length; j++) {
          temp.add(searchNameList[j]);
          searchListOutput.add((temp.join()));
        }
      }


    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400.0,
        height: 45.0,
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        //alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () async {
            _showSaveWell(context);
            // Navigator.pop(context);
            await DatabaseService(uid: user.uid).addSavedList(drug.itemName,
                drug.itemSeq, drug.category, drug.etcOtcCode, expirationTime, searchListOutput);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            '추가하기',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.teal[400],
        ),
      ),
    );
  }

  void _showSaveWell(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          // Navigator.of(context).pop(true);
          // Navigator.of(context).pop(true);
          Navigator.pushReplacementNamed(context, '/bottom_bar');
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
                          text: '약 보관함',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '에 추가되었습니다.'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '홈에서 확인하실 수 있습니다',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
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
}
