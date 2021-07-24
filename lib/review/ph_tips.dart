import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/models/pharmacist_tips.dart';
import 'package:semo_ver2/services/pharmacist_tips.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class PhTipsList extends StatefulWidget {
  final String drugItemSeq;
  PhTipsList(this.drugItemSeq, /*this.phTip*/);

  @override
  _PhTipsListState createState() => _PhTipsListState();
}

class _PhTipsListState extends State<PhTipsList> {
  CollectionReference users = FirebaseFirestore.instance.collection('PharmacistTips');

  Future<void> addUser() {
    return users
        .add({
      'content': "매일 계속 사용하는것보다 3일 정도 사용하면 하루 쯤 쉬었다가 사용하는게 더 나아요 참고하세요", // John Doe
      'name': "세모", // Stokes and Sons
      'regDate': DateTime.now(),
      'seqNum': "200209700",
      //
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<PhTip>>(
      stream: PhTipService().getPhTips(widget.drugItemSeq),
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<PhTip> phTips = snapshot.data;
        return _pharmacistTip(phTips);
      } else
        return Container();
      },
    );
  }



  Widget _pharmacistTip(List<PhTip> phTips) {
    // var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      // margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              child: Icon(
                Icons.arrow_back,),
            onTap: addUser,
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1.copyWith(color: yellow),
              children: <TextSpan>[
                TextSpan(
                  text: "약사들의 한마디",
                  style: Theme.of(context).textTheme.subtitle1,),
                TextSpan(text: '  '+phTips.length.toString()), //TODO: connect with DB
              ],
            ),
          ),

          Container(height: 15),

          CarouselSlider(
            options: CarouselOptions(
                height: 200.0,
              // enlargeCenterPage: true,
              enableInfiniteScroll: false,
              // viewportFraction: 0.7,
            ),
            items: phTips.map((tip) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      elevation: 5,
                      shadowColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height:width*0.02),
                                Text(tip.name+" 약사", style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14, color: gray700)),
                                SizedBox(height: 2),
                                Text(DateFormat('yyyy.MM.dd').format(tip.regDate.toDate()), style: Theme.of(context).textTheme.caption),
                                SizedBox(height: 12),
                                Flexible(
                                  child: Text(
                                    tip.content,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    // overflow: TextOverflow.ellipsis
                                  ),
                                ),




                              ],
                            ),
                          )
                      )


                  );
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }


}
