import 'package:flutter/material.dart';
import 'package:semo_ver2/drug_info/search_highlighting.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';

List infoEE;
List infoNB;
List infoUD;
String storage;
String entpName;

class DetailInfo extends StatefulWidget {
  final String drugItemSeq;

  const DetailInfo({Key key, this.drugItemSeq}) : super(key: key); //추가

  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('약 정보 전체보기', Icon(Icons.arrow_back), 3),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 11, 16, 0),
                  child: SizedBox(
                      height: 35,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.search, size: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "어떤 약정보를 찾고 계세요?",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SearchHighlightingScreen(
                                          infoEE: infoEE,
                                          infoNB: infoNB,
                                          infoUD: infoUD,
                                          storage: storage,
                                          entp_name: entpName)));
                        },
                        textColor: gray300_inactivated,
                        color: gray50,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                width: 1.0,
                                color: gray200),
                            borderRadius: BorderRadius.circular(8.0)),
                      )),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
          Expanded(child: _specificInfo(context, widget.drugItemSeq))
        ],
      ),
    );
  }
}

Widget _specificInfo(BuildContext context, String drugItemSeq) {
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          storage = drug.storageMethod;
          entpName = drug.entpName;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '효능효과',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    _drugInfo(context, drugItemSeq, 'EE'),
                    Divider(
                      height: 30,
                    ),
                    Text(
                      '용법용량',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    _drugInfo(context, drugItemSeq, 'UD'),
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
                    _drugInfo(context, drugItemSeq, 'NB'),
                    Container(
                      height: 10,
                    ),
                  ]),
            ),
          );
        } else {
          return Loading();
        }
      });
}

Widget _drugInfo(BuildContext context, String drugItemSeq, String type) {
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          if (type == 'EE') {
            infoEE = drug.eeDocData;
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: drug.eeDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.eeDocData[index].toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  );
                });
          } else if (type == 'NB') {
            infoNB = drug.nbDocData;
            return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: drug.nbDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.nbDocData[index].toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  );
                });
          } else if (type == 'UD') {
            infoUD = drug.udDocData;
            return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: drug.udDocData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    drug.udDocData[index].toString(),
                  );
                });
          } else {
            return Container();
          }
        } else {
          return Loading();
        }
      });
}
