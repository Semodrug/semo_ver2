import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
//  List<String> favoriteSelected = List<String>();
  List favoriteSelected;
  final num starRating;
  var noFavorite;
  final String uid;
  final String id;
  final String documentId;
  final Timestamp registrationDate;
  final String seqNum;

//  final String name;
//  final String uid;

  Review({this.effect, this.sideEffect, this.effectText, this.sideEffectText, this.overallText, this.favoriteSelected, this.starRating,this.noFavorite, this.uid, this.id, this.documentId, this.registrationDate, this.seqNum});
}