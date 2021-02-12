import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  List favoriteSelected;
  final num starRating;
  var noFavorite;
  final String uid;
  final String documentId;
  final Timestamp registrationDate;
  final String seqNum;
  final String entpName;
  final String itemName;
  final String nickName;
  final String reasonForTakingPill;


  Review({
    this.effect,
    this.sideEffect,
    this.effectText,
    this.sideEffectText,
    this.overallText,
    this.favoriteSelected,
    this.starRating,this.noFavorite,
    this.uid,
    this.documentId,
    this.registrationDate,
    this.seqNum,
    this.itemName,
    this.entpName,
    this.nickName,
    this.reasonForTakingPill});
}