import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

//TODO: 검색 바 UI 수정
//TODO: 효능효과 밑의 간격!
//TODO: 글씨 색이 뭔가 흐릿
String search;
TextStyle posRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Colors.grey[500],
        backgroundColor: warning.withOpacity(0.3)),
    negRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey[500],
        backgroundColor: Colors.white);

TextSpan searchMatch(String match) {
  if (search == null || search == "")
    return TextSpan(text: match, style: negRes);
  var refinedMatch = match; // .toLowerCase();
  var refinedSearch = search; // .toLowerCase();
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
  final List infoEE;
  final List infoNB;
  final List infoUD;
  String storage = '';
  String entp_name = '';

  SearchHighlightingScreen(
      {this.infoEE, this.infoNB, this.infoUD, this.storage, this.entp_name});

  @override
  _SearchHighlightingScreenState createState() =>
      _SearchHighlightingScreenState();
}

class _SearchHighlightingScreenState extends State<SearchHighlightingScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();

  _SearchHighlightingScreenState() {
    _filter.addListener(() {
      setState(() {
        search = _filter.text;
      });
    });
  }

  Widget _changeToText(BuildContext context, List notYetText) {
    String textFinish = '';
    for (int i = 0; i < notYetText.length; i++) {
      textFinish = textFinish + notYetText[i].toString() + '\n';
    }
    //잘라져 있는 형태라면 이부분을 없애면 될 거 같다.
    textFinish = textFinish.replaceAll(" \"", "\n\"");

    return RichText(textScaleFactor: 1.08, text: searchMatch(textFinish));
  }

  Widget _alreadyText(BuildContext context, String text) {
    return RichText(textScaleFactor: 1.08, text: searchMatch(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  onChanged: (t) {
                    setState(() {
                      search = t;
                    });
                  },
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 15),
                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon:
                          Icon(Icons.cancel, size: 20, color: Colors.teal[400]),
                      onPressed: () {
                        setState(() {
                          _filter.clear();
                          search = "";
                        });
                      },
                    ),
                    //hintText: '어떤 약 정보를 찾고 계세요?',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
                )),
              ],
            ),
          ),
        ),
        //Text('약 정보', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),),
        leading: SizedBox(
          //width: 20,
          //height: 20,
          child: IconButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/bottom_bar');
                Navigator.pop(context);
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  Scrollbar(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '효능효과',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            _changeToText(context, widget.infoEE),
                            Divider(height: 30),
                            Text('용법용량',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            _changeToText(context, widget.infoUD),
                            Divider(height: 30),
                            Text('저장방법',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            _alreadyText(context, widget.storage),
                            Divider(height: 30),
                            Text('회사명',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            _alreadyText(context, widget.entp_name),
                            Divider(height: 30),
                            Text('주의사항',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            _changeToText(context, widget.infoNB),
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// for test
final text = '''
Call me Ishmael. Some years ago—never mind how long precisely—having
of the world. '''
    .replaceAll("", "\n")
    .replaceAll("  ", "");
