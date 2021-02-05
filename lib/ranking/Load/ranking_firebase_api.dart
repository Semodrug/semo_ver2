import 'package:cloud_firestore/cloud_firestore.dart';

import '../ranking.dart';

class FirebaseApi {

  static Future<QuerySnapshot> getDrugs(
      int limit, String _filterOrSort, {DocumentSnapshot startAfter //어느부분이 리미트 지점인지 그 이후에 있는 user를 불러온다
      }) async {


//    final refUsers = FirebaseFirestore.instance.collection('Drugs');
//        .where('PRDUCT_TYPE', isEqualTo: getCategory) //;
//        .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
//        .orderBy('ITEM_NAME', descending: false)
//        .limit(limit);

    Query refUsers = FirebaseFirestore.instance.collection('Drugs');

    switch (_filterOrSort) {

      case "별점순":
        if(getCategory == '전체[00000]'){
          refUsers = refUsers
              //.where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else {
          refUsers = refUsers
              .where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }

        break;

      case "리뷰 많은 순":
        if(getCategory == '전체[00000]'){
          refUsers = refUsers
          //.where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else{
          refUsers = refUsers
              .where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('numOfReviews', descending: true)
              .limit(limit);
        }
        break;
    }

    if (startAfter == null) { //그 다음 user가 없다면 null
      return refUsers.get();
    } else {//그 다음 user가 존재한다면 그 다음 user부터 시작해라
      return refUsers.startAfterDocument(startAfter).get();
    }
  }
}
