import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';

class DatabaseService {
  final String uid;
  final String itemSeq;
  final String categoryName;

  //다은 카테고리 추가
  DatabaseService({this.uid, this.itemSeq, this.categoryName, Itemseq});

  /* Drug List */
  // collection reference
  final CollectionReference drugCollection =
      FirebaseFirestore.instance.collection('Drugs');
  Query drugQuery = FirebaseFirestore.instance.collection('Drugs');

  //drugSnapshot 값 get이랑 set에서 해주기
  Stream<List<Drug>> drugsSnapshots;

  //get drug stream
  Stream<List<Drug>> get drugs {
    //초기값으로 이름순 정렬
    drugQuery = drugQuery.orderBy('ITEM_NAME', descending: false);

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);
    return drugsSnapshots;
  }

  Stream<List<Drug>> setForRanking(String _filterOrSort) {
    switch (_filterOrSort) {
      case "이름순":
        drugQuery = drugQuery.where('PRDUCT_TYPE', isEqualTo: categoryName )//;
            .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
            .orderBy('ITEM_NAME', descending: false).limit(30);

        break;

      case "리뷰 많은 순":
        drugQuery = drugQuery.where('PRDUCT_TYPE', isEqualTo: categoryName )//;
            .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
            .orderBy('numOfReview', descending: false).limit(10);
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
        category: doc.data()['PRDUCT_TYPE'] ?? '',
        // image: doc.data()['image'] ?? '',
        // review: doc.data()['review'],

        totalRating: doc.data()['totalRating'] ?? 0,
        numOfReview: doc.data()['numOfReview'] ?? 0,
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
      category: snapshot.data()['PRDUCT_TYPE'] ?? '',
      // image: snapshot.data()['image'] ?? '',
      // review: snapshot.data()['review'],

      totalRating: snapshot.data()['totalRating'] ?? 0,
      numOfReview: snapshot.data()['numOfReview'] ?? 0,
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
      registerDate: snapshot.data()['registerDate'] ?? '',
      agreeDate: snapshot.data()['agreeDate'] ?? '',
      sex: snapshot.data()['sex'] ?? '',
      nickname: snapshot.data()['nickname'] ?? '',
      birthYear: snapshot.data()['birthYear'] ?? '',
      isPregnant: snapshot.data()['isPregnant'] ?? false,
      diseaseList: snapshot.data()['diseaseList'] ?? [],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // add user doc
  // Future<void> updateAgreeDate(registerDate) async {
  //   return await userCollection.doc(uid).set({
  //     'registerDate': registerDate ?? '',
  //   });
  // }

  Future<void> addUser(agreeDate) async {
    return await userCollection.doc(uid).set({
      'agreeDate': agreeDate ?? '',
    });
  }

  // update user doc
  Future<void> updateUserPrivacy(sex, birthYear, nickname) async {
    return await userCollection.doc(uid).update({
      'sex': sex ?? '',
      'birthYear': birthYear ?? '',
      'nickname': nickname ?? '',
    });
  }

  Future<void> updateUserHealth(isPregnant, diseaseList) async {
    return await userCollection.doc(uid).update({
      'isPregnant': isPregnant ?? '',
      'disease_list': diseaseList ?? [],
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
        category: doc.data()['PRDUCT_TYPE'] ?? '',
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
      'PRDUCT_TYPE': category ?? '',
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

  // get privacy stream
  Future<num> getTotalRating() async {
    DocumentSnapshot ds = await drugCollection.doc(itemSeq).get();
    return ds.data()["totalRating"];
  }

  Future<void> updateTotalRating(num rating, num length) async {
//    DocumentSnapshot drugSnapshot = await drugCollection.doc(itemSeq).get();
//    num formerTotalRating = drugSnapshot.data()["totalRating"];
//    num formerNumOfReview = drugSnapshot.data()["numOfReview"];

    return await drugCollection.doc(itemSeq).update({
//      'totalRating': (formerTotalRating * formerNumOfReview + rating) /
//              (formerNumOfReview + 1) ??
//          0,
//      'numOfReview': FieldValue.increment(1),

      'totalRating': rating,
      'numOfReview': length,

    });
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await userCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isUnique(newNickname) async {
    final QuerySnapshot result =
        await userCollection.where('nickname', isEqualTo: newNickname).get();
    return result.docs.isEmpty;
  }

}
