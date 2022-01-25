import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/bloc/user_subscription_list_bloc.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/model/user_subscriptions_list_response.dart';
import 'package:sub_man/screens/subscription_detail_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/subscription_item_card.dart';
import 'package:sub_man/widgets/subscription_item_card_loader.dart';

class SubscriptionsScreen extends StatefulWidget {
  @override
  SubscriptionsScreenState createState() => SubscriptionsScreenState();
}

class SubscriptionsScreenState extends State<SubscriptionsScreen> {
  TextEditingController _searchEditingController = TextEditingController();
  static UserSubscriptionsListBloc userSubscriptionsListBloc =
      UserSubscriptionsListBloc();

  @override
  void initState() {
    super.initState();

    userSubscriptionsListBloc.getUserSubscriptionList('name');
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
        margin: EdgeInsets.only(left: 20, right: 20, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subscriptions",
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Style.Colors.titleColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ))),
            SizedBox(height: 20),
            TextField(
              controller: _searchEditingController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: "Search",
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Style.Colors.secondaryColor3,
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              onChanged: (searchString) {
                userSubscriptionsListBloc.doDisplaySubscriptionList(
                    filter: searchString);
              },
            ),
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
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SubscriptionItemCardLoader(false);
                      default:
                        return snapshot.data?.userSubscriptionsList.length != 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data!.userSubscriptionsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  for (dynamic p in snapshot.data!
                                      .userSubscriptionsList[index].plans) {
                                    if (UserPlans.fromJson(p).active) {
                                      return GestureDetector(
                                        child: SubscriptionItemCard(snapshot
                                            .data!
                                            .userSubscriptionsList[index]),
                                        onTap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubscriptionDetailScreen(
                                                      userSubscriptions: snapshot
                                                          .data!
                                                          .userSubscriptionsList[
                                                      index]),
                                            ),
                                          );
                                          if (result == "updated") {
                                            userSubscriptionsListBloc
                                                .getUserSubscriptionList(
                                                'plans');
                                            SubscriptionsScreenState
                                                .userSubscriptionsListBloc
                                                .getUserSubscriptionList(
                                                'name');
                                          }
                                        },
                                      );
                                    }
                                  }

                                  return Container(
                                    child: Text('No Added Subscriptions',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Style
                                                    .Colors.secondaryColor2,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18))),
                                  );
                                },
                              )
                            : Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FluentIcons.add_circle_24_filled,
                                        size: 100,
                                        color: Colors.grey[200],
                                      ),
                                      Text('Add New Subscription'.toUpperCase(),
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.grey[300],
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 25))),
                                    ],
                                  ),
                                ),
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
