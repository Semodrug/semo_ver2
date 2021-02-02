import 'package:flutter/material.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';

import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';

List infoEE;
List infoNB;
List infoUD;
String storage;
String entp_name;

class WarningInfo extends StatefulWidget {
  final String drugItemSeq;
  final List warningList;

  const WarningInfo({Key key, this.drugItemSeq, this.warningList})
      : super(key: key); //추가

  @override
  _WarningInfoState createState() => _WarningInfoState();
}

class _WarningInfoState extends State<WarningInfo> {
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
          '자세히보기',
          style: Theme.of(context).textTheme.headline5,
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
      body: Column(
        children: [
          Expanded(
              child: _specificInfo(
                  context, widget.drugItemSeq, widget.warningList))
        ],
      ),
    );
  }
}

// TODO: 결과들이 개수만큼 아래 위로 찾아서 볼 수 있게끔 아니면 핀이 있어서, 바로 그 방향으로 갈 수 있도록
Widget _specificInfo(
    BuildContext context, String drugItemSeq, List warningList) {
  var warnings = List<String>.from(warningList);
  warnings = warningList.cast<String>();

  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          storage = drug.storageMethod;
          entp_name = drug.entpName;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '효능효과',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Center(
                      child: DynamicTextHighlighting(
                        highlights: warnings,
                        text: _changeToText(context, drug.eeDocData),
                        color: warning.withOpacity(0.3),
                        style: Theme.of(context).textTheme.bodyText2,
                        caseSensitive: false,
                      ),
                    ),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '용법용량',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Center(
                      child: DynamicTextHighlighting(
                        highlights: warnings,
                        text: _changeToText(context, drug.udDocData),
                        color: warning.withOpacity(0.3),
                        style: Theme.of(context).textTheme.bodyText2,
                        caseSensitive: false,
                      ),
                    ),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '저장방법',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(drug.storageMethod),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '회사명',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(drug.entpName),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '주의사항',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Center(
                      child: DynamicTextHighlighting(
                        highlights: warnings,
                        text: _changeToText(context, drug.nbDocData),
                        style: Theme.of(context).textTheme.bodyText2,
                        color: warning.withOpacity(0.3),
                        caseSensitive: false,
                      ),
                    ),
                    Divider(
                      height: 30,
                    ),
                  ]),
            ),
          );
        } else {
          return Loading();
        }
      });
}

String _changeToText(BuildContext context, List notYetText) {
  String textFinish = '';
  for (int i = 0; i < notYetText.length; i++) {
    textFinish = textFinish + notYetText[i].toString() + '\n';
  }
  //잘라져 있는 형태라면 이부분을 없애면 될 거 같다.
  textFinish = textFinish.replaceAll(" \"", "\n\"");

  return textFinish;
}
