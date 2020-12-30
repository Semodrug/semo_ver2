import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'review_page.dart';
import 'write_review.dart';

class DrugProvider with ChangeNotifier {
  final String drug_item_seq;

  DrugProvider(this.drug_item_seq); //추가

}
