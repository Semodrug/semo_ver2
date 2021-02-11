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
import 'package:semo_ver2/shared/customAppBar.dart';
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
        appBar: CustomAppBarWithGoToBack('찜', Icon(Icons.arrow_back), 3),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List favoriteList = snapshot.data.favoriteList;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child:
                              Text("찜 " + favoriteList.length.toString() + "개"),
                        ),
                        Divider(
                          color: gray75,
                          height: 1,
                        ),

                        favoriteList.length == 0 ?
                        Container(
                            height: 310,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                ),
                                Image.asset(
                                  'assets/images/no_review.png',
                                ),
                                Container(
                                  height: 10,
                                ),
                                Text("아직 찜한 약 없어요")
                              ],
                            ))
                        :
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: favoriteList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _favorite(context, favoriteList[index]);
                            }),
                      ],
                    );
                  } else
                    return Loading();
                },
              ),
            )
          ],
        ));
  }
  Widget _favorite(context, favorite) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<Drug>(
      stream: DatabaseService(itemSeq: favorite).drugData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                      Container(
                        width: 88,
                        child: DrugImage(drugItemSeq: favorite),
                      ),
                      Container(
                        width: 18,
                      ),
                      Container(
                        //TODO
                        width: MediaQuery.of(context).size.width - 130,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(drug.entpName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                            color: gray300_inactivated,
                                            fontSize: 11)),
                                Container(
                                  height: 1,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Text(_shortenName(drug.itemName),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color: gray900, fontSize: 14)),
                                ),
                                Container(
                                  height: 2,
                                ),
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
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                    ),
                                    Container(
                                      width: 4.5,
                                    ),
                                    Text(drug.totalRating.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(
                                                color: gray900, fontSize: 12)),
                                    Text(
                                        " (" +
                                            drug.numOfReviews.toString() +
                                            "개)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline
                                            .copyWith(
                                                color: gray300_inactivated,
                                                fontSize: 11)),
                                  ],
                                ),
                                Container(
                                  height: 4,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: drug.category,
                                          fromHome: 'home')),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            IconButton(
                              padding: EdgeInsets.only(right: 0),
                              icon: Icon(Icons.close, color: gray500,
                              size: 18),
                              // icon: ImageIcon(
                              //   AssetImage('assets/icons/small_x.png'),
                              //   // color: primary400_line,
                              // ),
                              onPressed: () {
                                _showDeleteDialog(drug, user);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }

  Future<void> _showDeleteDialog(drug, user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              /* BODY */
              Text("찜 목록에서 삭제하시겠어요?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* LEFT ACTION BUTTON */
                  ElevatedButton(
                    child: Text(
                      "취소",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  /* RIGHT ACTION BUTTON */
                  ElevatedButton(
                      child: Text(
                        "확인",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        await DatabaseService(uid: user.uid)
                            .deleteFromFavoriteList(drug.itemSeq);
                        Navigator.pop(context);

                        //OK Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Icon(Icons.check, color: primary300_main),
                                  SizedBox(height: 16),
                                  /* BODY */
                                  Text(
                                    "찜 목록에서 삭제되었습니다",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: gray700),
                                  ),
                                  SizedBox(height: 16),
                                  /* BUTTON */
                                  ElevatedButton(
                                      child: Text(
                                        "확인",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(color: primary400_line),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: Size(260, 40),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 0,
                                          primary: gray50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(color: gray75))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      })
                ],
              )
            ],
          ),
        );
      },
    );

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
// //          title: Center(child: Text('AlertDialog Title')),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Center(child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold))),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     TextButton(
//                       child: Text('취소', style: TextStyle(color: Colors.black38, fontSize: 17, fontWeight: FontWeight.bold)),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     TextButton(
//                       child: Text('삭제',style: TextStyle(color: Colors.teal[00], fontSize: 17, fontWeight: FontWeight.bold)),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         await ReviewService(documentId: record.documentId).deleteReviewData();
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
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
