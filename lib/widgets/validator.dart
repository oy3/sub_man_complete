class Validator {
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePhone({required String? number}) {
    if (number == null) {
      return null;
    }

    RegExp phoneExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

    if (number.isEmpty) {
      return 'Phone number can\'t be empty';
    } else if (!phoneExp.hasMatch(number)) {
      return 'Enter valid phone number';
    }

    return null;
  }

  static String? validateDuelPassword(
      {required String password, required String cpassword}) {
    if (password == null) {
      return null;
    }

    if (password.isNotEmpty && cpassword.isNotEmpty && password != cpassword) {
      return 'Passwords does not match';
    } else if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (cpassword.isEmpty) {
      return 'Confirm password can\'t be empty';
    } else if (password.length < 8 && cpassword == "") {
      return 'Enter a password with length at least 8';
    } else if (cpassword.length < 8) {
      return 'Enter a confirm password with length at least 8';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }
}
