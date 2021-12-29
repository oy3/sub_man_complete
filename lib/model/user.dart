class Users {
  final String uid;
  final String name;
  final String email;
  final String phone;
  // final String password;

  Users(this.uid, this.name, this.email, this.phone);/*, this.password*/

  Users.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        email = json["email"],
        phone = json["phone"]; /*,
        password = json["password"]*/
}
