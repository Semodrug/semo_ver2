import 'package:flutter/material.dart';

import 'Page/ranking_content_page.dart';

String getCategory; //카테고리 받아오기 위함

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index], style: Theme.of(context).textTheme.headline5,),
                onTap: () {
                  getCategory = numCategory[index] + categories[index]; //카테고리 설정해주기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                           // TestRanking(categoryName: numCategory[index] + categories[index])
                        RankingContentPage(categoryName: numCategory[index] + categories[index])
                    ),
                    );
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: categories.length));
  }
}

//분류번호 나오면 다시 설정해야함
//약사님에게도 맡겨보기
final categories = [
  '해열.진통.소염제', '안과용제', '이비과용제',
  '호흡기관용약',
  //'호흡촉진제',
  '진해거담제',

  '소화기관용약','소화성궤양용제','건위소화제',

  //'피부연화제',

  '비타민제','비타민 A 및 D제',
  //'비타민 B1 제','비타민 B제(비타민 B1 제외)',
  '비타민 C 및 P제',
  //'비타민 E 및 K 제','혼합비타민제',
  '기타의 비타민제',

  '자양강장변질제','칼슘제','무기질제제',
  //'당류제',
  //'유기산제제','단백질아미노산제제',
  '장기제제',
  //'유아용',

  '당뇨병용제','종합대사성제제',

  '구충제',
];

final numCategory = [
  '[01140]', '[01310]', '[01320]',

  '[02200]',
  //'[02210]',
  '[02220]',

  '[02300]', '[02320]', '[02330]',

  //'[02660]',

  '[03100]', '[03110]',
  //'[03120]', '[03130]',
  '[03140]',
  //'[03150]', '[03160]',
  '[03190]',

  '[03200]', '[03210]', '[03220]',
  //'[03230]',
  //'[03240]', '[03250]',
  '[03260]',
  //'[03270]',

  '[03960]', '[03980]',

  '[06420]',
];
