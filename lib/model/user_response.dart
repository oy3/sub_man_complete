import 'package:sub_man/model/user.dart';

class UserResponse {
  final Users users;
  final String error;

  UserResponse(this.users, this.error);

  UserResponse.fromJson(Map<String, dynamic> json)
      : users = Users.fromJson(json),
        error = "";

  UserResponse.withError(String errorValue)
      : users = Users('','','',''),
        error = errorValue;
}
