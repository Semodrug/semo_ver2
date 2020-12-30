class TheUser {
  final String uid;

  TheUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sex;
  final String phone;
  final bool birth;
  final List diseaseList;

  UserData(
      this.uid, this.name, this.sex, this.phone, this.birth, this.diseaseList);
}
