import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/test_ranking.dart';

/*
class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CategoryList()
    );
  }
}

final categories = [
  '감기', '소화', '진통제'
];


class CategoryList extends StatelessWidget {

  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return _buildTiles(context);
//  }

  Widget build(BuildContext context) {


    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestRanking(categoryName: categories[index])),
              );
              //print('${root.name}');
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: categories.length);
  }

}
*/

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TestRanking(categoryName: categories[index])),
                  );
                  print(categories[index]);
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
final categories = ['감기', '소화', '진통제'];
