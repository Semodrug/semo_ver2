import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tip extends ChangeNotifier {
  String tip = '';

  String getTip() => tip;
}
