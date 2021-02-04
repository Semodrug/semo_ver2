import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/review/drug_info.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/dialog.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';

class MyFavorites extends StatefulWidget {
  @override
  _MyFavoritesState createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {


  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[200],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("찜",  style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        // elevation: 0,
      ),
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    List favoriteList = snapshot.data.favoriteList;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Text("찜 " + favoriteList.length.toString() + "개"),
                        ),
                        Divider(color: gray75, height: 1,),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: favoriteList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _favorite(context, favoriteList[index]);
                            }),
                      ],
                    );

                  }
                  else return Loading();
                },
              ),
            )
          ],
        )
    );
  }
  // StreamBuilder<Drug>(
  // stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
  // builder: (context, snapshot) {
  // if (snapshot.hasData) {
  Widget _favorite(context, favorite) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: favorite).drugData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Drug drug = snapshot.data;
          return GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewPage(drug.itemSeq),
                ),
              ),
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.6, color: gray75),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    //   Column(
                    //     children: [
                    //       SizedBox(
                    //         height: 64, width: 88,
                    //         child: DrugImage(drugItemSeq: favorite),
                    //       ),
                    //       Container(height: 10,),
                    //     ],
                    //   ),
                      SizedBox(
                        height: 64, width: 88,
                        child: DrugImage(drugItemSeq: favorite),
                      ),
                      Container(width: 18,),
                      Container(
                        //TODO
                        width: MediaQuery.of(context).size.width-130,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(drug.entpName,
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                        color: gray300_inactivated, fontSize: 11)),
                                Container(height: 1,),
                                Container(
                                  width: MediaQuery.of(context).size.width-180,
                                  child: Text(_shortenName(drug.itemName),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                          color: gray900, fontSize: 14)),
                                ),
                                Container(height: 2,),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: drug.totalRating * 1.0,
                                      // rating: 1.0,
                                      itemBuilder: (context, index) => Icon(
                                        // _selectedIcon ??
                                        Icons.star,
                                        color: yellow,
                                      ),
                                      itemCount: 5,
                                      itemSize: 18.0,
                                      unratedColor: gray75,
                                      //unratedColor: Colors.amber.withAlpha(50),
                                      direction: Axis.horizontal,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                    ),
                                    Container(width: 4.5,),
                                    Text(drug.totalRating.toStringAsFixed(1),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                color: gray900, fontSize: 12)),
                                    Text(" (" + drug.numOfReviews.toString() +"개)",
                                        style: Theme.of(context).textTheme.overline.copyWith(
                                            color: gray300_inactivated, fontSize: 11)),
                                  ],
                                ),
                                Container(height: 4,),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: drug.category, fromHome: 'home')),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            IconButton(
                              padding: EdgeInsets.only(right:0),
                              icon: ImageIcon(
                                AssetImage('assets/icons/small_x.png'),
                                // color: primary400_line,
                              ),

                              //icon: Icon(Icons.cancel_outlined, color: gray500, size: 19),
                              onPressed: () {
                                IYMYDialog(
                                    context: context,
                                    bodyString: '찜 목록에서 삭제하시겠어요?',
                                    leftButtonName: '취소',
                                    rightButtonName: '확인',
                                    onPressed: () async {
                                      await DatabaseService(uid: user.uid).deleteFromFavoriteList(drug.itemSeq);
                                      Navigator.pop(context);
                                    }).showWarning();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10,),
                ],
              ),
            ),
          );
        }
        else return Container();
      },
    );
  }


  String _shortenName(String drugName) {
    String newName;
    List splitName = [];

    if (drugName.contains('(')) {
      splitName = drugName.split('(');
      newName = splitName[0];
    }

    return newName;
  }
}
