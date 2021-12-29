import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/subscriptions.dart';
import 'package:sub_man/style/theme.dart' as Style;

class GeneralSubscriptionItem extends StatelessWidget {
  final Subscriptions subscriptions;

  GeneralSubscriptionItem(this.subscriptions);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(subscriptions.image)))),
      title: Text(subscriptions.name,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
            color: Style.Colors.secondaryColor4,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ))),
      trailing: Icon(
        Icons.add_rounded,
        size: 30,
        color: Style.Colors.secondaryColor4,
      ),
    );
  }
}
