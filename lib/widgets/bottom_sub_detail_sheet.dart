import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/model/subscriptions.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/screens/home_screen.dart';
import 'package:sub_man/screens/subscription_detail_screen.dart';
import 'package:sub_man/screens/subscriptions_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/utils.dart';

class BottomSubDetailSheet extends StatefulWidget {
  final Subscriptions subscriptions;

  BottomSubDetailSheet(this.subscriptions);

  @override
  _BottomSubDetailSheetState createState() => _BottomSubDetailSheetState();
}

class _BottomSubDetailSheetState extends State<BottomSubDetailSheet> {
  late Timer _timer;
  String? selectedBillDate = "";
  String? dropdownReminderValue;
  String? dropdownBillPlanValue;
  String? dropdownBillCycleValue;
  late DateTime startDate;
  late Subscriptions subscriptions;
  List<String> billingCycle = [];
  List<Plans> billingType = [];
  num? subPrice;
  Repository _repository = Repository();

  @override
  void initState() {
    super.initState();

    subscriptions = widget.subscriptions;

    for (dynamic plan in subscriptions.plans) {
      var plans = Plans.fromJson(plan);
      if (!billingCycle.contains(plans.type)) {
        billingCycle.add(plans.type);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (_, controller) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
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
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(top: 30),
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.contain,
                          image: new NetworkImage(subscriptions.image)))),
              SizedBox(height: 10),
              Center(
                child: Text(subscriptions.name,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.secondaryColor4,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
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
                    Container(
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
                          Text(subscriptions.name.toTitleCase(),
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
                          Text(Style.Strings.category,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ))),
                          Text(subscriptions.category.toTitleCase(),
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              )))
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
                          GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  theme: DatePickerTheme(
                                      backgroundColor: Colors.white,
                                      itemStyle: TextStyle(color: Colors.black),
                                      doneStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2040, 12, 31),
/*                                      onChanged: (date) {
                                        print(
                                            'change: ${getMonth(date.month) +
                                                ' ' + date.day.toString() +
                                                ', ' + date.year.toString()}');
                                      },*/
                                  onConfirm: (date) {
                                setState(() {
                                  startDate = date;
                                  selectedBillDate = toDate(date);
                                });
                                print('confirm $selectedBillDate');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Wrap(
                              children: [
                                (selectedBillDate == "")
                                    ? Text(Style.Strings.select,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          color: Style.Colors.secondaryColor2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        )))
                                    : Text(selectedBillDate!,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          color: Style.Colors.secondaryColor2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ))),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 20,
                                    color: Style.Colors.secondaryColor2)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.billCycle,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Expanded(
                          child: DropdownButton<String>(
                            value: dropdownBillCycleValue,
                            icon: Icon(Icons.arrow_forward_ios_rounded,
                                color: Style.Colors.secondaryColor2),
                            iconSize: 20,
                            elevation: 16,
                            isExpanded: true,
                            hint: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Select")),
                            style:
                                TextStyle(color: Style.Colors.secondaryColor2),
                            underline: Container(),
                            items: billingCycle
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(e.toTitleCase())),
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownBillCycleValue = newValue!;

                                billingType.clear();
                                dropdownBillPlanValue = null;

                                for (dynamic plan in subscriptions.plans) {
                                  var plans = Plans.fromJson(plan);
                                  if (plans.type == dropdownBillCycleValue) {
                                    billingType.add(plans);
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.plan,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Expanded(
                          child: DropdownButton<String>(
                            value: dropdownBillPlanValue,
                            icon: Icon(Icons.arrow_forward_ios_rounded,
                                color: Style.Colors.secondaryColor2),
                            iconSize: 20,
                            elevation: 16,
                            isExpanded: true,
                            hint: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Select")),
                            style:
                                TextStyle(color: Style.Colors.secondaryColor2),
                            underline: Container(),
                            items: billingType.map((e) {
                              if (dropdownBillCycleValue == null)
                                dropdownBillCycleValue = e.name;

                              return DropdownMenuItem<String>(
                                value: e.name,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(e.name.toTitleCase())),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownBillPlanValue = newValue;

                                for (dynamic plan in subscriptions.plans) {
                                  var plans = Plans.fromJson(plan);
                                  if (plans.name == dropdownBillPlanValue) {
                                    subPrice = plans.price;
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
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
                              (dropdownBillPlanValue == null)
                                  ? "0.00"
                                  : subPrice.toString(),
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              )))
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
                        Container(
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
                            style:
                                TextStyle(color: Style.Colors.secondaryColor2),
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
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(30),
          child: ElevatedButton(
            child: Text(Style.Strings.saveSub,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ))),
            onPressed: () async {
              await EasyLoading.show(
                status: 'Loading...',
                dismissOnTap: false,
                maskType: EasyLoadingMaskType.black,
              ).then((value) {
                _repository
                    .addSub(
                        subscriptions.image,
                        subscriptions.category,
                        subscriptions.name,
                        dropdownBillCycleValue!,
                        dropdownBillPlanValue!,
                        subPrice!,
                        startDate,
                        dropdownReminderValue!)
                    .then((value) {
                  if (value.isNotEmpty) {
                    print("Done Saving");

                    var endDate = startDate.add(
                        Duration(days: subEndDate(dropdownBillCycleValue!)));

                    var detailsData = {
                      'category': subscriptions.category,
                      'image': subscriptions.image,
                      'name': subscriptions.name,
                      'uid': value,
                      'plans': [
                        {
                          'name': dropdownBillPlanValue,
                          'price': subPrice,
                          'start_date': Timestamp.fromDate(startDate),
                          'end_date': Timestamp.fromDate(endDate),
                          'reminder': dropdownReminderValue,
                          'type': dropdownBillCycleValue,
                          'active': true
                        }
                      ]
                    };

                    _timer = Timer.periodic(const Duration(milliseconds: 3000),
                        (Timer timer) async {
                      EasyLoading.showSuccess('Saved successfully!',
                          dismissOnTap: false,
                          maskType: EasyLoadingMaskType.black);
                      _timer.cancel();
                      SubscriptionsScreenState.userSubscriptionsListBloc
                          .getUserSubscriptionList('name');
                      HomeScreenState.userSubscriptionsListBloc
                          .getUserSubscriptionList('plans');
                      var result = await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionDetailScreen(
                                  userSubscriptions: UserSubscriptions.fromJson(
                                      detailsData))));

                      if (result == "updated") {
                        SubscriptionsScreenState.userSubscriptionsListBloc
                            .getUserSubscriptionList('name');
                        HomeScreenState.userSubscriptionsListBloc
                            .getUserSubscriptionList('plans');
                      }
                    });
                  } else {
                    print("Something went wrong");
                    EasyLoading.showError('Error, Try again',
                        dismissOnTap: false,
                        maskType: EasyLoadingMaskType.black);
                  }
                });
              });
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
  }
}
