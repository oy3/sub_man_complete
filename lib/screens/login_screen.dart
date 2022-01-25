import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/screens/nav_screen.dart';
import 'package:sub_man/screens/register_screen.dart';
import 'package:sub_man/screens/reset_pwd_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/widgets/validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _obscureText = true;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Style.Colors.mainColor,
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, size: 40)),
                      SizedBox(height: 20),
                      Text(
                        "Welcome back!",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 25)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        Style.Strings.loginSubtitle,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Style.Colors.secondaryColor2,
                                fontWeight: FontWeight.normal,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              Validator.validateEmail(email: value!),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'Email',
                            hintText: 'yourmail@domain.com',
                            labelStyle: TextStyle(
                              color: Style.Colors.secondaryColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                            hintStyle: TextStyle(
                                color: Style.Colors.secondaryColor7,
                                fontSize: 15.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade700, width: 1),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(0.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: _obscureText,
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              Validator.validatePassword(password: value!),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'Password',
                            hintText: '********',
                            labelStyle: TextStyle(
                              color: Style.Colors.secondaryColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: new Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black),
                            ),
                            hintStyle: TextStyle(
                              color: Style.Colors.secondaryColor7,
                              fontSize: 15.0,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(0.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade700, width: 1),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Forgot password? ',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPwdScreen())),
                              },
                              child: Text(
                                'Reset password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Text("Login",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ))),
                        onPressed: () async {
                          /*EasyLoading.addStatusCallback((status) {
                            print('EasyLoading Status $status');
                          });*/

                          _focusEmail.unfocus();
                          _focusPassword.unfocus();

                          if (_loginFormKey.currentState!.validate()) {
                            await EasyLoading.show(
                              status: 'Loading...',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black,
                            ).then((value) async {
                              User? user =
                                  await FireAuth.signInUsingEmailPassword(
                                      email: _emailTextController.text,
                                      password: _passwordController.text);
                              if (user != null) {
                                _timer = Timer.periodic(
                                    const Duration(milliseconds: 5000),
                                    (Timer timer) {
                                  EasyLoading.showSuccess('Successful!',
                                      dismissOnTap: false,
                                      maskType: EasyLoadingMaskType.black);
                                  _timer.cancel();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavScreen(user: user)));
                                });
                              } else {
                                EasyLoading.showError('Error, Try again',
                                    dismissOnTap: false,
                                    maskType: EasyLoadingMaskType.black);
                              }
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
                            'Don\'t have an account? ',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen())),
                            child: Text(
                              'Sign Up',
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
                )
              ],
            ),
          )),
    );
  }
}
