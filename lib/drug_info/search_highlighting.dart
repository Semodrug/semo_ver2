import 'package:flutter/material.dart';
import 'package:semo_ver2/shared/customAppBar.dart';
import 'package:semo_ver2/theme/colors.dart';

String search;
TextStyle posRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: gray600,
        height: 1.6,
        backgroundColor: warning.withOpacity(0.3)),
    negRes = TextStyle(
        fontFamily: 'NotoSansKR',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: gray600,
        height: 1.6,
        //Color(0xFF666666),
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
      child: RichText(
        textScaleFactor: 1.00,
        text: searchMatch(textFinish),
      ),
    );
  }

  Widget _alreadyText(BuildContext context, String text) {
    return RichText(textScaleFactor: 1.00, text: searchMatch(text));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBarWithGoToBack('약 정보 전체보기', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _searchBar(context),
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
                    //padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    height: height - 80, //440.0,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '효능효과',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                _changeToText(context, widget.infoEE),
                              ],
                            ),
                          ),
                          // SizedBox(height: 5,),
                          Divider(height: 16),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '용법용량',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                _changeToText(context, widget.infoUD),
                              ],
                            ),
                          ),
                          //SizedBox(height: 5,),
                          Divider(height: 16),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '저장방법',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                _alreadyText(context, widget.storage),
                              ],
                            ),
                          ),
                          // SizedBox(height: 5,),
                          Divider(height: 16),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '회사명',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                _alreadyText(context, widget.entp_name),
                              ],
                            ),
                          ),
                          // SizedBox(height: 5,),
                          Divider(height: 16),
                          Container(
                            //height: 1000,//MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '주의사항',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                _changeToText(context, widget.infoNB),
                              ],
                            ),
                          ),
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
          height: 33,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: gray75,
          ),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                onChanged: (t) {
                  setState(() {
                    search = t;
                  });
                },
                cursorColor: primary400_line,
                focusNode: focusNode,
                style: Theme.of(context).textTheme.bodyText2,
                autofocus: false,
                controller: _filter,
                decoration: InputDecoration(
                    fillColor: gray50,
                    filled: true,
                    prefixIcon: SizedBox(
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                        child: Image.asset('assets/icons/search_grey.png'),
                      ),
                    ),
                    suffixIcon:  _filter.text.length > 0 ?  IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: 20,
                          color: gray300_inactivated,
                        ))
                        : null,
                    hintText: '어떤 약정보를 찾고 계세요?',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray300_inactivated),
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: gray300_inactivated,
                        ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: gray75)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: gray75)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 1.0,
                            color: gray75),
                        borderRadius: BorderRadius.circular(8.0))),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
