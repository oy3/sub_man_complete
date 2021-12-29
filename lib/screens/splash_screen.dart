import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/screens/onboarding_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;

import 'nav_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 5),
        () => FireAuth.isSignedIn().then((value) {
              value == false
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnBoardingScreen()))
                  : doUserLogin();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Style.Colors.mainColor,
      body: Center(
        child: Container(
          child: Text(
            Style.Strings.appName.toUpperCase(),
            style: GoogleFonts.spartan(
                textStyle: TextStyle(
                    color: Style.Colors.titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 50)),
          ),
        ),
      ),
    );
  }

  void doUserLogin() {
    FireAuth.getUser().then((value) {
      if (value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NavScreen(user: value)),
                (route) => false);
      /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavScreen(user: value),
          ),
        );*/
      }
    });
  }
}
