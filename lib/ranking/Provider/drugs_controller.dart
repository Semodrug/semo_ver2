import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semo_ver2/models/drug.dart';
import 'package:semo_ver2/ranking/Load/ranking_firebase_api.dart';

class DrugsController extends ChangeNotifier {
  final _drugsSnapshot = <DocumentSnapshot>[];
  final filter;
  String _errorMessage = '';
  int documentLimit = 20;
  bool _hasNext = true;
  bool _isFetchingDrugs = false;

  DrugsController(this.filter); //fetch 한 애들인지

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Drug> get drugs => _drugsSnapshot.map((snap) {
        final drug = snap.data();
        return Drug(
            entpName: drug['ENTP_NAME'],
            etcOtcCode: drug['ETC_OTC_CODE'],
            itemName: drug['ITEM_NAME'],
            itemSeq: drug['ITEM_SEQ'],
            category: drug['PRDUCT_TYPE'],
            totalRating: drug['totalRating'],
            numOfReviews: drug['numOfReviews'],
            rankCategory: drug['RANK_CATEGORY'] //test
            );
      }).toList();

  Future fetchNextDrugs() async {
    if (_isFetchingDrugs) return;

    _errorMessage = '';
    _isFetchingDrugs = true;

    try {
      final snap = await FirebaseApi.getDrugs(
        documentLimit,
        filter,
        startAfter: _drugsSnapshot.isNotEmpty ? _drugsSnapshot.last : null,
      );
      _drugsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingDrugs = false;
  }
}
