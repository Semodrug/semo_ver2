import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';

class DatabaseService {
  final String uid;
  final String itemSeq;

  DatabaseService({this.uid, this.itemSeq});

  /* Drug List */
  // collection reference
  final CollectionReference drugCollection =
      FirebaseFirestore.instance.collection('drug');
  Query drugQuery = FirebaseFirestore.instance.collection('drug');

  //drugSnapshot 값 get이랑 set에서 해주기
  Stream<List<Drug>> drugsSnapshots;

  //get drug stream
  Stream<List<Drug>> get drugs {
    //초기값으로 이름순 정렬
    drugQuery = drugQuery.orderBy('ITEM_NAME', descending: false);

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);
    return drugsSnapshots;
  }

  Stream<List<Drug>> setter(String _filterOrSort) {
    switch (_filterOrSort) {
      case "이름순":
        drugQuery = drugQuery.orderBy('ITEM_NAME', descending: false);
        break;

      case "리뷰 많은 순":
        drugQuery = drugQuery.orderBy('review', descending: true);
        break;
    }

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);

    return drugsSnapshots;
  }

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
  // specific information data from snapshots
  SpecInfo _specInfoFromSnapshot(DocumentSnapshot snapshot) {
    return SpecInfo(
      eeDataList: snapshot.data()['EE'] ?? '',
      nbDataList: snapshot.data()['NB'] ?? '',
      udDataList: snapshot.data()['UD'] ?? '',
    );
  }

  // get specific information stream
  Stream<SpecInfo> get specInfo {
    // collection reference
    final CollectionReference infoCollection =
        drugCollection.doc(itemSeq).collection('OtherInfos');

    return infoCollection.doc('DOCS').snapshots().map(_specInfoFromSnapshot);
  }

  /* User */
  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  /* Favorite List */
  // List data from snapshots
  Lists _listsFromSnapshot(DocumentSnapshot snapshot) {
    return Lists(
      favoriteLists: snapshot.data()['favoriteLists'] ?? '',
    );
  }

  // get favorite list stream
  Stream<Lists> get lists {
    return userCollection
        .doc(uid)
        .collection('OtherInfos')
        .doc('Lists')
        .snapshots()
        .map(_listsFromSnapshot);
  }

  Future<void> updateLists(List newList) async {
    return await userCollection
        .doc(uid)
        .collection('OtherInfos')
        .doc('Lists')
        .set({
      'favoriteLists': newList,
    });
  }

  /* Saved List */
  //drug list from snapshot
  List<SavedDrug> _savedDrugListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SavedDrug(
        item_name: doc.data()['ITEM_NAME'] ?? '',
        item_seq: doc.data()['ITEM_SEQ'] ?? '',
        category: doc.data()['category'] ?? '',
        expiration: doc.data()['expiration'] ?? '',
      );
    }).toList();
  }

  //get drug list stream
  Stream<List<SavedDrug>> get savedDrugs {
    return userCollection
        .doc(uid)
        .collection('savedList')
        .snapshots()
        .map(_savedDrugListFromSnapshot);
  }

  Future<void> addSavedList(itemName, itemSeq, category, expiration) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(itemSeq)
        .set({
      'ITEM_NAME': itemName ?? '',
      'ITEM_SEQ': itemSeq ?? '',
      'category': category ?? '',
      'expiration': expiration ?? '',
    });
  }
}
