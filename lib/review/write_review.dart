import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteReview extends StatefulWidget {
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
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

  bool effectBadSelected = false;
  bool effectSosoSelected = false;
  bool effectGoodSelected = false;
  bool seYesSelected = false;
  bool seNoSelected = false;
  String id = '';
  String effect = '';
  String sideEffect = '';
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';
  bool favoriteSelected = false;
  var noFavorite = 0;

  void _registerReview() {
    Firestore.instance.collection("Reviews").add(
/*      {
        "id": "testUser",
        "effect": effect,
        "sideEffect" : sideEffect,
        "starRating": starRating,
        "effectText" : effectText,
        "sideEffectText": sideEffectText,
        "overallText": overallText,
        "favoriteSelected": favoriteSelected,
        "noFavorite": noFavorite,
        "name" : "TESTUSER",
      }*/

        {
          "SeqNum" : "21700432",
          "UID" : "testUser",
          "id": "testUser",
          "effect": effect,
          "sideEffect" : sideEffect,
          "starRating": starRating,
          "effectText" : effectText,
          "sideEffectText": sideEffectText,
          "overallText": overallText,
          "favoriteSelected": favoriteSelected,
          "noFavorite": noFavorite,
          "name" : "TESTUSER",

//          "Content": {
//            "id": "testUser",
//            "effect": effect,
//            "sideEffect" : sideEffect,
//            "starRating": starRating,
//            "effectText" : effectText,
//            "sideEffectText": sideEffectText,
//            "overallText": overallText,
//            "favoriteSelected": favoriteSelected,
//            "noFavorite": noFavorite,
//            "name" : "TESTUSER",
//          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Review',
              style: TextStyle(
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
//                      RatingBar(
//                        itemSize: 48,
//                        glow: false,
//                        initialRating: 3,
//                        minRating: 1,
//                        direction: Axis.horizontal,
//                        allowHalfRating: false,
//                        itemCount: 5,
//                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
//                        itemBuilder: (context, _) =>
//                            Icon(
//                              Icons.star,
//                              color: Colors.amber[300],
//                            ),
//                        onRatingUpdate: (rating) {
//                          starRating = rating;
//                        },
//                      ),
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text("4점 (좋아요)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)),

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
                                          color: effectBadSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectBadSelected = !effectBadSelected;
                                      if (effectBadSelected = true)
                                        effect = "bad";
                                      effectSosoSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("별로에요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: effectSosoSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectSosoSelected = !effectSosoSelected;
                                      if (effectSosoSelected = true)
                                        effect = "soso";
                                      effectBadSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),

                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("보통이에요", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                                          color: effectGoodSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectGoodSelected = !effectGoodSelected;
                                      if (effectGoodSelected = true)
                                        effect = "good";
                                      effectBadSelected  = false;
                                      effectSosoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("좋아요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                          color: seYesSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seYesSelected = !seYesSelected;
                                      if (seYesSelected = true)
                                        sideEffect = "yes";
                                      seNoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("있어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: seNoSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seNoSelected = !seNoSelected;
                                      if (seNoSelected = true)
                                        sideEffect = "no";
                                      seYesSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("없어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                    hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                child: Text("등록하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                            )
                        ),
                        onTap: () {
                          effectText = myControllerEffect.text;
                          sideEffectText = myControllerSideEffect.text;
                          overallText = myControllerOverall.text;
                          _registerReview();
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

//        body: Center(
//            child: RaisedButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Text('Go back')))


    );
  }
}





// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}
// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myControllerEffect = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myControllerEffect,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myControllerEffect.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteReview extends StatefulWidget {
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
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

  bool effectBadSelected = false;
  bool effectSosoSelected = false;
  bool effectGoodSelected = false;
  bool seYesSelected = false;
  bool seNoSelected = false;
  String id = '';
  String effect = '';
  String sideEffect = '';
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';




//  void _registerReview() {
////    firestoreInstance.collection("user").where("id", isEqualTo: "yey0811").add(
//    firestoreInstance.collection("users").add(
//        {
//          "id": id,
//          "effect": effect,
//          "sideEffect" : sideEffect,
//          "starRating": starRating,
//          "effectText" : effectText,
//          "sideEffectText": sideEffectText,
//          "overallText": overallText,
//        }).then((value){
//      print(value.documentID);
//    });
//  }

  void _registerReview() {
//    firestoreInstance.collection("user").where("id", isEqualTo: "yey0811").add(
    firestoreInstance.collection("reviews").add(
        {
          "id": id,
          "effect": effect,
          "sideEffect" : sideEffect,
          "starRating": starRating,
          "effectText" : effectText,
          "sideEffectText": sideEffectText,
          "overallText": overallText,
        }).then((value){
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Review',
              style: TextStyle(
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
                      RatingBar(
                        itemSize: 48,
                        glow: false,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        itemBuilder: (context, _) =>
                            Icon(
                              Icons.star,
                              color: Colors.amber[300],
                            ),
                        onRatingUpdate: (rating) {
                          starRating = rating;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text("4점 (좋아요)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)),

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
                                          color: effectBadSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectBadSelected = !effectBadSelected;
                                      if (effectBadSelected = true)
                                        effect = "bad";
                                      effectSosoSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("별로에요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: effectSosoSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectSosoSelected = !effectSosoSelected;
                                      if (effectSosoSelected = true)
                                        effect = "soso";
                                      effectBadSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),

                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("보통이에요", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                                          color: effectGoodSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectGoodSelected = !effectGoodSelected;
                                      if (effectGoodSelected = true)
                                        effect = "good";
                                      effectBadSelected  = false;
                                      effectSosoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("좋아요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                          color: seYesSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seYesSelected = !seYesSelected;
                                      if (seYesSelected = true)
                                        sideEffect = "yes";
                                      seNoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("있어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: seNoSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seNoSelected = !seNoSelected;
                                      if (seNoSelected = true)
                                        sideEffect = "no";
                                      seYesSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("없어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                    hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                child: Text("등록하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                            )
                        ),
                        onTap: () {
                          effectText = myControllerEffect.text;
                          sideEffectText = myControllerSideEffect.text;
                          overallText = myControllerOverall.text;
                          _registerReview();
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

//        body: Center(
//            child: RaisedButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Text('Go back')))


    );
  }
}





// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}
// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myControllerEffect = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myControllerEffect,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myControllerEffect.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteReview extends StatefulWidget {
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
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

  bool effectBadSelected = false;
  bool effectSosoSelected = false;
  bool effectGoodSelected = false;
  bool seYesSelected = false;
  bool seNoSelected = false;
  String effect = '';
  String sideEffect = '';
  double starRating =  0;
  String effectText = '';
  String sideEffectText = '';
  String overallText = '';




  void _registerReview() {
//    firestoreInstance.collection("user").where("id", isEqualTo: "yey0811").add(
    firestoreInstance.collection("users").add(
        {
          "id": "Ted",
          "effect": effect,
          "sideEffect" : sideEffect,
          "starRating": starRating,
          "effectText" : effectText,
          "sideEffectText": sideEffectText,
          "overallText": overallText,
        }).then((value){
      print(value.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Review',
              style: TextStyle(
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
                      RatingBar(
                        itemSize: 48,
                        glow: false,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        itemBuilder: (context, _) =>
                            Icon(
                              Icons.star,
                              color: Colors.amber[300],
                            ),
                        onRatingUpdate: (rating) {
                          starRating = rating;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text("4점 (좋아요)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,)),

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
                                          color: effectBadSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectBadSelected = !effectBadSelected;
                                      if (effectBadSelected = true)
                                        effect = "bad";
                                      effectSosoSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("별로에요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: effectSosoSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectSosoSelected = !effectSosoSelected;
                                      if (effectSosoSelected = true)
                                        effect = "soso";
                                      effectBadSelected = false;
                                      effectGoodSelected = false;
                                    });
                                  }
                              ),

                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("보통이에요", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                                          color: effectGoodSelected == true ? Colors.amber[300]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      effectGoodSelected = !effectGoodSelected;
                                      if (effectGoodSelected = true)
                                        effect = "good";
                                      effectBadSelected  = false;
                                      effectSosoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("좋아요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                          color: seYesSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seYesSelected = !seYesSelected;
                                      if (seYesSelected = true)
                                        sideEffect = "yes";
                                      seNoSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("있어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                          color: seNoSelected == true ? Colors.greenAccent[100]: Colors.grey[300],
                                          shape: BoxShape.circle)),
                                  onTap: () {
                                    setState((){
                                      seNoSelected = !seNoSelected;
                                      if (seNoSelected = true)
                                        sideEffect = "no";
                                      seYesSelected = false;
                                    });
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("없어요", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                    hintText: "이 제품을 복용하시면서 만족도(효과, 효능,성분 등)\n에 대한 후기를 남겨주세요 (최소 10자 이상)",
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
                                child: Text("등록하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                            )
                        ),
                        onTap: () {
                          effectText = myControllerEffect.text;
                          sideEffectText = myControllerSideEffect.text;
                          overallText = myControllerOverall.text;
                          _registerReview();
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

//        body: Center(
//            child: RaisedButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Text('Go back')))


    );
  }
}





// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}
// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myControllerEffect = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myControllerEffect,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myControllerEffect.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}



//void main() => runApp(MyHome());
//
//class MyHome extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Review Page',
//      home: FirestoreFirstDemo(),
//
//    );
//  }
//}
//




//FirestoreFirstDemoState pageState;
//
//class FirestoreFirstDemo extends StatefulWidget {
//  @override
//  FirestoreFirstDemoState createState() {
//    pageState = FirestoreFirstDemoState();
//    return pageState;
//  }
//}
//
//class FirestoreFirstDemoState extends State<FirestoreFirstDemo> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text("FirestoreFirstDemo")),
//      body: Column(
//        children: <Widget>[
//          Container(
//            height: 500,
//            child: StreamBuilder<QuerySnapshot>(
//              stream: Firestore.instance.collection("users").snapshots(),
//              builder: (BuildContext context,
//                  AsyncSnapshot<QuerySnapshot> snapshot) {
//                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
//                switch (snapshot.connectionState) {
//                  case ConnectionState.waiting:
//                    return Text("Loading...");
//                  default:
//                    return ListView(
//                      children: snapshot.data.documents
//                          .map((DocumentSnapshot document) {
////                        Timestamp tt = document["datetime"];
////                        DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
////                            tt.microsecondsSinceEpoch);
//                        return Card(
//                          elevation: 2,
//                          child: Container(
//                            padding: const EdgeInsets.all(8),
//                            child: Column(
//                              children: <Widget>[
//                                Row(
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Text(
//                                      document["id"],
//                                      style: TextStyle(
//                                        color: Colors.blueGrey,
//                                        fontSize: 17,
//                                        fontWeight: FontWeight.bold,
//                                      ),
//                                    ),
////                                    Text(
////                                      dt.toString(),
////                                      style: TextStyle(color: Colors.grey[600]),
////                                    )
//                                  ],
//                                ),
//                                Container(
//                                  alignment: Alignment.centerLeft,
//                                  child: Text(
//                                    document["effect"],
//                                    style: TextStyle(color: Colors.black54),
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        );
//                      }).toList(),
//                    );
//                }
//              },
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}*/
