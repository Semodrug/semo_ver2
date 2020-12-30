import 'package:flutter/cupertino.dart';
import 'package:semo_ver2/models/drug.dart';
//theUser.dart 추가
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference drugCollection = FirebaseFirestore.instance
      .collection('drug');

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
        review: doc.data()['review'] ,

      );
    }).toList();
  }

//get drug stream
  Stream <List<Drug>> get drugs {
    return drugCollection.snapshots()
        .map(_drugListFromSnapshot);
  }

}