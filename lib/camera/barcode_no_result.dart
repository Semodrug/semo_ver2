import 'package:flutter/material.dart';

class NoResult extends StatefulWidget {
  @override
  _NoResultState createState() => _NoResultState();
}

class _NoResultState extends State<NoResult> {
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
          '바코드 인식',
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
      body: Text('결과가 없어유'),
    );
  }
}
