import 'package:flutter/material.dart';
import 'package:semo_ver2/drug_info/search_highlighting.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';

//다은 추가
List infoEE;
List infoNB;
List infoUD;
String storage;
String entp_name;
//추가 끝


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
          '약 정보',
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
      body:

      Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 11, 0, 0),
              child: SizedBox(
                  width: 390,
                  height: 35,
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.search, size: 20),
                        Text("어떤 약 정보를 찾고 계세요? "),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          SearchHighlightingScreen(infoEE: infoEE, infoNB: infoNB, infoUD: infoUD, storage: storage, entp_name: entp_name))
                      );
                    },
                    textColor: Colors.grey[500],
                    color: Colors.grey[200],
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 1.0,
                            color: Colors.white),
                        borderRadius: new BorderRadius.circular(8.0)),
                  )),
            ),
          ),
          Expanded(child: _specificInfo(context, widget.drugItemSeq))
        ],
      ),
    );
  }
}

// TODO: FIX OVERFLOW PROBLEM
Widget _specificInfo(BuildContext context, String drugItemSeq) {
  return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: drugItemSeq).drugData,
      builder: (context, snapshot) {
        print(drugItemSeq);
        if (snapshot.hasData) {
          Drug drug = snapshot.data;
          storage = drug.storage_method;
          entp_name = drug.entp_name;
          return SingleChildScrollView(
            child:
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '효능효과',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _drugInfo(context, drugItemSeq, 'EE'),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '용법용량',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _drugInfo(context, drugItemSeq, 'UD'),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '저장방법',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(drug.storage_method),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '회사명',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(drug.entp_name),
                    Container(
                      height: 10,
                    ),
                    Text(
                      '주의사항',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
  return StreamBuilder<SpecInfo>(
      stream: DatabaseService(itemSeq: drugItemSeq).specInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SpecInfo specInfo = snapshot.data;
          // print("SUMI's TEST: ${specInfo.eeDataList}");
          if (type == 'EE') {
            infoEE = specInfo.eeDataList;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: specInfo.eeDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                    Text(
                      specInfo.eeDataList[index].toString(),
                    );
                });
          } else if (type == 'NB') {
            infoNB = specInfo.nbDataList;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: specInfo.nbDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    specInfo.nbDataList[index].toString(),
                  );
                });
          } else if (type == 'UD') {
            infoUD = specInfo.udDataList;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: specInfo.udDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    specInfo.udDataList[index].toString(),
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
