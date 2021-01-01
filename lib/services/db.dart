import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';

class DatabaseService {
  final String uid;
  final String itemSeq;

  DatabaseService({this.uid, this.itemSeq});

  // DRUG collection reference
  final CollectionReference drugCollection =
      FirebaseFirestore.instance.collection('drug');

  // USER collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  /* Drug List */
  //drug list from snapshot
  List<Drug> _drugListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Drug(
        barcode: doc.data()['barcode'] ?? '',
        entp_name: doc.data()['ENTP_NAME'] ?? '',
        item_name: doc.data()['ITEM_NAME'] ?? '',
        item_seq: doc.data()['ITEM_SEQ'] ?? '',
        storage_method: doc.data()['STORAGE_METHOD'] ?? '',
        category: doc.data()['category'] ?? '',
        image: doc.data()['image'] ?? '',
        review: doc.data()['review'],
      );
    }).toList();
  }

  //get drug stream
  Stream<List<Drug>> get drugs {
    return drugCollection.snapshots().map(_drugListFromSnapshot);
  }

  /* Drug */
  // drug data from snapshots
  Drug _drugFromSnapshot(DocumentSnapshot snapshot) {
    return Drug(
      barcode: snapshot.data()['barcode'] ?? '',
      entp_name: snapshot.data()['ENTP_NAME'] ?? '',
      item_name: snapshot.data()['ITEM_NAME'] ?? '',
      item_seq: snapshot.data()['ITEM_SEQ'] ?? '',
      storage_method: snapshot.data()['STORAGE_METHOD'] ?? '',
      category: snapshot.data()['category'] ?? '',
      image: snapshot.data()['image'] ?? '',
      review: snapshot.data()['review'],
    );
  }

  // get user doc stream
  Stream<Drug> get drugData {
    return drugCollection.doc(itemSeq).snapshots().map(_drugFromSnapshot);
  }

  /* Specific Information of Drug */
  SpecInfo _specInfoFromSnapshot(DocumentSnapshot snapshot) {
    return SpecInfo(
      eeDataList: snapshot.data()['EE'] ?? '',
      nbDataList: snapshot.data()['NB'] ?? '',
      udDataList: snapshot.data()['UD'] ?? '',
    );
  }

  // get user doc stream
  Stream<SpecInfo> get specInfo {
    // collection reference
    final CollectionReference infoCollection =
        drugCollection.doc(itemSeq).collection('OtherInfos');

    return infoCollection.doc('DOCS').snapshots().map(_specInfoFromSnapshot);
  }

  /* User */
  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'] ?? '',
      sex: snapshot.data()['sex'] ?? '',
      phone: snapshot.data()['phone'] ?? '',
      birth: snapshot.data()['birth'] ?? '',
      diseaseList: snapshot.data()['diseaseList'] ?? '',
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
