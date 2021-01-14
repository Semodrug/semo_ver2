class Drug {
  final String barCode;
  // final String cancelName;
  final String chart; // 성상 (본품은 백색의 정제다.)
  // final String cnsgnManuf; // 위탁제조업체
  // final String ediCode; // 보험코드

  final List eeDocData;
  // final String eeDocId; // 효능효과 다운로드 링크
  final String entpName;
  final String entpNo;

  final String etcOtcCode; // 일반의약품, 전문의약품
  // final String gbnName; // 변경이력
  // final String indutyType; // 의약품 업종구분
  final String ingrName; // 의약품 첨가제
  final String itemName; //
  // final String itemPermitDate; // 허가일자

  final String itemSeq;
  final String mainItemIngr; // 유효성분 (염산에페드린)
  final String materialName; // 원료성분 (1정 중 80밀리그램,염산에페드린,KP,25,밀리그램)

  final List nbDocData;
  // final String nbDocId; // 주의사항 다운로드 링크
  final String permitKindName; // 허가, 신고 구분
  final String storageMethod;
  final String totalContect; // (1000밀리리터 중)

  final List udDocData;
  final String udDocId;
  final String validTerm;
  final num totalRating;
  final num numOfReview;

  // TODO : category
  final String category;

  Drug({
    this.barCode,
    // this.cancelName,
    this.chart,
    // this.cnsgnManuf,
    // this.ediCode,
    this.eeDocData,
    // this.eeDocId,
    this.entpName,
    this.entpNo,
    this.etcOtcCode,
    // this.indutyType,
    this.ingrName,
    this.itemName,
    // this.itemPermitDate,
    this.itemSeq,
    this.mainItemIngr,
    this.materialName,
    this.nbDocData,
    // this.nbDocId,
    this.permitKindName,
    this.storageMethod,
    this.totalContect,
    this.udDocData,
    this.udDocId,
    this.validTerm,
    this.category,
    this.totalRating,
    this.numOfReview
  });
}

//
// class SpecInfo {
//   final List eeDataList;
//   final List nbDataList;
//   final List udDataList;
//
//   SpecInfo({this.eeDataList, this.nbDataList, this.udDataList});
// }

class SavedDrug {
  final String itemName;
  final String itemSeq;
  final String category;
  final String expiration;

  SavedDrug({this.itemName, this.itemSeq, this.category, this.expiration});
}
