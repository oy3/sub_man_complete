import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sub_man/repository/fire_auth.dart';

class RegistrationBloc {
  BehaviorSubject<User?> _behaviorSubject = BehaviorSubject();

  BehaviorSubject<User?> get behaviorSubject => _behaviorSubject;

  Future<void> doUserRegistration(
      String name, String email, String password) async {
    User? user;
    user = (await FireAuth.registerUsingEmailPassword(
      name: name,
      email: email,
      password: password,
    ));
    _behaviorSubject.sink.add(user);
  }

  void dispose() {
    _behaviorSubject.close();
  }
}
