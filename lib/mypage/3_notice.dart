import 'package:flutter/material.dart';
import 'package:semo_ver2/models/notice.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
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
          '공지사항',
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: StreamBuilder(
        stream: DatabaseService().noticeData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Notice> notices = snapshot.data;
            return ListView.separated(
              itemCount: notices.length,
              itemBuilder: (_, index) => Card(
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(accentColor: primary500_light_text),
                    child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      childrenPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notices[index].title,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            notices[index].dateString,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: gray300_inactivated),
                          )
                        ],
                      ),
                      children: [
                        getTextWidgets(notices[index].contents),
                      ],
                    ),
                  )),
              separatorBuilder: (_, index) => Divider(height: 0, thickness: 1),
            );
          } else if (snapshot.hasError) {
            return Text('오류 발생, 개발자에게 문의해주세요');
          } else
            return LinearProgressIndicator();
        },
      ),
    );
  }

  Widget getTextWidgets(List strings) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((item) {
          return Column(
            children: [
              Text(
                item,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        }).toList());
  }
}
