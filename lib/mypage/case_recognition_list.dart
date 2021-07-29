import 'package:flutter/material.dart';
import 'package:semo_ver2/shared/customAppBar.dart';

class CaseRecognitionList extends StatelessWidget {
  String list = '이지엔6이브연질캡슐, 이지엔6프로연질캡슐(덱시부프로펜), 이지엔6애니연질캡슐(이부프로펜), 이지엔6스트롱연질캡슐(나프록센), 이지엔6에이스연질캡슐(아세트아미노펜), 탁센400이부프로펜연질캡슐, 화이투벤큐연질캡슐, 화이투벤큐노즈연질캡슐, 화이투벤큐코프연질캡슐, 타이레펜8시간이알서방정650밀리그램(아세트아미노펜), 타이레놀정500밀리그람(아세트아미노펜), 타이레놀콜드-에스정, 우먼스 타이레놀정, 어린이용타이레놀정80밀리그람, 씨콜드플러스, 젤콤현탁액(플루벤다졸), 젤콤정(플루벤다졸), 파몬딘정(파모티딘), 솔루펜연질캡슐(덱시부프로펜), 게보린정, 젠타졸정(알벤다졸), 캐롤비콜드연질캡슐, 에이리스정, 메이킨큐장용정, 알싹정(알벤다졸), 베아제정, 캐롤엔연질캡슐(나프록센), 지르텍정(세티리진염산염), 훼스탈플러스정, 탁센연질캡슐, 멜리안정, 코메키나, 머시론';




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('케이스 인식 지원 의약품 목록', Icon(Icons.arrow_back), 0.5),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(list, style: Theme.of(context).textTheme.bodyText2.copyWith(),),
          )


        ],
      ),
    );
  }
}
