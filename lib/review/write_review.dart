import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';
import 'package:semo_ver2/services/db.dart';
import 'package:semo_ver2/services/review.dart';
import 'package:semo_ver2/shared/category_button.dart';
import 'package:semo_ver2/shared/image.dart';
import 'package:semo_ver2/shared/loading.dart';
import 'package:semo_ver2/theme/colors.dart';
import 'review.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WriteReview extends StatefulWidget {
  String drugItemSeq;
  double tapToRatingResult;

  WriteReview({this.drugItemSeq, this.tapToRatingResult});


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
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';
  List<String> favoriteSelected = [];
  var noFavorite = 0;
  DateTime regDate = DateTime.now();
  static const _green = Color(0xff57C8B8);
  static const _grey = Color(0x95C4C4C4);
  String _entpName =''; //약 제조사
  String _itemName =''; //약 이름

  String starRatingText = '';

  void setItemNames(itemName, entpName) {
    _itemName = itemName;
    _entpName = entpName;
  }



//  Stream<List<Review>> get reviews {
//    return reviewCollection.snapshots()
//        .map(_reviewListFromSnapshot);
//  }

  void _registerReview(nickName) {
    FirebaseFirestore.instance.collection("Reviews").add(
        {
          "seqNum" : widget.drugItemSeq,
          "uid" : auth.currentUser.uid,
          // "id": auth.currentUser.email,
          "effect": effect,
          "sideEffect" : sideEffect,
          "starRating": starRating,
          "effectText" : effectText,
          "sideEffectText": sideEffectText,
          "overallText": overallText,
          "favoriteSelected": favoriteSelected,
          "noFavorite": noFavorite,
          "registrationDate": DateTime.now(),
          "entpName" : _entpName,
          "itemName": _itemName,
          "nickName": nickName


//          "name" : "TESTUSER",
        }
    );
  }

  Widget _getNickName() {
    TheUser user = Provider.of<TheUser>(context);
    return StreamBuilder<UserData> (
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          return Text(
            userData.nickname
          );
        }
        else
          return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);
    return Scaffold(
      backgroundColor: gray0_white,
        appBar: AppBar(
          title: Text('리뷰 쓰기',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(
                  color: gray800, fontSize: 16)) ,
          // centerTitle: true,
          //elevation: 0.0,
          backgroundColor: gray0_white,
          leading: IconButton(
              icon: Icon(Icons.close, color: primary300_main),
              onPressed: () {
                Navigator.pop(context);
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
        padding: EdgeInsets.fromLTRB(20,10,20,10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Row(
          children: <Widget>[
            SizedBox(
              child: DrugImage(drugItemSeq: widget.drugItemSeq),
              width: 100.0,
              height: 100.0,
            ),
            Container(width:15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<Drug>(
                    stream: DatabaseService(itemSeq: widget.drugItemSeq).drugData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Drug drug = snapshot.data;
                        setItemNames(drug.itemName, drug.entpName);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drug.entpName,
                                style: Theme.of(context).textTheme.overline.copyWith(
                                    color: gray300_inactivated, fontSize: 10)),
                            Text(drug.itemName,
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                    color: gray900)
                                ),
                            Container(height: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  itemSize: 16,
                                  initialRating: drug.totalRating ,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: gray75,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star, color: Colors.amber[300],
                                  ),
                                ),
                                Container(width:5),
                                Text(drug.totalRating.toStringAsFixed(2),
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: gray900, fontSize: 12)
                                    ),
                                Container(width:3),
                                Text("("+drug.numOfReviews.toStringAsFixed(0)+"개)",
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                        color: gray300_inactivated, fontSize: 10)
                                ),
                              ],
                            ),
                            CategoryButton(str: drug.category)
                          ],
                        );
                        // Text(drug.totalRating.toStringAsFixed(2)+drug.numOfReviews.toStringAsFixed(0) + "개",
                        //   style: TextStyle(
                        //     fontSize: 16.5,
                        //     fontWeight: FontWeight.bold,
                        //   ));
                      } else
                        return Loading();
                    }),
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
    return Container(
//          height: 150,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약을 사용해보셨나요?",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: gray900, fontSize: 16)
                ),
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
                  color: primary300_main
              ),
              onRatingUpdate: (rating) {
                starRating = rating;
                setState(() {
                  //if(starRating == 0)
                  //  starRatingText = "선택하세요.";
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
            Text(starRatingText,
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: primary600_bold_text, fontSize: 12)

            ),
          ],
        )
    );
  }

  Widget _effect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약의 효과는 어땠나요?",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: gray900, fontSize: 16)
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.sentiment_dissatisfied,
                              size: 30,
                            color: Color(0xffDADADA),),
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
                    Theme.of(context).textTheme.caption.copyWith(
                        color: primary600_bold_text, fontSize: 12) :
                    Theme.of(context).textTheme.caption.copyWith(
                        color: gray0_white, fontSize: 12),)
                  ],
                ),
                Container(width:30),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                          child: Icon(Icons.sentiment_dissatisfied,
                              color: Color(0xffDADADA),
                            size: 30,),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: effect == "soso" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          effect = "soso";
                          setState(()  {
                            effect = "soso";
                          });
                        }
                    ),

                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("보통이에요", style: effect == "soso"?
                    Theme.of(context).textTheme.caption.copyWith(
                          color: primary600_bold_text, fontSize: 12) :
                    Theme.of(context).textTheme.caption.copyWith(
                        color: gray0_white, fontSize: 12),)
                  ],
                ),
                Container(width:30),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(Icons.sentiment_satisfied,
                              color: Color(0xffDADADA),
                            size:30),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: effect == "good" ? _green : Colors.grey[300],
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(()  {
                            effect = "good";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)) ,
                    Text("좋아요", style: effect == "good"?
                    Theme.of(context).textTheme.caption.copyWith(
                        color: primary600_bold_text, fontSize: 12) :
                    Theme.of(context).textTheme.caption.copyWith(
                        color: gray0_white, fontSize: 12),)
                  ],
                ),

              ],
            ),
