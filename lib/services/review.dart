import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/review.dart';


class ReviewService {

  final String documentId;
  ReviewService({ this.documentId });

  final CollectionReference reviewCollection = FirebaseFirestore.instance.collection('Reviews');

  Future<void> updateReviewData(String effect, String sideEffect, String effectText, String sideEffectText, String overallText, num starRating) async {
    return await reviewCollection.doc(documentId).update({
      'effect': effect,
      'sideEffect': sideEffect,
      'effectText': effectText,
      'sideEffectText': sideEffectText,
      'overallText': overallText,
      'starRating': starRating
    });
  }


  Future<void> updateEffect(String text) async {
    return await reviewCollection.doc(documentId).update({
      'effect': text
    });
  }

  Future<void> updateSideEffect(String text) async {
    return await reviewCollection.doc(documentId).update({
      'sideEffect': text
    });
  }

  Future<void> getEffect(String documentId) async {
    return await reviewCollection.doc(documentId).get().then((DocumentSnapshot ds) {
      return ds.data()["effect"];
    });
  }

  Future<void> getSideEffect1(String documentId) async {
    return await reviewCollection.doc(documentId).snapshots().listen((DocumentSnapshot ds) {
      ds.data()["effect"];
    });
  }

  Future<void> decreaseFavorite(String docId, String currentUserUid) async {
    return await reviewCollection.doc(docId).update({
    'favoriteSelected': FieldValue.arrayRemove([currentUserUid]),
    'noFavorite': FieldValue.increment(-1),
    });
  }

  Future<void> increaseFavorite(String docId, String currentUserUid) async {
    return await reviewCollection.doc(docId).update({
      'favoriteSelected': FieldValue.arrayUnion([currentUserUid]),
      'noFavorite': FieldValue.increment(1),
    });
  }

  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Review(
        effect: doc.data()['effect'] ?? '',
        sideEffect: doc.data()['sideEffect'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        overallText: doc.data()['overallText'] ?? '',
        //List<String> favoriteSelected = List<String>();
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        starRating: doc.data()['starRating'] ?? 0,
        noFavorite: doc.data()['noFavorite'] ?? 0,
        uid: doc.data()['uid'] ?? '',
        id: doc.data()['id'] ?? '',
         documentId: doc.id ?? '',
        registrationDate: doc.data()['registrationDate'],
      );
    }).toList();
  }

  Stream<List<Review>> get reviews {
    return reviewCollection.snapshots()
        .map(_reviewListFromSnapshot);
  }


  Stream<List<Review>> getReviews(String seqNum) {
    reviewCollection.where("seqNum", isEqualTo: seqNum).get().then((QuerySnapshot ds) {
      ds.docs.map((doc) {
        return Review(
          effect: doc.data()['effect'] ?? '',
          sideEffect: doc.data()['sideEffect'] ?? '',
          effectText: doc.data()['effectText'] ?? '',
          sideEffectText: doc.data()['sideEffectText'] ?? '',
          overallText: doc.data()['overallText'] ?? '',
          //List<String> favoriteSelected = List<String>();
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
          starRating: doc.data()['starRating'] ?? 0,
          noFavorite: doc.data()['noFavorite'] ?? 0,
          uid: doc.data()['uid'] ?? '',
          id: doc.data()['id'] ?? '',
          documentId: doc.id ?? '',
          registrationDate: doc.data()['registrationDate'],
        );
      }).toList();
    });
  }

//  Stream<List<Review>> getReviews(String seqNum) {
//    reviewCollection.where("seqNum", isEqualTo: seqNum).snapshots().listen((data) {
//      data.docs.map((doc) {
//        return Review(
//          effect: doc.data()['effect'] ?? '',
//          sideEffect: doc.data()['sideEffect'] ?? '',
//          effectText: doc.data()['effectText'] ?? '',
//          sideEffectText: doc.data()['sideEffectText'] ?? '',
//          overallText: doc.data()['overallText'] ?? '',
//          //List<String> favoriteSelected = List<String>();
////        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
//          starRating: doc.data()['starRating'] ?? 0,
//          noFavorite: doc.data()['noFavorite'] ?? 0,
//          uid: doc.data()['uid'] ?? '',
//          id: doc.data()['id'] ?? '',
//          documentId: doc.id ?? '',
//        );
//      }).toList();
//    });
//  }


  Stream<Review> getSingleReview(String documentId) {
    return reviewCollection.doc(documentId).snapshots().map((doc) {
      return Review(
        effect: doc.data()['effect'] ?? '',
        sideEffect: doc.data()['sideEffect'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        overallText: doc.data()['overallText'] ?? '',
        //List<String> favoriteSelected = List<String>();
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        starRating: doc.data()['starRating'] ?? 0,
        noFavorite: doc.data()['noFavorite'] ?? 0,
        uid: doc.data()['uid'] ?? '',
        id: doc.data()['id'] ?? '',
        documentId: doc.id ?? '',
        registrationDate: doc.data()['registrationDate']
      );
    });
  }



  Future<void> deleteReviewData() async {
    return await reviewCollection.doc(documentId).delete();
  }


}

