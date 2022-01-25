import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/screens/expenses_screen.dart';
import 'package:sub_man/screens/home_screen.dart';
import 'package:sub_man/screens/profile_screen.dart';
import 'package:sub_man/screens/subscriptions_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/bottom_sheet.dart';

class NavScreen extends StatefulWidget {
  final User user;

  const NavScreen({required this.user});

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late User _currentUser;
  PageController _activePage = PageController(initialPage: 0);
  int? _selectedIndex = 0;

  var items = <String>[];

  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _activePage,
        onPageChanged: (int) {
          setState(() {
            _selectedIndex = int;
          });
        },
        children: <Widget>[
          HomeScreen(user: _currentUser),
          ExpensesScreen2(),
          SubscriptionsScreen(),
          ProfileScreen(user: _currentUser)
        ],
        physics:
            NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _activePage.jumpToPage(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.home_24_regular,
                      color: _selectedIndex == 0
                          ? Style.Colors.titleColor
                          : Style.Colors.secondaryColor6,
                    ),
                    Text(Style.Strings.bottomNavHome,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: _selectedIndex == 0
                              ? Style.Colors.titleColor
                              : Style.Colors.secondaryColor6,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ))),
                    SizedBox(height: 5),
                    Icon(
                      _selectedIndex == 0 ? Icons.circle : null,
                      color: Style.Colors.titleColor,
                      size: 5,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _activePage.jumpToPage(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.data_bar_vertical_24_regular,
                      color: _selectedIndex == 1
                          ? Style.Colors.titleColor
                          : Style.Colors.secondaryColor6,
                    ),
                    Text(Style.Strings.bottomNavExp,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: _selectedIndex == 1
                              ? Style.Colors.titleColor
                              : Style.Colors.secondaryColor6,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ))),
                    SizedBox(height: 5),
                    Icon(
                      _selectedIndex == 1 ? Icons.circle : null,
                      color: Style.Colors.titleColor,
                      size: 5,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        enableDrag: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) => BottomHomeSheet(),
                      );
                    },
                    child: Icon(FluentIcons.add_circle_24_filled, size: 50))),
            Expanded(
              child: GestureDetector(
                onTap: () => _activePage.jumpToPage(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.arrow_repeat_all_24_regular,
                        color: _selectedIndex == 2
                            ? Style.Colors.titleColor
                            : Style.Colors.secondaryColor6),
                    Text(Style.Strings.bottomNavSub,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: _selectedIndex == 2
                              ? Style.Colors.titleColor
                              : Style.Colors.secondaryColor6,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ))),
                    SizedBox(height: 5),
                    Icon(
                      _selectedIndex == 2 ? Icons.circle : null,
                      color: Style.Colors.titleColor,
                      size: 5,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _activePage.jumpToPage(3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.person_24_regular,
                        color: _selectedIndex == 3
                            ? Style.Colors.titleColor
                            : Style.Colors.secondaryColor6),
                    Text(Style.Strings.bottomNavPro,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: _selectedIndex == 3
                              ? Style.Colors.titleColor
                              : Style.Colors.secondaryColor6,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ))),
                    SizedBox(height: 5),
                    Icon(
                      _selectedIndex == 3 ? Icons.circle : null,
                      color: Style.Colors.titleColor,
                      size: 5,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
