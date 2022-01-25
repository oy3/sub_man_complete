import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/screens/onboarding_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/validator.dart';

class ResetPwdScreen extends StatelessWidget {
  final _resetFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _focusEmail = FocusNode();
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Reset password",
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    )),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Style.Strings.resetPwdSubtitle,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.secondaryColor2,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    )),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Form(
                key: _resetFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value!,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    ElevatedButton(
                      child: Text("Reset Password",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ))),
                      onPressed: () async {
                        _focusEmail.unfocus();
                        if (_resetFormKey.currentState!.validate()) {
                          await EasyLoading.show(
                            status: 'Loading...',
                            dismissOnTap: false,
                            maskType: EasyLoadingMaskType.black,
                          ).then((value) async {
                            try {
                              await FireAuth.resetPassword(
                                      _emailTextController.text)
                                  .then((value) {
                                _timer = Timer.periodic(
                                    const Duration(milliseconds: 5000),
                                    (Timer timer) {
                                  EasyLoading.showInfo(
                                          'A password reset link has been sent to ${_emailTextController.text}!',
                                          dismissOnTap: false,
                                          maskType: EasyLoadingMaskType.black)
                                      .then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OnBoardingScreen()));
                                  });
                                  _timer.cancel();
                                });
                              });
                            } on Exception catch (e) {
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
