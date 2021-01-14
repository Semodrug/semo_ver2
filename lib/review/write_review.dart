import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/image.dart';
import 'review.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteReview extends StatefulWidget {
  String drugItemSeq;
  double tapToRatingResult;


  WriteReview({this.drugItemSeq, this.tapToRatingResult});
//  WriteReview({@required this.drugItemSeq, this.tapToRatingResult});




  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final myControllerEffect = TextEditingController();
  final myControllerSideEffect = TextEditingController();
  final myControllerOverall = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    myControllerOverall.dispose();
    super.dispose();
  }

  final firestoreInstance = Firestore.instance;

  String id = '';
  String effect = '';
  String sideEffect = '';
  double starRating =  3;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';
  List<String> favoriteSelected = [];
  var noFavorite = 0;
  DateTime regDate = DateTime.now();
  static const _green = Color(0xff57C8B8);
  static const _grey = Color(0x95C4C4C4);



//  Stream<List<Review>> get reviews {
//    return reviewCollection.snapshots()
//        .map(_reviewListFromSnapshot);
//  }

  void _registerReview() {
    FirebaseFirestore.instance.collection("Reviews").add(
        {
          "seqNum" : widget.drugItemSeq,
          "uid" : auth.currentUser.uid,
          "id": auth.currentUser.email,
          "effect": effect,
          "sideEffect" : sideEffect,
          "starRating": starRating,
          "effectText" : effectText,
          "sideEffectText": sideEffectText,
          "overallText": overallText,
          "favoriteSelected": favoriteSelected,
          "noFavorite": noFavorite,
          "registrationDate": DateTime.now(),
//          "name" : "TESTUSER",
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Review',
              style: GoogleFonts.roboto(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.teal[200],
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                print("Go back button is clicked");
              }),
        ),

        body: ChangeNotifierProvider(
          create: (context) => Review(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                //TODO: Bring pill information
                _pillInfo(),
                _rating(),
                _effect(),
                _sideEffect(),
                _overallReview(),
                _write(),

              ],
            ),
          )
        )
    );
  }


  Widget _pillInfo() {
    //TODO: Bring pill information
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Row(
          children: <Widget>[
//            Container(
//              width: 100, height: 100,
//              color: Colors.teal[100],
//            ),
            SizedBox(
              child: DrugImage(drugItemSeq: widget.drugItemSeq),
              width: 100.0,
              height: 100.0,
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                Text("00제약", style: TextStyle(fontSize: 14, color: Colors.grey[400])),
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
    );
  }

//  Widget _starRating() {
//    return Container(
//        height: 150,
//        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//        decoration: BoxDecoration(
//            border: Border(
//                bottom:
//                BorderSide(width: 0.8, color: Colors.grey[300], ))),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
////              crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Text("약을 사용해보셨나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
//            Padding(padding: EdgeInsets.only(top: 3)),
//            RatingBar.builder(
//              itemSize: 48,
//              glow: true,
//              glowRadius: 2,
//              glowColor: _green,
//              initialRating: widget.tapToRatingResult != null ? widget.tapToRatingResult: 0,
//              minRating: 1,
//              direction: Axis.horizontal,
//              allowHalfRating: false,
//              itemCount: 5,
//              itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
//              unratedColor: _grey,
//              itemBuilder: (context, _) => Icon(
//                Icons.star,
//                color: _green,
//              ),
//              onRatingUpdate: (rating) {
//                starRating = rating;
//                print(rating);
//              },
//            ),
//            Padding(padding: EdgeInsets.only(top: 3)),
//          ],
//        )
//    );
//  }
/*  Widget _effect(context, value, child) {
    return Container(
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
                                color: value.getEffect() == "bad" ? _green: Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: () {
                          value.effectToBad();
                          effect = "bad";
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("별로에요", style: value.getEffect() == "bad"?
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
                                color: value.getEffect() == "soso" ? _green: Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState((){
                            value.effectToSoSo();
                            effect = "soso";
                          });
                        }
                    ),

                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("보통이에요", style: value.getEffect() == "soso"?
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
                                color: value.getEffect() == "good" ? _green: Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: () {
                          value.effectToGood();
                          effect = "good";
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("좋아요", style: value.getEffect() == "good"?
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                        hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
                        border: InputBorder.none
                    )),
              ),
            )
          ],
        )
    );
  }*/


  Widget _rating() {
    String starRatingText = '';
    return Container(
//          height: 150,
        padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약을 사용해보셨나요?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
            SizedBox(height: 10),
            RatingBar.builder(
              itemSize: 48,
              glow: false,
              initialRating: widget.tapToRatingResult != null ? widget.tapToRatingResult: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
//              unratedColor: Colors.grey[500],
              unratedColor: _grey,
              itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
              itemBuilder: (context, _) => Icon(
                  Icons.star,
//                color: Colors.amber[300],
                  color: _green
              ),
              onRatingUpdate: (rating) {
                starRating = rating;
                setState(() {
                  if(starRating == 0)
                    starRatingText = "선택하세요.";
                  if(starRating == 1)
                    starRatingText =  "1점 (별로에요)";
                  if(starRating == 2)
                    starRatingText =  "2점 (그저그래요)";
                  if(starRating == 3)
                    starRatingText =  "3점 (괜찮아요)";
                  if(starRating == 4)
                    starRatingText =  "4점 (좋아요)";
                  if(starRating == 5)
                    starRatingText =  "5점 (최고예요)";
                });
              },
            ),
            SizedBox(height: 10),
            Text(starRatingText)
          ],
        )
    );
  }

  Widget _effect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
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
                                color: effect == "bad" ? _green: Colors.grey[300],
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
                                color: effect == "soso" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          effect = "soso";
                          setState(()  {
                            effect = "soso";
                            print(effect);
                          });
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
                                color: effect == "good" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(()  {
                            effect = "good";
                          });
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
//              SizedBox(height: 20),
//              Padding(padding: EdgeInsets.only(top: 25)),
            _textField()
          ],
        )
    );
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 2.5),
      child: Container(
        width: 400,
//                height: 100,
        child: TextField(
            controller: myControllerEffect,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: new InputDecoration(
              hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
              border: InputBorder.none,
//                        border: OutlineInputBorder(
//                          borderRadius: const BorderRadius.all(
//                            const Radius.circular(8.0)
//                          ),
//                          borderSide: BorderSide(color:Colors.white)
//                        ),
              filled: true,
//                        fillColor: _grey,
              fillColor: Colors.grey[200],
            )),
      ),
    );
  }

  Widget _sideEffect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
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
                                color: sideEffect == "yes" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(() {
                            sideEffect = "yes";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("있어요", style: sideEffect == "yes"?
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    TextStyle(color:Colors.black87)),
                  ],
                ),
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
                                color: sideEffect == "no" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(() {
                            sideEffect = "no";
                          });
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
            _textField()
          ],
        )
    );
  }

  Widget _overallReview() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
