import 'package:cloud_firestore/cloud_firestore.dart';

class ReportTip {
  final String tipDocumentId;
  final String reportContent;
  final String content;
  final String itemName;
  final String reporterUid;

  ReportTip(
      {this.tipDocumentId,
      this.reportContent,
      this.content,
      this.itemName,
      this.reporterUid});
}
