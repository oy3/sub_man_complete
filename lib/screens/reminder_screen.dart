import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/style/theme.dart' as Style;

class ReminderScreen extends StatelessWidget {
  final reminders = [
    'Netflix will expire on 30th of January 2022',
    'Two',
    'Three'
  ];
  final List<Map<String, dynamic>> list = [
    {'name': 'Netflix', 'date': '30th of January 2022'},
    {'name': 'Hulu', 'date': '03rd of December 2022'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Style.Colors.mainColor,
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
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              var item;
              var data = list[index];

                item = Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text('${data['name']} will expire on the ${data['date']}',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor4,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          )))
                    ],
                  ),
                );

              return item;
            },
          ),
        ));
  }
}
