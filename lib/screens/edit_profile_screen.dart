import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/user_response.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/style/theme.dart' as Style;

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Timer _timer;
  late UserResponse? _currentUser;
  Repository repository = Repository();
  TextEditingController? _phoneController;

  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponse>(
      future: repository.doGetUserDetails(widget.user.uid),
      builder: (buildContext, asyncSnapshot) {
        var name, email, phone;
        if (!asyncSnapshot.hasError) {
          if (asyncSnapshot.hasData) {
            _currentUser = asyncSnapshot.data;

            name = widget.user.displayName;
            email = widget.user.email;
            phone = _currentUser!.users.phone;

            if (phone != '') {
              _phoneController = TextEditingController(text: phone);
            }
          }
        } else {
          debugPrint('Error loading user details');
        }

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
                child: GestureDetector(
                  onTap: () async {
                    await EasyLoading.show(
                      status: 'Loading...',
                      dismissOnTap: false,
                      maskType: EasyLoadingMaskType.black,
                    ).then((value) {
                      try {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.user.uid)
                            .set(<String, dynamic>{
                          'uid': widget.user.uid,
                          'name': widget.user.displayName,
                          'email': widget.user.email,
                          'phone': _phoneController!.text,
                        }).then((value) {
                          _timer =
                              Timer.periodic(const Duration(milliseconds: 3000),
                                  (Timer timer) {
                            EasyLoading.showSuccess('Successful!',
                                dismissOnTap: false,
                                maskType: EasyLoadingMaskType.black);
                            _timer.cancel();
                          });
                        });
                      } on Exception catch (e) {
                        EasyLoading.showError('Error, Try again',
                            dismissOnTap: false,
                            maskType: EasyLoadingMaskType.black);
                      }
                    });
                  },
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
              ),
            ],
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Style.Colors.secondaryColor3,
              child: Wrap(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Style.Strings.name,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.secondaryColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ))),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: TextField(
                                  readOnly: true,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.secondaryColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  )),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.lock_rounded,
                                        color: Style.Colors.secondaryColor2),
                                  ),
                                  textAlign: TextAlign.start,
                                  cursorColor: Style.Colors.titleColor,
                                  controller: TextEditingController(
                                      text:
                                          (name != '') ? name : 'eg. John Doe'),
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Style.Strings.email,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.secondaryColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ))),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: TextField(
                                  readOnly: true,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.secondaryColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  )),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.lock_rounded,
                                        color: Style.Colors.secondaryColor2),
                                  ),
                                  controller: TextEditingController(
                                      text: (email != '')
                                          ? email
                                          : 'eg. John@mail.com'),
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Style.Strings.phone,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.secondaryColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ))),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: TextField(
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    color: Style.Colors.titleColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  )),
                                  decoration: null,
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.start,
                                  cursorColor: Style.Colors.titleColor,
                                  controller: _phoneController,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
