import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference drugCollection =
      FirebaseFirestore.instance.collection('drug');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data()['name'],
        sex: snapshot.data()['sex'],
        phone: snapshot.data()['phone'],
        birth: snapshot.data()['birth'],
        diseaseList: snapshot.data()['diseaseList']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // // get user's saved doc stream
  // Stream<Drug> get savedListData {
  //   return drugCollection.doc(uid).collection('savedList').snapshot().map(_userDataFromSnapshot);
  // }

}
