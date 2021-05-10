import 'package:cloud_firestore/cloud_firestore.dart';

class PhTip{
  final String content;
  final String name;
  final Timestamp regDate;
  final String seqNum;

  PhTip({
    this.content,
    this.name,
    this.regDate,
    this.seqNum,
  });
}