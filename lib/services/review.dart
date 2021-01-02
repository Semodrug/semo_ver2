
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/review.dart';


class ReviewService {

  final String uid;
  ReviewService({ this.uid });

  final CollectionReference reviewCollection = FirebaseFirestore.instance.collection('Reviews');

//  Future<void> updateReviewData(/*TODO: parameters with pill otc code?*/) async {
//    return await reviewCollection.doc(uid/*todo: CHANGE THIS*/).set({
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
        starRating: doc.data()['starRating'] ?? '0',
        noFavorite: doc.data()['noFavorite'] ?? '0',
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