//          height: 300,
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약에 대한 총평", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
//              Padding(padding: EdgeInsets.only(top: 25)),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
//                child: Container(
//                  width: 400,
//                  height: 100,
//                  child: TextField(
//                      controller: myControllerOverall,
////                          keyboardType: TextInputType.multiline,
//                      maxLines: null,
//                      decoration: new InputDecoration(
//                          border: InputBorder.none
////                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
////                        color: Colors.grey[400])
//                      )),
//                ),
//
//              ),
            _textField(),
            Padding(padding: EdgeInsets.only(top: 25)),
          ],
        )
    );
  }


  Widget _write() {
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.teal[300]
          ), //padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
          width: 350,
          height: 50,
          child: Center(
              child: Text("등록하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
          )
      ),
        onTap: () async {
          effectText = myControllerEffect.text;
          sideEffectText = myControllerSideEffect.text;
          overallText = myControllerOverall.text;
          _registerReview();
          await DatabaseService(itemSeq: widget.drugItemSeq).updateTotalRating(starRating);
//          await findUserWroteReview(itemSeq: widget.drugItemSeq).updateTotalRating(starRating);
//          print("HERE"+ReviewService(documentId: widget.drugItemSeq).findUserWroteReview(user.toString()).toString());
          Navigator.pop(context);
        },
    );
  }

}
