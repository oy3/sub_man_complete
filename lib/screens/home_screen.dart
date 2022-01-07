import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/bloc/user_subscription_list_bloc.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/model/user_subscriptions_list_response.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/screens/reminder_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:iconsax/iconsax.dart';
import 'package:sub_man/widgets/subscription_item_card.dart';
import 'package:sub_man/widgets/subscription_item_card_loader.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _currentUser;
  late String firtname;

  Repository repository = Repository();

  UserSubscriptionsListBloc userSubscriptionsListBloc =
      UserSubscriptionsListBloc();

  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;

    String? fullName = _currentUser.displayName;
    List<String> splitName = fullName!.split(" ");

    firtname = splitName[0];

    userSubscriptionsListBloc.getUserSubscriptionList('plans');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Hi $firtname,",
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ))),
                /* IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReminderScreen()));
                    },
                    icon: Stack(
                      children: [
                        Icon(Iconsax.notification_bing5,
                            size: 35, color: Style.Colors.titleColor),
                        Icon(Iconsax.notification_circle1,
                            size: 33, color: Colors.red)
                      ],
                    )),*/
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: ShapeDecoration(
                color: Style.Colors.secondaryColor3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Style.Strings.homeTitle1,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        color: Style.Colors.secondaryColor2,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ))),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: repository.doGetSubSum(),
                    builder: (context, snapshot) {
                      var subTotal;

                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          subTotal = snapshot.data;
                        } else {
                          subTotal = 0.00;
                        }
                      }
                      return Text(
                          Style.Strings.gbpSymbol +
                              (double.parse((subTotal).toStringAsFixed(2)))
                                  .toString(),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor4,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          )));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(Style.Strings.homeTitle2,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Style.Colors.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ))),
            Expanded(
              child: StreamBuilder<UserSubscriptionsListResponse>(
                  stream: userSubscriptionsListBloc.subject.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<UserSubscriptionsListResponse> snapshot) {
                    if (snapshot.hasError)
                      return Center(
                          child: Text(
                              'Error loading subscriptions, please try again. ',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor2,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18))));
                    /*${snapshot.error}*/
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SubscriptionItemCardLoader(false);
                      default:
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              (snapshot.data!.userSubscriptionsList.length >= 5)
                                  ? 5
                                  : snapshot.data!.userSubscriptionsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.hasData) {
                              for (dynamic p in snapshot
                                  .data!.userSubscriptionsList[index].plans) {
                                if (Plans.fromJson(p).active) {
                                  /* amounts.add(Plans.fromJson(p).price);
                                debugPrint('Home Total $amounts');*/
                                  // total = amounts.sum;

                                  return SubscriptionItemCard(snapshot
                                      .data!.userSubscriptionsList[index]);
                                }
                              }
                            }

                            return Container(
                              child: Text('No Added Subscriptions',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: Style.Colors.secondaryColor2,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18))),
                            );
                          },
                        );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
