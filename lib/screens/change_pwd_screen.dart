import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/style/theme.dart' as Style;

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Style.Colors.mainColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                color: Style.Colors.titleColor,
              ),
              Text(Style.Strings.back,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.w500))),
            ],
          ),
        ),
      ),
      body: Container(
        color: Style.Colors.secondaryColor3,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Request Password Change',
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 25)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                    'Click the reset button below and Check the email address associated with your account',
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: Style.Colors.secondaryColor2,
                            fontWeight: FontWeight.normal,
                            fontSize: 18))),
              ),
              ElevatedButton(
                child: Text("Reset",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ))),
                onPressed: () async {
                  User currentUser;
                  FireAuth.getUser().then((value) async {
                    currentUser = value!;

                    await EasyLoading.show(
                      status: 'Loading...',
                      dismissOnTap: false,
                      maskType: EasyLoadingMaskType.black,
                    ).then((value) async {
                      try {
                        await FireAuth.resetPassword(currentUser.email!)
                            .then((value) {
                          _timer =
                              Timer.periodic(const Duration(milliseconds: 5000),
                                  (Timer timer) {
                            EasyLoading.showInfo(
                                    'A password reset link has been sent to ${currentUser.email!}!',
                                    dismissOnTap: false,
                                    maskType: EasyLoadingMaskType.black)
                                .then((value) {
                              /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OnBoardingScreen()));*/
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
                  });
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

        /*  Wrap(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.oldPwd,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor2,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextField(
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor2,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            )),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.lock_rounded,
                                  color: Style.Colors.secondaryColor2),
                            ),
                            controller: _controller,
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.newPwd,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor2,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextField(
                            style: GoogleFonts.roboto(
                                height: 2.5,
                                textStyle: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                )),
                            textAlign: TextAlign.start,
                            obscureText: false,
                            maxLength: 8,
                            decoration: null,
                            cursorColor: Style.Colors.titleColor,
                            onChanged: (text) {
                              pwd = text;
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.confirmPwd,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor2,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: TextField(
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              height: 2.5,
                              color: Style.Colors.titleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            )),
                            obscureText: true,
                            textAlign: TextAlign.start,
                            maxLength: 8,
                            decoration: null,
                            cursorColor: Style.Colors.titleColor,
                            onChanged: (text) {
                              cpwd = text;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),*/
      ),
    );
  }
}
