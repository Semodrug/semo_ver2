import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/loading.dart';

class EditReview extends StatefulWidget {
//  String docId;
//  EditReview(this.docId, {Key key}) : super(key: key);

  Review review;
  EditReview(this.review);

  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController myControllerEffect = TextEditingController();
  TextEditingController myControllerSideEffect = TextEditingController();
  TextEditingController myControllerOverall = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    myControllerOverall.dispose();
    super.dispose();
  }



  Future<QuerySnapshot> future;
  void getInitialValue() {
    super.initState();
    future = FirebaseFirestore.instance.collection("Reviews").doc(widget.review.documentId).get().then((DocumentSnapshot ds) {
      //return effect = ds.data()["effect"];
    });
  }

  String effect = '';
  String sideEffect = '';
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';

  @override
  Widget build(BuildContext context) {
//TODO: USE THIS
//    TheUser user = Provider.of<TheUser>(context);

    myControllerEffect.text = widget.review.effectText;
    myControllerSideEffect.text = widget.review.sideEffectText;
    myControllerOverall.text = widget.review.overallText;

//    effect = widget.review.effect;
//    sideEffect = widget.review.sideEffect;
//    effectText = widget.review.effectText;
//    sideEffectText = widget.review.sideEffectText;
//    overallText = widget.review.effectText;
//    if(starRating == 0) starRating = widget.review.starRating;
//    myControllerEffect.text = widget.review.effectText;
//    myControllerSideEffect.text = widget.review.sideEffectText;
//    myControllerOverall.text = widget.review.overallText;



//    FirebaseFirestore.instance.collection("Reviews").doc(widget.review.documentId).get().then((DocumentSnapshot ds) {
//      effect = ds.data()["effect"];
//      sideEffect = ds.data()["sideEffect"];
//      effectText = ds.data()["effectText"];
//      sideEffectText = ds.data()["sideEffectText"];
//      overallText = ds.data()["overallText"];
//      starRating = ds.data()["starRating"];
//    });
    return StreamBuilder<Review>(
        stream: ReviewService().getSingleReview(widget.review.documentId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Review review = snapshot.data;
//            effect = review.effect;
//            sideEffect = review.sideEffect;
//            sideEffectText = review.sideEffectText;
//            overallText = review.overallText;
//            starRating = review.starRating;

            return Scaffold(
                appBar: AppBar(
                  title: Text('Write Review',
                      style: GoogleFonts.roboto(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  centerTitle: true,
                  elevation: 0.0,
//        backgroundColor: Colors.tealAccent[100],
                  backgroundColor: Colors.teal[200],
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        print("Go back button is clicked");
                      }),
                ),

                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: <Widget>[
                      //TODO: Bring pill information
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(width: 0.8, color: Colors.grey[300], ))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100, height: 100,
                                color: Colors.teal[100],
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("00제약", style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                                  Text("타이레놀", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(top: 3)),
                                      Container(
                                        width: 17, height:17,
                                        color: Colors.teal[100],
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 3)),
                                      //TODO!!!
                                      Text("4.26 (3개) ", style: TextStyle(fontSize: 15, color: Colors.black)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                      Container(
                          height: 150,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(width: 0.8, color: Colors.grey[300], ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("약을 사용해보셨나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                              Padding(padding: EdgeInsets.only(top: 3)),
                              RatingBar.builder(
                                itemSize: 48,
                                glow: false,
                                initialRating: review.starRating*1.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber[300],
                                ),
                                onRatingUpdate: (rating) {
                                  starRating = rating;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 3)),
//                        Text("$starRating", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)),
                            ],
                          )
                      ),

                      Container(
                          height: 280,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(width: 0.8, color: Colors.grey[300], ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("약의 효과는 어땠나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: effect == "bad" ? Colors.amber[300]: Colors.grey[300],
                                                  shape: BoxShape.circle)),
                                          onTap: ()  {
                                            setState(()  {
                                              effect = "bad";
                                            });
                                          }
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text("별로에요", style: effect == "bad"?
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                                      TextStyle(color:Colors.black87)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: effect == "soso" ? Colors.amber[300]: Colors.grey[300],
                                                  shape: BoxShape.circle)),
                                          onTap: ()  {
                                            effect = "soso";
                                            setState(()  {
                                              effect = "soso";
                                              print(effect);
                                            });
                                            //TODO
//                                            await ReviewService(documentId: value.documentId).updateEffect(
//                                                "soso");
                                          }
                                      ),

                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text("보통이에요", style: effect == "soso"?
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                                      TextStyle(color:Colors.black87)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: effect == "good" ? Colors.amber[300]: Colors.grey[300],
                                                  shape: BoxShape.circle)),
                                          onTap: ()  {
                                            setState(()  {
                                              effect = "good";
                                            });
                                            //TODO
//                                            await ReviewService(documentId: value.documentId).updateEffect(
//                                                "good");
                                          }
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text("좋아요", style: effect == "good"?
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                                      TextStyle(color:Colors.black87)),
                                    ],
                                  ),

                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 25)),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Container(
                                  width: 400,
                                  height: 100,
                                  child: TextField(
                                      controller: myControllerEffect,
//                          keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
//                        color: Colors.grey[400])
                                      )),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          height: 280,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(width: 0.6, color: Colors.grey[300], ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("약의 부작용은 어떤가요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
//                                                    color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                                  color: sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                                  shape: BoxShape.circle)),
                                          onTap: ()  {
                                            setState(() {
                                              sideEffect = "yes";
                                            });
                                            //TODO
//                                            await ReviewService(documentId: widget.docId).updateSideEffect(
//                                                "yes"
//                                            );
//                                    value.sideEffectToYes();

                                          }
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text("있어요", style: sideEffect == "yes"?
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                                      TextStyle(color:Colors.black87)),
                                    ],
                                  ),
