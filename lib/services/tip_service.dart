import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/report_tip.dart';
import 'package:semo_ver2/models/tip.dart';

class TipService {
  final String documentId;
  TipService({this.documentId});

  final CollectionReference tipCollection = FirebaseFirestore.instance
      .collection('TestTips'); // TODO: Edit name after test
  final CollectionReference reportTipCollection =
      FirebaseFirestore.instance.collection('ReportTip');

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

  Stream<Tip> getSingleTip(String documentId) {
    return tipCollection.doc(documentId).snapshots().map((doc) {
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
    });
  }

  Future<void> updateTipData(String content) async {
    return await tipCollection.doc(documentId).update({
      'content': content,
    });
  }

  Future<void> deleteTipData() async {
    return await tipCollection.doc(documentId).delete();
  }

  Future<void> reportTip(tip, report, reporterUid) async {
    String reportContent;
    if (report == 1) reportContent = "광고, 홍보 / 거래시도";
    if (report == 2) reportContent = "욕설, 음란어 사용";
    if (report == 3) reportContent = "약과 무관한 리뷰 작성";
    if (report == 4) reportContent = "개인 정보 노출";
    if (report == 5) reportContent = "기타 (명예훼손)";

    return await reportTipCollection.add({
      'tipDocumentId': tip.documentId,
      'reportContent': FieldValue.arrayUnion([reportContent]),
      'content': tip.content,
      'itemName': tip.itemName,
      'reporterUid': FieldValue.arrayUnion([reporterUid]),
    });
  }

  Future<void> reportAlreadyReportedReview(review, reporterUid, report) async {
    String reportContent;
    if (report == 1) reportContent = "광고, 홍보 / 거래시도";
    if (report == 2) reportContent = "욕설, 음란어 사용";
    if (report == 3) reportContent = "약과 무관한 리뷰 작성";
    if (report == 4) reportContent = "개인 정보 노출";
    if (report == 5) reportContent = "기타 (명예훼손)";

    return await reportTipCollection.doc(review.documentId).update({
      'reportContent': FieldValue.arrayUnion([reportContent]),
      'reporterUid': FieldValue.arrayUnion([reporterUid]),
    });
  }

  Stream<List<ReportTip>> getTip(String documentId) {
    return tipCollection
        // .orderBy('registrationDate', descending: true)
        .where("reviewDocumentId", isEqualTo: documentId)
        .snapshots()
        .map(_reportListFromSnapshot);
  }

  List<ReportTip> _reportListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ReportTip(
        tipDocumentId: doc.data()['tipDocumentId'] ?? '',
        reportContent: doc.data()['reportContent'] ?? '',
        content: doc.data()['content'] ?? '',
        itemName: doc.data()['itemName'],
        reporterUid: doc.data()['reporterUid'] ?? '',
      );
    }).toList();
  }
}