import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sub_man/bloc/user_subscription_list_bloc.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/screens/subscription_detail_screen.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/utils.dart';

enum ImageSourceType { gallery, camera }

class BottomCustomSubSheet extends StatefulWidget {
  @override
  _BottomCustomSubSheetState createState() => _BottomCustomSubSheetState();
}

class _BottomCustomSubSheetState extends State<BottomCustomSubSheet> {
  late Timer _timer;
  var _image;
  var imagePicker;
  String? dropdownCategoryValue;
  String? selectedBillDate = "";
  late DateTime startDate;
  String? dropdownBillCycleValue;
  String? dropdownReminderValue;
  final _nameTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _planTextController = TextEditingController();

  UserSubscriptionsListBloc customSubscriptionBloc =
      UserSubscriptionsListBloc();
  Repository _repository = Repository();

  @override
  void initState() {
    super.initState();

    imagePicker = new ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();

    _nameTextController.dispose();
    _priceTextController.dispose();
    dropdownCategoryValue = "";
    selectedBillDate = "";
    dropdownBillCycleValue = "";
    _planTextController.dispose();
    dropdownReminderValue = "";
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
              GestureDetector(
                onTap: () async {
                  var source = ImageSource.gallery;
                  XFile image = await imagePicker.pickImage(source: source);
                  setState(() {
                    _image = File(image.path);
                    debugPrint('image: $_image');
                  });
                },
                child: _image != null
                    ? Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new FileImage(_image))),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Style.Colors.secondaryColor7,
                            shape: BoxShape.circle),
                        child: Icon(Icons.image_outlined,
                            size: 85, color: Style.Colors.secondaryColor6),
                      ),
              ),
              SizedBox(height: 50),
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
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextField(
                              controller: _nameTextController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.titleColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              )),
                              decoration: null,
                              textAlign: TextAlign.end,
                              cursorColor: Style.Colors.titleColor,
                              // controller: _nameController,
                            ),
                          )
                        ],
                      ),
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
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextField(
                              controller: _priceTextController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.titleColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              )),
                              decoration: null,
                              textAlign: TextAlign.end,
                              cursorColor: Style.Colors.titleColor,
                              // controller: _nameController,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Style.Strings.category,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Style.Colors.secondaryColor5,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                        Container(
                          width: 120,
                          child: DropdownButton<String>(
                            value: dropdownCategoryValue,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_forward_ios_rounded,
                                color: Style.Colors.secondaryColor2),
                            iconSize: 20,
                            elevation: 16,
                            hint: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Select")),
                            style:
                                TextStyle(color: Style.Colors.secondaryColor2),
                            underline: Container(),
                            items: <String>[
                              'Software',
                              'Entertainment',
                              'Internet',
                              'Others'
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
                                dropdownCategoryValue = newValue!;
                              });
                            },
                          ),
                        )
                      ],
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
                                  /*   onChanged: (date) {
                                print(
                                    'change: ${getMonth(date.month) + ' ' + date.day.toString() + ', ' + date.year.toString()}');
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
                            child: (selectedBillDate == "")
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(Style.Strings.select,
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                            color: Style.Colors.secondaryColor2,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ))),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: Style.Colors.secondaryColor2)
                                    ],
                                  )
                                : Text(selectedBillDate!,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.titleColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ))),
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
                        Container(
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
                            style:
                                TextStyle(color: Style.Colors.secondaryColor2),
                            underline: Container(),
                            items: <String>[
                              'Hourly',
                              'Daily',
                              'Weekly',
                              'Monthly',
                              'Yearly',
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
                        ),
                      ],
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Style.Strings.plan,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.secondaryColor5,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ))),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextField(
                              controller: _planTextController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Style.Colors.titleColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              )),
                              decoration: null,
                              textAlign: TextAlign.end,
                              cursorColor: Style.Colors.titleColor,
                              // controller: _nameController,
                            ),
                          )
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
              ).then((value) async {
                _repository
                    .addCustomSub(
                        _image,
                        dropdownCategoryValue!,
                        _nameTextController.text,
                        (dropdownBillCycleValue!.toLowerCase()),
                        _planTextController.text,
                        double.parse(_priceTextController.text),
                        startDate,
                        dropdownReminderValue!)
                    .then((value) {
                  if (value) {
                    print("Done Saving");
                    _timer = Timer.periodic(const Duration(milliseconds: 3000),
                        (Timer timer) {
                      EasyLoading.showSuccess('Saved successfully!',
                          dismissOnTap: false,
                          maskType: EasyLoadingMaskType.black);
                      _timer.cancel();
                       /* Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscriptionDetailScreen()));*/
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