//              SizedBox(height: 20),
//              Padding(padding: EdgeInsets.only(top: 25)),
            _textField("effect", myControllerEffect)
          ],
        )
    );
  }

  Widget _textField(String type, txtController) {
    String hintText;
    if (type == "effect")
      hintText =  "효과에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if(type == "sideEffect")
      hintText = "부작용에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if(type == "overall")
      hintText = "전체적인 만족도에 대한 후기를 남겨주세요\n(최소 10자 이상)\n";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal:0),
      child: Container(
        child: TextField(
            maxLength: 500,
            controller: txtController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: new InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: gray750_activated, ),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: gray75),
                borderRadius: const BorderRadius.all(
                    const Radius.circular(4.0)
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ))
      ),
    );
  }

  Widget _sideEffect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.6, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약의 부작용은 없었나요?",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: gray900, fontSize: 16)
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(Icons.sentiment_dissatisfied,
                              size: 30,
                              color: Color(0xffDADADA),),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
//                              color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "yes" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: ()  {
                          setState(() {
                            sideEffect = "yes";
                          });
                        }
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("부작용 있어요", style: sideEffect == "yes"?
                    Theme.of(context).textTheme.caption.copyWith(
                        color: primary600_bold_text, fontSize: 12) :
                    Theme.of(context).textTheme.caption.copyWith(
                        color: gray0_white, fontSize: 12),)
                    // Text("있어요", style: sideEffect == "yes"?
                    // TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    // TextStyle(color:Colors.black87)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Text("VS",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: gray500, fontSize: 14)),
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(Icons.sentiment_satisfied,
                                color: Color(0xffDADADA),
                                size:30),
                            width: 40,
                            height: 40,
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
                    Text("부작용 없어요", style: sideEffect == "no"?
                    Theme.of(context).textTheme.caption.copyWith(
                        color: primary600_bold_text, fontSize: 12) :
                    Theme.of(context).textTheme.caption.copyWith(
                        color: gray0_white, fontSize: 12),)
                    // Text("없어요", style: sideEffect == "no"?
                    // TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    // TextStyle(color:Colors.black87)),
                  ],
                ),
              ],
            ),
            _textField("sideEffect", myControllerSideEffect)
          ],
        )
    );
  }

  Widget _overallReview() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
//          height: 300,
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(width: 0.8, color: Colors.grey[300], ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("약에 대한 총평",
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: gray900, fontSize: 16)
            ),
            _textField("overall", myControllerOverall),
            Padding(padding: EdgeInsets.only(top: 25)),
          ],
        )
    );
  }


  Widget _write() {
    TheUser user = Provider.of<TheUser>(context);
    String _warning = '';
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,40),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.teal[300]
            ), //padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
//            width: 350,
            height: 50,
            child: Center(
                child: Text("등록하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
            )
        ),
      ),
      onTap: () async {
        effectText = myControllerEffect.text;
        sideEffectText = myControllerSideEffect.text;
        overallText = myControllerOverall.text;



        if(overallText.length < 10) _warning = "총평 리뷰를 10자 이상 작성해주세요";
        if(sideEffectText.length < 10) _warning = "부작용에 대한 리뷰를 10자 이상 \n작성해주세요";
        if(sideEffect.isEmpty) _warning = "부작용 별점을 등록해주세요";
        if(effectText.length < 10) _warning = "효과에 대한 리뷰를 10자 이상 작성해주세요";
        if(effect.isEmpty) _warning = "효과 별점을 등록해주세요";
        // if(starRating == 0) _warning = "별점을 등록해주세요";
        if(starRatingText.isEmpty) _warning = "별점을 등록해주세요";




        if(effectText.length < 10 || sideEffectText.length < 10 || overallText.length < 10 || starRatingText.isEmpty||
          effect.isEmpty || effect.isEmpty)
          Fluttertoast.showToast(
              msg: _warning,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        else {
          //await ReviewService(documentId: review.documentId).decreaseFavorite(review.documentId, auth.currentUser.uid);
          String nickName = await DatabaseService(uid: user.uid).getNickName();
          _registerReview(nickName);
          Navigator.pop(context);
        }
//          await findUserWroteReview(itemSeq: widget.drugItemSeq).updateTotalRating(starRating);
//          print("HERE"+ReviewService(documentId: widget.drugItemSeq).findUserWroteReview(widget.drugItemSeq, user.toString()).toString());

      },
    );
  }

}
