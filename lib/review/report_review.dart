import 'package:flutter/material.dart';

class ReportReview extends StatefulWidget {
  @override
  _ReportReviewState createState() => _ReportReviewState();
}

class _ReportReviewState extends State<ReportReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //TODO
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.teal[200],
            ),
            onPressed: () async {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          '약 정보',
          style: Theme.of(context).textTheme.subtitle1,
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
      body: Center(child: Text("신고하기"))
    );
  }
}
