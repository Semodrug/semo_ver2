class TheUser {
  final String uid;

  TheUser({this.uid});
}

class UserData {
  final String uid;

  final String registerDate;
  final String agreeDate;

  final String sex;
  final String nickname;
  final String birthYear;

  final bool isPregnant;
  final List diseaseList;

  UserData(
      {this.uid,
      this.sex,
      this.registerDate,
      this.agreeDate,
      this.nickname,
      this.birthYear,
      this.isPregnant,
      this.diseaseList});
}

class Lists {
  final List favoriteLists;

  Lists({this.favoriteLists});
}
