import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/style/theme.dart' as Style;

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? pwd;
  String? cpwd;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: "mroyeyinka");
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
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(Style.Strings.save,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18))),
            ),
          ),
        ],
      ),
      body: Container(
        color: Style.Colors.secondaryColor3,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Wrap(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
        ),
      ),
    );
  }
}
