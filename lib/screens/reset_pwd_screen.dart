import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/style/theme.dart' as Style;

class ResetPwdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    cursorColor: Colors.black,
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
                  SizedBox(height: 70),
                  ElevatedButton(
                    child: Text("Reset Password",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ))),
                    onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
