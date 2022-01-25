import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/screens/nav_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/validator.dart';

class AddPhoneScreen extends StatefulWidget {
  final User user;
  final String password;

  const AddPhoneScreen({Key? key, required this.user, required this.password})
      : super(key: key);

  @override
  _AddPhoneScreenState createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  late Timer _timer;
  late User _currentUser;
  late String _pwd;
  final _phoneTextController = TextEditingController();
  final _focusPhone = FocusNode();

  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
    _pwd = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            SizedBox(height: 90),
            Text(
              "Add Phone Number",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 25,
              )),
            ),
            SizedBox(height: 100),
            TextFormField(
              controller: _phoneTextController,
              focusNode: _focusPhone,
              validator: (value) => Validator.validatePhone(
                number: value!,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelText: 'Phone Number',
                hintText: 'Area Code and Mobile Number',
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
                /*focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(0.0)),*/
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              child: Text("Save",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
              onPressed: () async {
                _focusPhone.unfocus();

                await EasyLoading.show(
                  status: 'Loading...',
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.black,
                ).then((value) {
                  try {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(_currentUser.uid)
                        .set(<String, dynamic>{
                      'uid': _currentUser.uid,
                      'name': _currentUser.displayName,
                      'email': _currentUser.email,
                      'phone': _phoneTextController.text,
                      /*   'password': _pwd,*/
                    }).then((value) {
                      _timer = Timer.periodic(
                          const Duration(milliseconds: 3000), (Timer timer) {
                        EasyLoading.showSuccess('Successful!',
                            dismissOnTap: false,
                            maskType: EasyLoadingMaskType.black);
                        _timer.cancel();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NavScreen(user: _currentUser)),
                            (route) => false);
                      });
                    });
                  } on Exception catch (e) {
                    EasyLoading.showError('Error, Try again',
                        dismissOnTap: false,
                        maskType: EasyLoadingMaskType.black);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width / 1.3, 50),
                padding: EdgeInsets.all(10),
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
