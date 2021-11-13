import 'package:flutter/material.dart';
import 'package:semo_ver2/theme/colors.dart';

import 'Page/ranking_content_page.dart';

String getCategory; //카테고리 받아오기 위함

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                child: ListTile(
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  title: SizedBox(
                      height: 20,
                      child: Text(
                        //원래
                        //categories[index],
                        rank_cateogry[index], //test
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray900),
                      )),
                  onTap: () {
                    //원래
                    //getCategory = numCategory[index] + categories[index];
                    getCategory = rank_cateogry[index]; //test
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              //원래 코드
                              // RankingContentPage(
                              //   categoryName:
                              //       numCategory[index] + categories[index],
                              //   filter: '리뷰 많은 순',
                              // )),
                          //test
                          RankingContentPage(
                            categoryName: rank_cateogry[index],
                            filter: '리뷰 많은 순',
                          )),
                          );
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              //return Divider(color: gray50, thickness: 0.5,);
              return Container();
            },
            itemCount: rank_cateogry.length));
  }
}

//TEST RANK CATEGORY 확인 코드 시작
final rank_cateogry = [
  '전체',
  '감기약',
  '해열,진통,소염제(해열,근육통,치통,생리통,두통)', //괄호 안에 있는 애들이 더 쉬운 단어

  '구내염',
  '치주질환제',
  //'심장약',
  '간장약',

  '소화성궤양용제',//위장관약 중 한종류
  '소화제',//위장관약 중 한종류
  '제산제',//위장관약 중 한종류
  '지사제',//위장관약 중 한종류
  '변비약',//위장관약 중 한종류
  '정장제(유산균제)',//위장관약 중 한종류

  '치질용제',
  '피임제',
  '질염치료제',
  '혈액순환제',

  '자양강장제',//(피로회복,비타민보급) 을 넣어야하는건가
  '빈혈치료제',
  //'뇌영양제', //대부분 건강기능식품이라 넣지 않는 걸 추천하심


  '항생물질외용제', //피부질환 외용치료제
  //'부신피질호르몬외용제', //피부질환 외용치료제 ==> 이부분은 약사님한테 여쭤보고 하는걸로
  //'항진균외용제', //피부질환 외용치료제 ==> 이부분은 약사님한테 여쭤보고 하는걸로
  '흉터치료', //피부질환 외용치료제
  '여드름치료제', //피부질환 외용치료제
  '기타피부질환치료제', //피부질환 외용치료제
];