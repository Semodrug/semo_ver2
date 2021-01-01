class Drug {
  final String barcode; //바코드
  final String entp_name; //제약회사 이름
  final String item_name; //약 이름
  final String item_seq; //약 seq 번호
  final String storage_method; //보관 방법
  final String category; //카테고리 //todo: 분류번호 넣어두기
  final String image; // 이미지
  final int review; //약마다 있는 리뷰의 개수

/* 수미 일단 이거는 주석처리 해둘게요 필요하면 말해줘요!!
  final String etc_otc_code;//분류: 일반의약품 ==> 안쓸듯
  final String ingr_name;//약 재료들 ==> 필요할 수도
  final String main_item_name;//주 재료 ==> 안쓸듯
  final String material_name; // 성분이랑 단위 이름들 ==> 안쓸듯
  final String total_content; //약 1정마다 들어있는 설명? ==> 안쓸듯
  final String valid_term; //유통기한 제조일로부터 36개월 ==> 안쓸듯
*/

  Drug({
    this.barcode,
    this.entp_name,
    this.item_name,
    this.item_seq,
    this.storage_method,
    this.category,
    this.image,
    this.review,

    //this.etc_otc_code, this.ingr_name,  this.main_item_name, this.material_name, this.total_content, this.valid_term
  });
}

class SpecInfo {
  final List eeDataList;
  final List nbDataList;
  final List udDataList;

  SpecInfo({this.eeDataList, this.nbDataList, this.udDataList});
}
