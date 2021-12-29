import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/style/theme.dart' as Style;

class SubscriptionBillingItem extends StatefulWidget {
  final Logs logs;

  const SubscriptionBillingItem(this.logs);

  @override
  _SubscriptionBillingItemState createState() =>
      _SubscriptionBillingItemState();
}

class _SubscriptionBillingItemState extends State<SubscriptionBillingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Dec 10, 2021',
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                color: Style.Colors.secondaryColor2,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ))),
          Text(Style.Strings.gbpSymbol + widget.logs.amount.toString(),
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ))),
        ],
      ),
    );
  }
}
