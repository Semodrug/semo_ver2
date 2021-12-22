import 'package:cloud_firestore/cloud_firestore.dart';

class Tip {
  final String content;
  final String uid;
  final String pharmacistName;
  final String pharmacistDate;
  final List favoriteSelected;
  final int favoriteCount;

  final String documentId;
  final Timestamp registrationDate;
  final String seqNum;
  final String entpName;
  final String itemName;

  Tip({
    this.content,
    this.uid,
    this.pharmacistName,
    this.pharmacistDate,
    this.favoriteSelected,
    this.favoriteCount,
    this.documentId,
    this.registrationDate,
    this.seqNum,
    this.entpName,
    this.itemName,
  });
}
