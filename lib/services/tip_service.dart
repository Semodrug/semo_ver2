import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/tip.dart';

class TipService {
  final String documentId;
  TipService({this.documentId});

  final CollectionReference tipCollection = FirebaseFirestore.instance
      .collection('TestTips'); // TODO: Edit name after test
  Query tipQuery = FirebaseFirestore.instance
      .collection('TestTips'); // TODO: Edit name after test
  Stream<List<Tip>> tipsSnapshots;

  List<Tip> _tipListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Tip(
        content: doc.data()['content'] ?? '',
        uid: doc.data()['uid'] ?? '',
        pharmacistName: doc.data()['pharmacistName'] ?? '',
        pharmacistDate: doc.data()['pharmacistDate'] ?? '',
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        favoriteCount: doc.data()['favoriteCount'] ?? '',
        documentId: doc.id ?? '',
        registrationDate: doc.data()['registrationDate'] ?? '',
        seqNum: doc.data()['seqNum'] ?? '',
        entpName: doc.data()['entpName'] ?? '',
        itemName: doc.data()['itemName'] ?? '',
      );
    }).toList();
  }

  Future<void> decreaseFavorite(String docId, String currentUserUid) async {
    return await tipCollection.doc(docId).update({
      'favoriteSelected': FieldValue.arrayRemove([currentUserUid]),
      'favoriteCount': FieldValue.increment(-1),
    });
  }

  Future<void> increaseFavorite(String docId, String currentUserUid) async {
    return await tipCollection.doc(docId).update({
      'favoriteSelected': FieldValue.arrayUnion([currentUserUid]),
      'favoriteCount': FieldValue.increment(1),
    });
  }

  Stream<List<Tip>> get tips {
    return tipCollection.snapshots().map(_tipListFromSnapshot);
  }

  Stream<List<Tip>> getTips(String seqNum) {
    return tipCollection
        .where("seqNum", isEqualTo: seqNum)
        //todo: DELETE???
        .snapshots()
        .map(_tipListFromSnapshot);
  }

  // Stream<List<Review>> getUserReviews(String uid) {
  //   return reviewCollection.where("uid", isEqualTo: uid).snapshots()
  //       .map(_reviewListFromSnapshot);
  // }
  //
  //
  Future<bool> findPharmacistWroteTip(String seqNum, String user) async {
    final QuerySnapshot result = await tipCollection
        .where("seqNum", isEqualTo: seqNum)
        .where("uid", isEqualTo: user)
        .get();
    return result.docs.isEmpty;
  }

  Stream<List<Tip>> findPharmacistTip(String seqNum, String user) {
    tipQuery = tipQuery
        .where("seqNum", isEqualTo: seqNum)
        .where("uid", isEqualTo: user);
    tipsSnapshots = tipQuery.snapshots().map(_tipListFromSnapshot);
    return tipsSnapshots;
  }

  //
  //
  //
  // static Future<QuerySnapshot> getReviewData(int limit, {DocumentSnapshot startAfter,}) async {
  //   final refReviews = FirebaseFirestore.instance.collection('Reviews').orderBy('registrationDate').limit(limit);
  //
  //   if (startAfter == null) {
  //     return refReviews.get();
  //   } else {
  //     return refReviews.startAfterDocument(startAfter).get();
  //   }
  // }

}
