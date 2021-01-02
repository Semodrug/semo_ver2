class Review {
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  List<String> favoriteSelected = List<String>();
  final num starRating;
  var noFavorite;
  final String uid;

//  final String name;
//  final String uid;

  Review({this.effect, this.sideEffect, this.effectText, this.sideEffectText, this.overallText, this.favoriteSelected, this.starRating,this.noFavorite, this.uid});
}