import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final DocumentReference reference;
  final String name;
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  final String id;
  List<String> favoriteSelected = List<String>();
  final String uid;
  final num starRating;
  var noFavorite;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['effectText'] != null),
        assert(map['sideEffectText'] != null),
        assert(map['overallText'] != null),
        assert(map['id'] != null),
        assert(map['noFavorite'] != null),
        assert(map['uid'] != null),

        name = map['name'],
        effectText = map['effectText'],
        sideEffectText = map['sideEffectText'],
        overallText = map['overallText'],
        id = map['id'],
//        favoriteSelected = map['favoriteSelected'],
//        favoriteSelected = favoriteSelected.map((item){return item.toMap();}).toList(),
        noFavorite = map['noFavorite'],
        uid = map['uid'],
        effect = map['effect'],
        sideEffect = map['sideEffect'],
        starRating = map['starRating'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}