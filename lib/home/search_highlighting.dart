import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/review/phil_info.dart';
import 'home.dart';

String search;
TextStyle posRes =
        TextStyle(color: Colors.black, backgroundColor: Colors.teal[400]),
    negRes = TextStyle(color: Colors.black, backgroundColor: Colors.white);

TextSpan searchMatch(String match) {
  if (search == null || search == "")
    return TextSpan(text: match, style: negRes);
  var refinedMatch = match.toLowerCase();
  var refinedSearch = search.toLowerCase();
  if (refinedMatch.contains(refinedSearch)) {
    if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
      return TextSpan(
        style: posRes,
        text: match.substring(0, refinedSearch.length),
        children: [
          searchMatch(
            match.substring(
              refinedSearch.length,
            ),
          ),
        ],
      );
    } else if (refinedMatch.length == refinedSearch.length) {
      return TextSpan(text: match, style: posRes);
    } else {
      return TextSpan(
        style: negRes,
        text: match.substring(
          0,
          refinedMatch.indexOf(refinedSearch),
        ),
        children: [
          searchMatch(
            match.substring(
              refinedMatch.indexOf(refinedSearch),
            ),
          ),
        ],
      );
    }
  } else if (!refinedMatch.contains(refinedSearch)) {
    return TextSpan(text: match, style: negRes);
  }
  return TextSpan(
    text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
    style: negRes,
    children: [
      searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
    ],
  );
}

class SearchHighlightingScreen extends StatefulWidget {
  @override
  _SearchHighlightingScreenState createState() =>
      _SearchHighlightingScreenState();
}

class _SearchHighlightingScreenState extends State<SearchHighlightingScreen> {
//  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();

//  String _searchText = "";
//
//  _SearchHighlightingScreenState() {
//    _filter.addListener(() {
//      setState(() {
//        _searchText = _filter.text;
//        print('=== CHANGED === ');
//        print(_filter.value);
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 320,
          height: 35,
          padding: EdgeInsets.only(
            top: 0,
          ),
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              Expanded(
                  //flex: 5,
                  child: TextField(
                onChanged: (t) {
                  setState(() {
                    search = t;
                  });
                },
                focusNode: focusNode,
                style: TextStyle(fontSize: 15),
                autofocus: true,
                //controller: _filter,
                decoration: InputDecoration(
                  fillColor: Colors.white12,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel,
                        size: 20, color: Colors.teal[400]),
                    onPressed: () {
//                                  setState(() {
//                                    _filter.clear();
//                                    _searchText = "";
//                                  });
                    },
                  ),
                  hintText: '어떤 약 정보를 찾고 계세요?',
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(color: Colors.transparent)),
                ),
              )),
            ],
          ),
        ),
        leading: SizedBox(
          //width: 20,
          //height: 20,
          child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bottom_bar');
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.teal[400],
              )),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                /*
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bottom_bar');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 20,
                          )),
                    ),
                    /*
                    Container(
                      width: 320,
                      height: 35,
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              //flex: 5,
                              child: TextField(
                            onChanged: (t) {
                              setState(() {
                                search = t;
                              });
                            },
                            focusNode: focusNode,
                            style: TextStyle(fontSize: 15),
                            autofocus: true,
                            //controller: _filter,
                            decoration: InputDecoration(
                              fillColor: Colors.white12,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel,
                                    size: 20, color: Colors.teal[400]),
                                onPressed: () {
//                                  setState(() {
//                                    _filter.clear();
//                                    _searchText = "";
//                                  });
                                },
                              ),
                              hintText: '어떤 약 정보를 찾고 계세요?',
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                            ),
                          )),
                        ],
                      ),
                    ),
                    */
                  ],
                ),
                */
                SizedBox(
                  height: 7,
                ),
                Scrollbar(
                    child: SingleChildScrollView(
                  child: RichText(
                    textScaleFactor: 2,
                    text: searchMatch(
                      text,
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final text = '''
Call me Ishmael. Some years ago—never mind how long precisely—having
little or no money in my purse, and nothing particular to interest me
on shore, I thought I would sail about a little and see the watery part
of the world. It is a way I have of driving off the spleen and
regulating the circulation. Whenever I find myself growing grim about
the mouth; whenever it is a damp, drizzly November in my soul; whenever
I find myself involuntarily pausing before coffin warehouses, and
bringing up the rear of every funeral I meet; and especially whenever
my hypos get such an upper hand of me, that it requires a strong moral
principle to prevent me from deliberately stepping into the street, and
methodically knocking people’s hats off—then, I account it high time to
get to sea as soon as I can. This is my substitute for pistol and ball.
With a philosophical flourish Cato throws himself upon his sword; I
quietly take to the ship. There is nothing surprising in this. If they
but knew it, almost all men in their degree, some time or other,
cherish very nearly the same feelings towards the ocean with me.
'''
    .replaceAll("\n", " ")
    .replaceAll("  ", "");
