import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/review.dart';
import 'package:semo_ver2/models/user.dart';


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


  Future<void> tapToRate(num rating, String uid) async {
    return await reviewCollection.doc(documentId).update({
      'starRating': rating,
      'seqNum': documentId,
      'uid': uid
    });
  }

  Future<void> getRate(num rating, String uid) async {
    return await reviewCollection.doc(documentId).update({
      'starRating': rating,
      'seqNum': documentId,
      'uid': uid
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
        entpName: doc.data()['entpName'],
        itemName: doc.data()['itemName'],
        seqNum: doc.data()['seqNum'],
        nickName: doc.data()['nickName'],
      );
    }).toList();
  }

  Query reviewQuery = FirebaseFirestore.instance.collection('Reviews');
  Stream<List<Review>> reviewsSnapshots;

  Stream<List<Review>> get reviews {
//    reviewQuery = reviewQuery.orderBy('registrationDate', descending: false);
//
//    reviewsSnapshots = reviewQuery.snapshots().map(_reviewListFromSnapshot);
//    return reviewsSnapshots;

    return reviewCollection.snapshots()
        .map(_reviewListFromSnapshot);
  }


  Stream<List<Review>> getReviews(String seqNum) {
    return reviewCollection.where("seqNum", isEqualTo: seqNum).snapshots()
        .map(_reviewListFromSnapshot);
  }

  Stream<List<Review>> getUserReviews(String uid) {
    return reviewCollection.where("uid", isEqualTo: uid).snapshots()
        .map(_reviewListFromSnapshot);
  }


  Future<bool> findUserWroteReview(String seqNum, String user) async {
    final QuerySnapshot result =
      await reviewCollection.where("seqNum", isEqualTo: seqNum).where("uid", isEqualTo: user).get();
    return result.docs.isEmpty;

//    if(reviewCollection.where("seqNum", isEqualTo: seqNum).where("uid", isEqualTo:user).snapshots()
//      .map(_reviewListFromSnapshot) != null)
//      return true;
//    else
//      return false;
  }



//  Future<bool> isUnique(newNickname) async {
//    final QuerySnapshot result =
//    await userCollection.where('nickname', isEqualTo: newNickname).get();
//    return result.docs.isEmpty;
//  }


//  Stream<List<Review>> getMyReviews(String seqNum) {
//    return getReviews(seqNum)
//        .map(_reviewListFromSnapshot);
//  }


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
        registrationDate: doc.data()['registrationDate'],
        entpName: doc.data()['entpName'],
        itemName: doc.data()['itemName'],
        seqNum: doc.data()['seqNum'],
        nickName: doc.data()['nickName'],
      );
    });
  }

  Future<void> deleteReviewData() async {
    return await reviewCollection.doc(documentId).delete();
  }

  static Future<QuerySnapshot> newgetReviews(int limit) async {
    final refReviews = FirebaseFirestore.instance.collection('Reviews').orderBy('registrationDate').limit(limit);
//        .orderBy("registrationDate", "asc")

    return refReviews.get();
  }

  static Future<QuerySnapshot> getReviewData(int limit, {DocumentSnapshot startAfter,}) async {
    final refReviews = FirebaseFirestore.instance.collection('Reviews').orderBy('registrationDate').limit(limit);

    if (startAfter == null) {
      return refReviews.get();
    } else {
      return refReviews.startAfterDocument(startAfter).get();
    }
  }

}

