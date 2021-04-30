import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/pharmacist_tips.dart';

class PhTipService {

  final String documentId;
  PhTipService({ this.documentId });

  final CollectionReference phTipsCollection = FirebaseFirestore.instance.collection('PharmacistTips');
  Query phTipsQuery = FirebaseFirestore.instance.collection('PharmacistTips');
  Stream<List<PhTip>> PhTipSnapshots;

  List<PhTip> _PhTipListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PhTip(
        content: doc.data()['content'] ?? '',
        name: doc.data()['name'] ?? '',
        regDate: doc.data()['regDate'] ?? '',
        seqNum: doc.data()['seqNum'] ?? '',
      );
    }).toList();
  }


  // Stream<List<PhTip>> get PhTips {
  //   return phTipsCollection.snapshots()
  //       .map(_PhTipListFromSnapshot);
  // }


  Stream<List<PhTip>> getPhTips(String seqNum) {
    return phTipsCollection
        .where("seqNum", isEqualTo: seqNum)
        .snapshots()
        .map(_PhTipListFromSnapshot);
  }

  // Stream<List<Review>> getUserReviews(String uid) {
  //   return reviewCollection.where("uid", isEqualTo: uid).snapshots()
  //       .map(_reviewListFromSnapshot);
  // }
  //
  //
  // Future<bool> findUserWroteReview(String seqNum, String user) async {
  //   final QuerySnapshot result =
  //     await reviewCollection.where("seqNum", isEqualTo: seqNum).where("uid", isEqualTo: user).get();
  //   return result.docs.isEmpty;
  // }
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

