import 'package:cloud_firestore/cloud_firestore.dart';

class ReportReview {
  final String reviewDocumentId;
  final String reportContent;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  final String itemName;



  ReportReview({
    this.reviewDocumentId,
    this.reportContent,
    this.effectText,
    this.sideEffectText,
    this.overallText,
    this.itemName
  });
}