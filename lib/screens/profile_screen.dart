import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/user_response.dart';
import 'package:sub_man/repository/fire_auth.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/screens/edit_profile_screen.dart';
import 'package:sub_man/screens/login_screen.dart';
import 'package:sub_man/screens/onboarding_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:flutter/services.dart';
import 'package:sub_man/widgets/utils.dart';
import 'change_pwd_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserResponse? _currentUser;
  Repository repository = Repository();


  @override
  void initState() {
    super.initState();

    // repository.doGetExpenseByWeek();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponse?>(
      future: repository.doGetUserDetails(widget.user.uid),
      builder: (buildContext, asyncSnapshot) {
        var name = '';
        var email = '';

        // if (!asyncSnapshot.hasError) {
        /*     if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.black));
          }*/
        if (asyncSnapshot.hasData) {
          _currentUser = asyncSnapshot.data;

          name = widget.user.displayName!;
          email = widget.user.email!.toTitleCase();
        }
        /* else {
            return Center(
                child: Text("No details for this user",
                    style: TextStyle(color: Colors.black)));
          }*/
/*        } else {
          debugPrint('Error loading user details');
        }*/

        return Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Style.Colors.mainColor,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Logout",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ))),
                        content: Text("Are you sure?",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ))),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text(Style.Strings.cancel,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ))),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FireAuth.signOut(widget.user).then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OnBoardingScreen()),
                                    (route) => false);
                              });
                            },
                            child: Text("Logout",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ))),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ))
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (name != '')
                    ? Text(name,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: Style.Colors.secondaryColor4,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )))
                    : Container(
                        color: Colors.grey.shade300,
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 20),
                SizedBox(height: 10),
                (email != '')
                    ? Text(email,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: Style.Colors.secondaryColor2,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        )))
                    : Container(
                        color: Colors.grey.shade200,
                        width: MediaQuery.of(context).size.width / 2,
                        height: 20),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: widget.user)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.editProfile,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.titleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Icon(
                          FluentIcons.chevron_right_24_filled,
                          color: Style.Colors.secondaryColor2,
                        )
                      ],
                    ),
                  ),
                ),
                /*Divider(indent: 50, endIndent: 50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        enableDrag: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) => categorySheet(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.categories,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.titleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Icon(
                          FluentIcons.chevron_right_24_filled,
                          color: Style.Colors.secondaryColor2,
                        )
                      ],
                    ),
                  ),
                ),*/
                Divider(indent: 50, endIndent: 50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen())),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.chgPwd,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.titleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Icon(
                          FluentIcons.chevron_right_24_filled,
                          color: Style.Colors.secondaryColor2,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(indent: 50, endIndent: 50),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Style.Strings.currency,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.titleColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                      Spacer(),
                      Text(Style.Strings.gbp,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor2,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                      Icon(
                        FluentIcons.chevron_right_24_filled,
                        color: Style.Colors.secondaryColor2,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

 /* Widget categorySheet() => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.9,
        builder: (_, controller) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
            ),
            centerTitle: true,
            title: Text(Style.Strings.categories,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Style.Colors.titleColor,
                  fontWeight: FontWeight.w500,
                ))),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 3),
                  child: TextField(
                    // controller: _searchEditingController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: "Search",
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Style.Colors.secondaryColor3,
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)))),
                    onChanged: (searchString) {},
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.all(30),
            child: ElevatedButton(
              child: Text(Style.Strings.addCategory,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) => buildAddCategorySheet(),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width / 1.3, 50),
                padding: EdgeInsets.all(10),
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget buildAddCategorySheet() => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.9,
        builder: (_, controller) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
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
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: Style.Colors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Style.Strings.name,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ))),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.titleColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              )),
                              decoration: null,
                              textAlign: TextAlign.start,
                              cursorColor: Style.Colors.titleColor,
                              // controller: _nameController,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.all(30),
            child: ElevatedButton(
              child: Text(Style.Strings.saveCategory,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width / 1.3, 50),
                padding: EdgeInsets.all(10),
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ),
      );*/
}
