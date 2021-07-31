import 'package:cloud_firestore/cloud_firestore.dart';

import '../ranking.dart';

class FirebaseApi {

  static Future<QuerySnapshot> getDrugs(
      int limit, String _filterOrSort, {DocumentSnapshot startAfter //어느부분이 리미트 지점인지 그 이후에 있는 user를 불러온다
      }) async {


    Query refDrugs = FirebaseFirestore.instance.collection('Drugs');

    switch (_filterOrSort) {

      case "별점순":
        //원래
        //if(getCategory == '[00000]전체'){
        if(getCategory == '전체'){
        refDrugs = refDrugs
              //.where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else {
          //원래
          // refDrugs = refDrugs
          //     .where('PRDUCT_TYPE', isEqualTo: getCategory) //;
          //     .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
          //     .orderBy('totalRating', descending: true)
          //     .orderBy('ITEM_NAME', descending: false)
          //     .limit(limit);

          refDrugs = refDrugs
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }

        break;

      case "리뷰 많은 순":
      //원래
      //if(getCategory == '[00000]전체'){
        if(getCategory == '전체'){
          refDrugs = refDrugs
          //.where('PRDUCT_TYPE', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('numOfReviews', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else{
          //원래
          // refDrugs = refDrugs
          //     .where('PRDUCT_TYPE', isEqualTo: getCategory) //;
          //     .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
          //     .orderBy('numOfReviews', descending: true)
          //     .limit(limit);

          refDrugs = refDrugs
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
              .where('ETC_OTC_CODE', isEqualTo: '일반의약품')
              .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        break;
    }

    if (startAfter == null) { //그 다음 user가 없다면 null
      return refDrugs.get();
    } else {//그 다음 drug가 존재한다면 그 다음 drug부터 시작해라
      return refDrugs.startAfterDocument(startAfter).get();
    }
  }
}
