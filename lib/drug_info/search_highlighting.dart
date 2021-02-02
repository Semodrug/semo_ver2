import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';


String search;
TextStyle posRes =
        TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF666666),
        backgroundColor: warning.withOpacity(0.3)
        ),

    negRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: gray600,//Color(0xFF666666),
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
    textFinish = textFinish.substring(0, textFinish.length - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: RichText(textScaleFactor: 1.08,
          text: searchMatch(textFinish),


      ),
    );
  }

  Widget _alreadyText(BuildContext context, String text) {
    return RichText(textScaleFactor: 1.08, text: searchMatch(text));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
          '약 정보 전체보기',
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [_searchBar(context)],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Scrollbar(
                      child: Container(
                        height: height - 80, //440.0,
                        child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '효능효과',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                         // SizedBox(height: 5,),
                          _changeToText(context, widget.infoEE),
                          Divider(height: 16),
                          Text('용법용량',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          //SizedBox(height: 5,),
                          _changeToText(context, widget.infoUD),
                          Divider(height: 16),
                          Text('저장방법',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                         // SizedBox(height: 5,),
                          _alreadyText(context, widget.storage),
                          Divider(height: 16),
                          Text('회사명',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                         // SizedBox(height: 5,),
                          _alreadyText(context, widget.entp_name),
                          Divider(height: 16),
                          Text('주의사항',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                         // SizedBox(height: 5,),
                          _changeToText(context, widget.infoNB),
                        ],
                    ),
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

  Widget _searchBar(BuildContext context) {

    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 35,
          height: 35,
          decoration: BoxDecoration(
              color: gray50,
              border: Border.all(
                  style: BorderStyle.solid,
                  width: 1.0,
                  color: gray200),
              borderRadius: BorderRadius.circular(8.0)
          ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //   color: Colors.grey[200],
          // ),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                    onChanged: (t) {
                      setState(() {
                        search = t;
                      });
                    },
                    cursorColor: Colors.teal[400],
                    focusNode: focusNode,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
                    autofocus: true,
                    controller: _filter,
                    decoration: InputDecoration(
                      //여기서 언덜라인 없애주기
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      fillColor: Colors.white12,
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(
                          Icons.cancel,
                          size: 20,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                          });
                        },
                      ),
                      hintText: '어떤 약정보를 찾고 계세요?',
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  )

              ),
            ],
          ),
        ),
        //TODO:수미가 원하는 디자인
        //Spacer(),
        // SizedBox(
        //   width: 50,
        //   child: FlatButton(
        //       padding: EdgeInsets.only(right: 10),
        //       onPressed: () {
        //         Navigator.pop(context);
        //         //Navigator.pushNamed(context, '/bottom_bar');
        //       },
        //       child: Text('취소')),
        // )
      ],
    );
  }

}
