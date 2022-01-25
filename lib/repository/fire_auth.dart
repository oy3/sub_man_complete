import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      String? error;

      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists \n for that email.';
        print('The account already exists  for that email.');
      } else if (e.code == 'network-request-failed') {
        error = 'Poor internet connection,\n please try again.';
        print('Bad internet connection, please try again.');
      } else {
        error = e.code;
      }

      EasyLoading.showError(error,
          dismissOnTap: false, maskType: EasyLoadingMaskType.black);
    } catch (e) {
      EasyLoading.showError('Error, please try again',
          dismissOnTap: false, maskType: EasyLoadingMaskType.black);
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    String? error;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided.';
        print('Wrong password provided.');
      } else if (e.code == 'network-request-failed') {
        error = 'Poor internet connection, please try again.';
        print('Bad internet connection, please try again.');
      } else {
        print(e.code);
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<User?> signOut(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut();
  }

  static Future<bool> isSignedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    return currentUser != null;
  }

  static Future<User?> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future resetPassword(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.sendPasswordResetEmail(email: email);
  }
}
