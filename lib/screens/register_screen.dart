import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/bloc/registeration_bloc.dart';
import 'package:sub_man/screens/add_phone_screen.dart';
import 'package:sub_man/screens/login_screen.dart';
import 'package:sub_man/screens/nav_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/widgets/validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();
  final _cPasswordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();
  final _focusCpassword = FocusNode();

  late Timer _timer;
  late RegistrationBloc registrationBloc;
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    registrationBloc = RegistrationBloc();
    firestore = FirebaseFirestore.instance;
    userRegistrationListener();
  }

  void userRegistrationListener() {
    registrationBloc.behaviorSubject.stream.listen((event) {
      if (event != null) {
        _timer =
            Timer.periodic(const Duration(milliseconds: 3000), (Timer timer) {
          EasyLoading.showSuccess('Successful!',
              dismissOnTap: false, maskType: EasyLoadingMaskType.black);
          _timer.cancel();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddPhoneScreen(
                          user: event, password: _passwordTextController.text)),
                  (route) => false);
  /*        Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPhoneScreen(
                      user: event, password: _passwordTextController.text)));*/
        });
      } else {
        EasyLoading.showError('Error, Try again',
            dismissOnTap: false, maskType: EasyLoadingMaskType.black);
      }
    });
  }

  @override
  void dispose() {
    registrationBloc.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    // _phoneTextController.dispose();
    _passwordTextController.dispose();
    _cPasswordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Style.Colors.mainColor,
      body: Wrap(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 50, left: 20),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, size: 40)),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Form(
              key: _registerFormKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to ",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        )),
                      ),
                      Text(
                        Style.Strings.appName.toUpperCase(),
                        style: GoogleFonts.spartan(
                            textStyle: TextStyle(
                                color: Style.Colors.titleColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 25)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    Style.Strings.regSubtitle,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.secondaryColor2,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    )),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _focusName,
                    validator: (value) => Validator.validateName(
                      name: value!,
                    ),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      labelText: 'Full Name',
                      hintText: 'Firstname and Lastname',
                      labelStyle: TextStyle(
                        color: Style.Colors.secondaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade700, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(0.0)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    validator: (value) => Validator.validateEmail(
                      email: value!,
                    ),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      labelText: 'Email',
                      hintText: 'yourmail@domain.com',
                      labelStyle: TextStyle(
                        color: Style.Colors.secondaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(0.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade700, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    cursorColor: Colors.black,
                    validator: (value) => Validator.validateDuelPassword(
                        password: value!,
                        cpassword: _cPasswordTextController.text),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      labelText: 'Password',
                      hintText: '********',
                      labelStyle: TextStyle(
                        color: Style.Colors.secondaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade700, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(0.0)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    cursorColor: Colors.black,
                    focusNode: _focusCpassword,
                    controller: _cPasswordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) => Validator.validateDuelPassword(
                        password: _passwordTextController.text,
                        cpassword: value!),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      labelText: 'Confirm Password',
                      hintText: '********',
                      labelStyle: TextStyle(
                        color: Style.Colors.secondaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade700, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(0.0)),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    child: Text("Sign Up",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ))),
                    onPressed: () async {
                      /*EasyLoading.addStatusCallback((status) {
                      print('EasyLoading Status $status');
                    });*/

                      _focusName.unfocus();
                      _focusEmail.unfocus();
                      // _focusPhone.unfocus();
                      _focusPassword.unfocus();
                      _focusCpassword.unfocus();

                      if (_registerFormKey.currentState!.validate()) {
                        await EasyLoading.show(
                          status: 'Loading...',
                          dismissOnTap: false,
                          maskType: EasyLoadingMaskType.black,
                        ).then((value) async {
                          await registrationBloc.doUserRegistration(
                              _nameTextController.text,
                              _emailTextController.text,
                              _passwordTextController.text);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width / 1.3, 50),
                      padding: EdgeInsets.all(10),
                      primary: Colors.black,
                      onPrimary: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen())),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
