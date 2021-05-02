import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semo_ver2/models/pharmacist_tips.dart';
import 'package:semo_ver2/services/pharmacist_tips.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PhTipsList extends StatefulWidget {
  final String drugItemSeq;
  PhTipsList(this.drugItemSeq, /*this.phTip*/);

  @override
  _PhTipsListState createState() => _PhTipsListState();
}

class _PhTipsListState extends State<PhTipsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PhTip>>(
      stream: PhTipService().getPhTips(widget.drugItemSeq),
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<PhTip> phTips = snapshot.data;
        return Column(children: [
           // Text(phTips[0].content)
        ],);
        // return ListView.builder(
        //   physics: const ClampingScrollPhysics(),
        //   shrinkWrap: true,
        //   itemCount: phTips.length,
        //   itemBuilder: (context, index) {
        //     return _buildListItem(context, phTips[index]);
        //     },
        // );
      } else
        return Container();
      },
    );
  }


  Widget _pharmacistTip() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: yellow
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "약사의 한마디",
                  style: Theme.of(context).textTheme.subtitle1,),
                TextSpan(text: '  '+'1'), //TODO: connect with DB
              ],
            ),
          ),

          Container(
              height: 15
          ),

          CarouselSlider(
            options: CarouselOptions(height: 200.0),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),

                          decoration: BoxDecoration(

                            // color: Colors.amber
                          ),
                          child: Text('text $i', style: TextStyle(fontSize: 16.0),)
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

  Widget _buildListItem(BuildContext context, PhTip phtip) {
    return Text( phtip.content);
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       RichText(
    //         text: TextSpan(
    //           style: Theme.of(context).textTheme.subtitle1.copyWith(
    //               color: yellow
    //           ),
    //           children: <TextSpan>[
    //             TextSpan(
    //               text: "약사의 한마디",
    //               style: Theme.of(context).textTheme.subtitle1,),
    //             TextSpan(text: '  '+'1'), //TODO: connect with DB
    //           ],
    //         ),
    //       ),
    //
    //       Container(
    //           height: 15
    //       ),
    //
    //       // CarouselSlider(
    //       //   options: CarouselOptions(height: 200.0),
    //       //   items: [1,2,3,4,5].map((i) {
    //       //     return Builder(
    //       //       builder: (BuildContext context) {
    //       //         return Card(
    //       //             elevation: 10,
    //       //             shape: RoundedRectangleBorder(
    //       //               borderRadius: BorderRadius.circular(8.0),
    //       //             ),
    //       //             child: Container(
    //       //                 width: MediaQuery.of(context).size.width,
    //       //                 margin: EdgeInsets.symmetric(horizontal: 5.0),
    //       //
    //       //                 decoration: BoxDecoration(
    //       //
    //       //                   // color: Colors.amber
    //       //                 ),
    //       //                 child: Text('text $i', style: TextStyle(fontSize: 16.0),)
    //       //             )
    //       //
    //       //
    //       //         );
    //       //       },
    //       //     );
    //       //   }).toList(),
    //       // )
    //     ],
    //   ),
    // );
  }
}
