
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/review.dart';


class ReviewService {

//  final String uid;
//  ReviewService({ this.uid });

  final CollectionReference reviewCollection = FirebaseFirestore.instance.collection('Reviews');

  //    widget.record.reference.update({
  Future<void> updateReviewData(QuerySnapshot snapshot) async {
    return await snapshot.docs.map((doc) {
      doc.reference.update({
       'effect':  doc.data()['effect'],
      'sideEffect': doc.data()['sideEffect'],
      'effectText': doc.data()['effectText'],
      'sideEffectText': doc.data()['sideEffectText'],
      'overallText': doc.data()['overallText'],
      //List<String> favoriteSelected = List<String>();
      'favoriteSelected': doc.data()['favoriteSelected'],
      'starRating': doc.data()['starRating'],
      'noFavorite': doc.data()['noFavorite'],
      });
    });


//    doc(uid/*todo: CHANGE THIS*/).set({
//      //Todo: set data using parameters
//      'effect': effect,
//      'sideEffect': sideEffect,
//      'effectText': effectText,
//      'sideEffectText': sideEffectText,
//      'overallText': overallText,
//      //List<String> favoriteSelected = List<String>();
//      'favoriteSelected': favoriteSelected,
//      'starRating': starRating,
//      'noFavorite': noFavorite,
//    });
  }


//  final record = Record.fromSnapshot(data);
//  Record.fromSnapshot(DocumentSnapshot snapshot)
//      : this.fromMap(snapshot.data(), reference: snapshot.reference);
//  Record.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['name'] != null),
//        assert(map['effectText'] != null),
//        assert(map['sideEffectText'] != null),
//        assert(map['overallText'] != null),
//        assert(map['id'] != null),
//        assert(map['noFavorite'] != null),
//        assert(map['uid'] != null),
//
//        name = map['name'],
//        effectText = map['effectText'],
//        sideEffectText = map['sideEffectText'],
//        overallText = map['overallText'],
//        id = map['id'],
////        favoriteSelected = map['favoriteSelected'],
////        favoriteSelected = favoriteSelected.map((item){return item.toMap();}).toList(),
//        noFavorite = map['noFavorite'],
//        uid = map['uid'],
//        effect = map['effect'],
//        sideEffect = map['sideEffect'],
//        starRating = map['starRating'];
//  void _registerReview() {
//    widget.record.reference.update({
//      "effect": effect,
//      "sideEffect" : sideEffect,
//      "starRating": starRating,
//      "effectText" : effectText,
//      "sideEffectText": sideEffectText,
//      "overallText": overallText,
//    });
//  }

  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Review(
        effect: doc.data()['effect'] ?? '',
        sideEffect: doc.data()['sideEffect'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        overallText: doc.data()['overallText'] ?? '',
        //List<String> favoriteSelected = List<String>();
//        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        starRating: doc.data()['starRating'] ?? 0,
        noFavorite: doc.data()['noFavorite'] ?? 0,
        uid: doc.data()['uid'] ?? '',
        id: doc.data()['id'] ?? '',
      );
    }).toList();
  }

  Stream<List<Review>> get reviews {
    return reviewCollection.snapshots()
        .map(_reviewListFromSnapshot);
  }






/*return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Loading");

        length = snapshot.data.documents.length;
//        snapshot.data.documents.map((DocumentSnapshot document) {
//           sum += document.data()['starRating'];
//        });

        snapshot.data.docs.forEach((doc) {
          sum += doc["starRating"];
        });
        ratingResult = sum/length;
        print(ratingResult);


        snapshot.data.docs.forEach((doc) {
          doc["effect"] == "good" ? effectGood++ :
          doc["effect"] == "soso" ? effectSoso++ : effectBad ++;
        });

        snapshot.data.docs.forEach((doc) {
          doc["sideEffect"] == "yes" ? sideEffectYes++ : sideEffectNo++;
        });

 */

}

