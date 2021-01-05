import 'package:flutter/material.dart';
import 'package:semo_ver2/ranking/test_ranking.dart';

String BigCategory = '';


class RankingExpansionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryList(data[index], context),
      ),
    );
  }
}

class Category {
  //--- Name Of Drug
  final String name;
  final List<Category> children;

  Category(this.name, [this.children = const <Category>[]]);
}

final List<Category> data = <Category>[
  //TODO: 하드 코딩 되어있는데 분류번호 별로 나눠서 해주어야 함
  //TODO: 추후에 카테고리가 지정이 되면 되게끔 하자
  Category('감기', <Category>[
    Category('감기약')]),

  Category('소화기계약', <Category>[
    Category('전체'),
    Category('배탈1'),
    Category('소화2'),
    Category('속쓰림3')
  ]),
  Category('해열 진통 소염', <Category>[
    Category('전체'),
    Category('해열제'),
    Category('두통약'),
    Category('관절염약'),
    Category('근육통약'),
    Category('타박상약'),
  ]),
];

class CategoryList extends StatelessWidget {

  const CategoryList(this.category, this.context );

  final Category category;
  final BuildContext context;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildTiles(category);
  }

  Widget _buildTiles(Category root) {
   // List listOfCategory = ['감기', '소화기계약', '해열 진통 소염'];
    if (root.children.isEmpty) {

     // print('       ');
      //print(root.name);
      //todo: 전체를 눌렀을 때, 전체를 포함한 그 큰카테고리들을 넘겨주어야 하는데 그 값을 찾는 게 어려움
      if(root.name != '전체'){
        return ListTile(
          title: Text(root.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestRanking(categoryName: root.name,)),
            );
            //print('${root.name}');
          },
        );
      }
      else {
        return ListTile(
          title: Text(root.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestRanking(categoryName: root.name,)),
            );
            //print('전체가 맞나 ? ${root.name}');
            //print('$BigCategory');
          },
        );
      }
    }
    else {
      // print(root.name);
      BigCategory = root.name;
      //print('in ExpandTile in BC ==> $BigCategory');
      //listOfCategory[index] = root.name;
      return ExpansionTile(
        key: PageStorageKey<Category>(root),
        title: Text(root.name),
        //children: root.children.map<Widget>(_buildTiles).toList(),
        children: root.children
            .map(
          _buildTiles,
        )
            .toList(),
      );
    }
  }
}
