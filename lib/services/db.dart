import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';

class DatabaseService {
  final String uid;
  final String itemSeq;
  final String categoryName;
  //다은 카테고리 추가
  DatabaseService({this.uid, this.itemSeq, this.categoryName});

  /* Drug List */
  // collection reference
  final CollectionReference drugCollection =
      FirebaseFirestore.instance.collection('Drugs');
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
        barCode: doc.data()['BAR_CODE'] ?? '',
        // cancelName: doc.data()['CANCEL_NAME'] ?? '',
        chart: doc.data()['CHART'] ?? '',
        // cnsgnManuf: doc.data()['CNSGN_MANUF'] ?? '',
        // ediCode: doc.data()['EDI_CODE'] ?? '',

        eeDocData: doc.data()['EE_DOC_DATA'] ?? '',
        // eeDocId: doc.data()['EE_DOC_ID'] ?? '',
        entpName: doc.data()['ENTP_NAME'] ?? '',
        entpNo: doc.data()['ENTP_NO'] ?? '',

        etcOtcCode: doc.data()['ETC_OTC_CODE'] ?? '',
        // gbnName: doc.data()['GBN_NAME'] ?? '',
        // indutyType: doc.data()['INDUTY_TYPE'] ?? '',
        ingrName: doc.data()['INGR_NAME'] ?? '',
        itemName: doc.data()['ITEM_NAME'] ?? '',
        // itemPermitDate: doc.data()['ITEM_PERMIT_DATE'] ?? '',

        itemSeq: doc.data()['ITEM_SEQ'] ?? '',
        mainItemIngr: doc.data()['MAIN_ITEM_INGR'] ?? '',
        materialName: doc.data()['MATERIAL_NAME'] ?? '',

        nbDocData: doc.data()['NB_DOC_DATA'] ?? '',
        // nbDocId: doc.data()['NB_DOC_ID'] ?? '',
        permitKindName: doc.data()['PERMIT_KIND_NAME'] ?? '',
        storageMethod: doc.data()['STORAGE_METHOD'] ?? '',
        totalContect: doc.data()['TOTAL_CONTENT'] ?? '',

        udDocData: doc.data()['UD_DOC_DATA'] ?? '',
        udDocId: doc.data()['UD_DOC_ID'] ?? '',
        validTerm: doc.data()['VALID_TERM'] ?? '',

        // TODO:
        category: doc.data()['category'] ?? '',
        // image: doc.data()['image'] ?? '',
        // review: doc.data()['review'],
      );
    }).toList();
  }

  /* Drug */
  // drug data from snapshots
  Drug _drugFromSnapshot(DocumentSnapshot snapshot) {
    return Drug(
      barCode: snapshot.data()['BAR_CODE'] ?? '',
      // cancelName: snapshot.data()['CANCEL_NAME'] ?? '',
      chart: snapshot.data()['CHART'] ?? '',
      // cnsgnManuf: snapshot.data()['CNSGN_MANUF'] ?? '',
      // ediCode: snapshot.data()['EDI_CODE'] ?? '',

      eeDocData: snapshot.data()['EE_DOC_DATA'] ?? '',
      // eeDocId: snapshot.data()['EE_DOC_ID'] ?? '',
      entpName: snapshot.data()['ENTP_NAME'] ?? '',
      entpNo: snapshot.data()['ENTP_NO'] ?? '',

      etcOtcCode: snapshot.data()['ETC_OTC_CODE'] ?? '',
      // gbnName: snapshot.data()['GBN_NAME'] ?? '',
      // indutyType: snapshot.data()['INDUTY_TYPE'] ?? '',
      ingrName: snapshot.data()['INGR_NAME'] ?? '',
      itemName: snapshot.data()['ITEM_NAME'] ?? '',
      // itemPermitDate: snapshot.data()['ITEM_PERMIT_DATE'] ?? '',

      itemSeq: snapshot.data()['ITEM_SEQ'] ?? '',
      mainItemIngr: snapshot.data()['MAIN_ITEM_INGR'] ?? '',
      materialName: snapshot.data()['MATERIAL_NAME'] ?? '',

      nbDocData: snapshot.data()['NB_DOC_DATA'] ?? '',
      // nbDocId: snapshot.data()['NB_DOC_ID'] ?? '',
      permitKindName: snapshot.data()['PERMIT_KIND_NAME'] ?? '',
      storageMethod: snapshot.data()['STORAGE_METHOD'] ?? '',
      totalContect: snapshot.data()['TOTAL_CONTENT'] ?? '',

      udDocData: snapshot.data()['UD_DOC_DATA'] ?? '',
      udDocId: snapshot.data()['UD_DOC_ID'] ?? '',
      validTerm: snapshot.data()['VALID_TERM'] ?? '',

      // TODO:
      category: snapshot.data()['category'] ?? '',
      // image: snapshot.data()['image'] ?? '',
      // review: snapshot.data()['review'],

      totalRating: snapshot.data()['totalRating'] ?? 0
    );
  }

  // get drug doc stream
  Stream<Drug> get drugData {
    return drugCollection.doc(itemSeq).snapshots().map(_drugFromSnapshot);
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
      diseaseList: snapshot.data()['diseaseList'] ?? [],
      isPregnant: snapshot.data()['isPregnant'] ?? false,
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // add user doc
  Future<void> addUser(name, sex, nickname, birth) async {
    return await userCollection.doc(uid).set({
      'name': name ?? '',
      'sex': sex ?? '',
      'nickname': nickname ?? '',
      'birth': birth ?? '',
    });
  }

  // update user doc
  Future<void> updateUser(isPregnant, disease_list) async {
    return await userCollection.doc(uid).update({
      'isPregnant': isPregnant ?? '',
      'disease_list': disease_list ?? [],
    });
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
        itemName: doc.data()['ITEM_NAME'] ?? '',
        itemSeq: doc.data()['ITEM_SEQ'] ?? '',
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

  /* Policy */
  // collection reference
  final CollectionReference policyCollection =
      FirebaseFirestore.instance.collection('Policy');

  // privacy from snapshots
  String _termsFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data()['terms'] ?? '';
  }

  // get privacy stream
  Stream<String> get terms {
    return policyCollection.doc('terms').snapshots().map(_termsFromSnapshot);
  }

  // privacy from snapshots
  String _privacyFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data()['privacy'] ?? '';
  }

  // get privacy stream
  Stream<String> get privacy {
    return policyCollection
        .doc('privacy')
        .snapshots()
        .map(_privacyFromSnapshot);
  }

  Future<String> getTotalRating(DocumentSnapshot snapshot) {
//    drugCollection.doc(itemSeq).get(FieldPath(['address', 'postcode'])).toString();
    dynamic nested = snapshot.get(FieldPath(['address', 'postcode']));
//    return a;

  }

  Future<void> updateTotalRating(formalTotalRating, newTotalRating ) async {
    return await drugCollection.doc(itemSeq).update({
      'totalRating': newTotalRating ?? 0,
    });
  }

//  Stream<num> get totalRating {
//    //  final CollectionReference drugCollection =
//    //      FirebaseFirestore.instance.collection('Drugs');
//    return drugCollection.doc('itemSeq').snapshots().map;
//  }


}
