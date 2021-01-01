
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

}