//                      Padding(padding: EdgeInsets.only(left: 40)),
                                  Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                                      child: Text("VS", style: TextStyle(color: Colors.grey[700]))),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
//                                                    color: widget.review.sideEffect == "no" ? Colors.greenAccent[100]: Colors.grey[300],
                                                  color: sideEffect == "no" ? Colors.greenAccent[100]: Colors.grey[300],
                                                  shape: BoxShape.circle)),
                                          onTap: ()  {
                                            setState(() {
                                              sideEffect = "no";
                                            });
//                                            await ReviewService(documentId: widget.docId).updateSideEffect(
//                                                "no"
//                                            );
//                                    value.sideEffectToNo();

                                          }
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 10)),
                                      Text("없어요", style: sideEffect == "no"?
                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                                      TextStyle(color:Colors.black87)),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 25)),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Container(
                                  width: 400,
                                  height: 100,
                                  child: TextField(
                                      controller: myControllerSideEffect,
//                          keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none
                                      )),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          height: 300,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(width: 0.8, color: Colors.grey[300], ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("약에 대한 총평", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                              Padding(padding: EdgeInsets.only(top: 25)),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                                child: Container(
                                  width: 400,
                                  height: 100,
                                  child: Container(
                                    width: 400,
                                    height: 100,
                                    child: TextField(
                                        controller: myControllerOverall,
//                          keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
//                        color: Colors.grey[400])
                                        )),
                                  ),
                                ),

                              ),
                              Padding(padding: EdgeInsets.only(top: 25)),

                              GestureDetector(
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        color: Colors.teal[300]
                                    ), //padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                                    width: 350,
                                    height: 50,
                                    child: Center(
                                        child: Text("수정하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                                    )
                                ),
                                onTap: () async {
                              effectText = myControllerEffect.text;
                              sideEffectText = myControllerSideEffect.text;
                              overallText = myControllerOverall.text;
                                  //_registerReview();
                                  await ReviewService(documentId: widget.review.documentId).updateReviewData(
                                      effect /*?? review.effect*/,
                                      sideEffect /*?? review.sideEffect*/,
                                      myControllerEffect.text /*?? review.effectText*/,
                                      myControllerSideEffect.text /*?? review.sideEffectText*/,
                                      myControllerOverall.text /*?? review.overallText*/,
                                      starRating == 0 ? review.starRating : starRating/*?? value.starRating*/
                                  );

                                  Navigator.pop(context);

                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 35)),

                            ],
                          )
                      ),



                    ],
                  ),







                )
            );
          }
          else {
            return Loading();
          }
        }
    );




  }
}




