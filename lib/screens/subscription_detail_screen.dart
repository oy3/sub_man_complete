import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/screens/subscriptions_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/subscription_billing_item.dart';
import 'package:sub_man/widgets/utils.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final UserSubscriptions userSubscriptions;

  SubscriptionDetailScreen(this.userSubscriptions);

  @override
  _SubscriptionDetailScreenState createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  late Timer _timer;
  // String? dropdownCategoryValue;
  // String? dropdownBillCycleValue;
  String? dropdownReminderValue;

  var totalAmount;

  Plans? activePlan;

  Repository repository = Repository();

  @override
  void initState() {
    super.initState();

    for (dynamic p in widget.userSubscriptions.plans) {
      if (Plans.fromJson(p).active) {
        activePlan = Plans.fromJson(p);
        break;
      }
    }

    // dropdownCategoryValue = widget.userSubscriptions.category;
    // dropdownBillCycleValue = activePlan!.type.toTitleCase();
    dropdownReminderValue = activePlan!.reminder;

    repository.doGetBillingSum(widget.userSubscriptions.uid).then((value) {
      setState(() {
        totalAmount = value.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.secondaryColor3,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        elevation: 0,
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
       /* actions: [
          Center(
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
        ],*/
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Container(
                width: 100.0,
                height: 100.0,
                margin: EdgeInsets.only(top: 30),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            new NetworkImage(widget.userSubscriptions.image)))),
            SizedBox(height: 10),
            Center(
              child: Text(widget.userSubscriptions.name,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                    color: Style.Colors.secondaryColor4,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ))),
            ),
            SizedBox(height: 5),
            Center(
              child:
                  Text(reportDueDate(calcDueDate(activePlan!.endDate.toDate())),
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        color: Style.Colors.secondaryColor2,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ))),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Style.Colors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Style.Strings.price,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                      Text(
                          Style.Strings.gbpSymbol +
                              activePlan!.price.toString(),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                    ],
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.category,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Text(widget.userSubscriptions.category.toCapitalized(),
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.billDate,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Text(toDate(activePlan!.startDate.toDate()),
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.billCycle,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Text(activePlan!.type.toTitleCase().toCapitalized(),
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Style.Colors.secondaryColor5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ))),
                        /*Container(
                          width: 100,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownBillCycleValue,
                            icon: Icon(Icons.arrow_forward_ios_rounded,
                                color: Style.Colors.secondaryColor2),
                            iconSize: 20,
                            elevation: 16,
                            hint: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Select")),
                            style: TextStyle(color: Style.Colors.secondaryColor2),
                            underline: Container(),
                            items: <String>[
                              'Daily',
                              'Weekly',
                              'Monthly',
                              'Yearly',
                              'Bi-Yearly'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownBillCycleValue = newValue!;
                              });
                            },
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Style.Strings.reminder,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                      Text(activePlan!.reminder.toTitleCase().toCapitalized(),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ))),
                      /*Container(
                        width: 150,
                        child: DropdownButton<String>(
                          value: dropdownReminderValue,
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              color: Style.Colors.secondaryColor2),
                          iconSize: 20,
                          elevation: 16,
                          isExpanded: true,
                          hint: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Select")),
                          style: TextStyle(color: Style.Colors.secondaryColor2),
                          underline: Container(),
                          items: <String>[
                            'None',
                            'At time of event',
                            '1 hour before',
                            '1 day before',
                            '1 week before',
                            '1 month before',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownReminderValue = newValue!;
                            });
                          },
                        ),
                      ),*/
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(Style.Strings.history,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  color: Style.Colors.secondaryColor4,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ))),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Style.Colors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Style.Strings.date,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ))),
                      Text(Style.Strings.amount,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ))),
                    ],
                  ),
                  Divider(),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('subscriptions')
                        .doc(widget.userSubscriptions.uid.trim())
                        .collection('logs')
                        .orderBy('bill_date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(toDate(data['bill_date'].toDate()),
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  color: Style.Colors.secondaryColor2,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ))),
                            trailing: Text(
                                Style.Strings.gbpSymbol +
                                    data['amount'].toDouble().toString(),
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ))),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Style.Strings.total,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor2,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ))),
                      Text(
                          (totalAmount != null)
                              ? Style.Strings.gbpSymbol + totalAmount.toString()
                              : Style.Strings.gbpSymbol + '0.00',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(Style.Strings.delSub,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ))),
              onPressed: () => showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(Style.Strings.delSub,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ))),
                  content: Text(Style.Strings.delDialogDes,
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
                        Navigator.pop(context, 'Delete');
                        await EasyLoading.show(
                          status: 'Deleting...',
                          dismissOnTap: false,
                          maskType: EasyLoadingMaskType.black,
                        ).then((value) {
                          repository
                              .deleteSubscription(widget.userSubscriptions)
                              .then((value) {
                            if (value) {
                              _timer = Timer.periodic(
                                  const Duration(milliseconds: 3000),
                                  (Timer timer) {
                                EasyLoading.showSuccess('Deleted successfully!',
                                    dismissOnTap: false,
                                    maskType: EasyLoadingMaskType.black);
                                _timer.cancel();
                                // Navigator.of(context,rootNavigator: true).pop();
                                // Navigator.pop(context, 'Delete');
                                /*  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubscriptionsScreen()));*/
                              });
                            } else {
                              EasyLoading.showError('Error, Try again',
                                  dismissOnTap: false,
                                  maskType: EasyLoadingMaskType.black);
                            }
                          });
                        });
                      },
                      child: Text(Style.Strings.delete,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ))),
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                padding: EdgeInsets.all(10),
                primary: Colors.red.shade700,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
