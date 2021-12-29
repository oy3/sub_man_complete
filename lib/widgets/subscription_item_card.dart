import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/screens/subscription_detail_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/utils.dart';

class SubscriptionItemCard extends StatefulWidget {
  final UserSubscriptions userSubscriptions;

  SubscriptionItemCard(this.userSubscriptions);

  @override
  _SubscriptionItemCardState createState() => _SubscriptionItemCardState();
}

class _SubscriptionItemCardState extends State<SubscriptionItemCard> {
  Plans? activePlan;

  @override
  void initState() {
    super.initState();

    for (dynamic p in widget.userSubscriptions.plans) {
      if (Plans.fromJson(p).active) {
        activePlan = Plans.fromJson(p);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SubscriptionDetailScreen(widget.userSubscriptions),
          ),
        );
      },
      child: Container(
        decoration: ShapeDecoration(
          color: Style.Colors.secondaryColor3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.all(10),
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(widget.userSubscriptions.image)))),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userSubscriptions.name,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.secondaryColor2,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ))),
                Text(reportDueDate(calcDueDate(activePlan!.endDate.toDate())),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.secondaryColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ))),
              ],
            ),
            Spacer(),
            Text(Style.Strings.gbpSymbol + activePlan!.price.toString(),
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Style.Colors.secondaryColor4,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ))),
            Icon(
              FluentIcons.chevron_right_24_filled,
              color: Style.Colors.secondaryColor4,
            )
          ],
        ),
      ),
    );
  }
}
