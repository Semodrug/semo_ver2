import 'package:cloud_firestore/cloud_firestore.dart';

import '../ranking.dart'; ///TODO !!!!! 인자로 넘기기!!!!!!!!!!!!!

class FirebaseApi {
  static Future<QuerySnapshot> getDrugs(int limit, String _filter,
      {DocumentSnapshot startAfter //어느부분이 리미트 지점인지 그 이후에 있는 user를 불러온다
      }) async {
    Query refDrugs = FirebaseFirestore.instance.collection('Drugs');

    switch (_filter) {
      case "별점순":
        if (getCategory == '전체') {
          refDrugs = refDrugs
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        } else {
          refDrugs = refDrugs
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        break;
      case "리뷰 많은 순":
        if (getCategory == '전체') {
          refDrugs = refDrugs
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('numOfReviews', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        } 

        else {
          refDrugs = refDrugs
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('numOfReviews', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        break;
    }

    if (startAfter == null) {
      return refDrugs.get();
    } else {
      return refDrugs.startAfterDocument(startAfter).get();
    }
  }
}
