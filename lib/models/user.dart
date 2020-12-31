class TheUser {
  final String uid;

  TheUser({this.uid});
}

class UserData {
  final String uid;

  final String name;
  final String sex;
  final String birth;
  // final String nickname;

  final String phone;

  final bool isPragnant;
  final List diseaseList;

  UserData(
      {this.uid,
      this.name,
      this.sex,
      this.birth,
      this.phone,
      this.isPragnant,
      this.diseaseList});
}
