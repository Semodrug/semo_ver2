import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Review extends ChangeNotifier{
  List<String> _review = ["good", "no", "5"];
  //first element of _review is effect status,
  //second element of _review is side effect status in write_review file

  String getEffect() => _review[0];
  String getSideEffect() => _review[1];
  String getStarRating() => _review[2];

  void effectToBad() {
    _review[0] = "bad";
    notifyListeners();
  }

  void effectToSoSo() {
    _review[0] = "soso";
    notifyListeners();
  }

  void effectToGood() {
    _review[0] = "good";
    notifyListeners();
  }

  void sideEffectToYes() {
    _review[1] = "yes";
    notifyListeners();
  }

  void sideEffectToNo() {
    _review[1] = "no";
    notifyListeners();
  }

//  bool _sideEffect = false;
//
//  bool getSideEffect() => _sideEffect;

//  void sideEffectToYes() {
//    _sideEffect = true;
//    notifyListeners();
//  }
//  void sideEffectToNo() {
//    _sideEffect = false;
//    notifyListeners();
//  }

}


