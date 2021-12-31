import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:fl_chart/fl_chart.dart';
import 'package:sub_man/widgets/indicator.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>
    with TickerProviderStateMixin {
  String dropdownValue = 'This Year';
  int selectedTabIndex = 0;
  TabController? tabController;
  int touchedIndex = -1;

  Repository repository = Repository();

  var yearData, weekData;

  final List<Map<String, dynamic>> categoryType = [
    {'color': Style.Colors.barColor, 'type': 'Software', 'price': '725.00'},
    {
      'color': Style.Colors.pieColor1,
      'type': 'Entertainment',
      'price': '240.00'
    },
    {'color': Style.Colors.pieColor2, 'type': 'Internet', 'price': '540.00'},
    {'color': Style.Colors.pieColor3, 'type': 'Others', 'price': '315.00'}
  ];

  @override
  void initState() {
    super.initState();

    repository.doGetExpenseByDay().then((value) {
      setState(() {
        weekData = value;
      });
      debugPrint('Week amounts = $weekData');
    });

    repository.doGetExpenseByMonth().then((value) {
      setState(() {
        yearData = value;
      });
      // debugPrint('Month amounts = $yearData');
    });

    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      setState(() {
        selectedTabIndex = tabController!.index;
      });
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Expenses",
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ))),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down_circle_outlined,
                      color: Colors.black),
                  elevation: 16,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                    color: Style.Colors.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  )),
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Today',
                    'This Week',
                    'This Month',
                    'This Year'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Total',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                                SizedBox(height: 15),
                                Text(Style.Strings.gbpSymbol + '240.00',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor4,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    )))
                              ],
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 65,
                              color: Style.Colors.secondaryColor7),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Paid',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                                SizedBox(height: 15),
                                Text(Style.Strings.gbpSymbol + '90.00',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor4,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    )))
                              ],
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 65,
                              color: Style.Colors.secondaryColor7),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Unpaid',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                                SizedBox(height: 15),
                                Text(Style.Strings.gbpSymbol + '150.00',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Style.Colors.secondaryColor4,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    )))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    mainChart(),
                    SizedBox(height: 50),
                    tabBar(),
                    SizedBox(height: 30),
                    selectedTabIndex == 0 ? pieChart() : Container(),
                    SizedBox(height: 50)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarTouchData get _barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              TextStyle(
                color: Style.Colors.barColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlBorderData get _borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get _yearlyBarGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
                y: yearData[0].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                y: yearData[1].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                y: yearData[2].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                y: yearData[3].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                y: yearData[4].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                y: yearData[5].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                y: yearData[6].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
                y: yearData[7].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
                y: yearData[8].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
                y: yearData[9].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
                y: yearData[10].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
                y: yearData[11].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  List<BarChartGroupData> get _weeklyBarGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
                y: weekData[0].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                y: weekData[1].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                y: weekData[2].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                y: weekData[3].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                y: weekData[4].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                y: weekData[5].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                y: weekData[6].toDouble(),
                width: 20,
                colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  List<BarChartGroupData> get _dayBarGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(y: 90, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(y: 100, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(y: 140, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(y: 150, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(y: 130, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(y: 100, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(y: 80, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(y: 100, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(y: 104, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(y: 105, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(y: 103, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(y: 100, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 12,
          barRods: [
            BarChartRodData(y: 40, width: 20, colors: [Style.Colors.barColor])
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  Widget tabBar() => TabBar(
        controller: tabController,
        indicatorColor: Style.Colors.barColor,
        unselectedLabelColor: Style.Colors.secondaryColor2,
        labelColor: Style.Colors.barColor,
        indicator: UnderlineTabIndicator(),
        labelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        )),
        onTap: (value) {
          setState(() {
            selectedTabIndex = value;
          });
        },
        tabs: [
          Align(child: Text("Category"), alignment: Alignment.centerRight),
          Align(child: Text("Service"), alignment: Alignment.centerLeft),
        ],
      );

  Widget pieChart() {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      sections: showingSections()),
                ),
              ),
            ),
            SizedBox(height: 60),
            ListView.separated(
              shrinkWrap: true,
              itemCount: categoryType.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                var item;
                var data = categoryType[index];

                  item = Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Indicator(
                          textColor: Style.Colors.secondaryColor2,
                          color: data['color'],
                          text: data['type'].toString(),
                          isSquare: false,
                        ),
                        Text(
                          Style.Strings.gbpSymbol + data['price'].toString(),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            color: Style.Colors.secondaryColor5,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          )),
                        )
                      ],
                    ),
                  );

                return item;
              },
            ),
            /*Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Style.Colors.barColor,
                  text: 'Software',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Style.Colors.pieColor1,
                  text: 'Entertainment',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Style.Colors.pieColor2,
                  text: 'Internet',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Style.Colors.pieColor3,
                  text: 'Others',
                  isSquare: false,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),*/
          ])),
    );
  }

  Widget mainChart() {
    return AspectRatio(
        aspectRatio: 1,
        child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: Colors.white,
            child: BarChart(
              BarChartData(
                barTouchData: _barTouchData,
                titlesData: changeChartBottom(dropdownValue),
                borderData: _borderData,
                barGroups: changeChartLeft(dropdownValue),
                alignment: BarChartAlignment.spaceAround,
              ),
              swapAnimationDuration: Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            )));
  }

  FlTitlesData get _yearTitlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: Style.Colors.secondaryColor2,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Jan';
              case 1:
                return '';
              case 2:
                return 'Mar';
              case 3:
                return '';
              case 4:
                return 'May';
              case 5:
                return '';
              case 6:
                return 'Jul';
              case 7:
                return '';
              case 8:
                return 'Sep';
              case 9:
                return '';
              case 10:
                return 'Nov';
              case 11:
                return '';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTextStyles: (context, value) => TextStyle(
                  color: Style.Colors.secondaryColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  FlTitlesData get _weekTitlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: Style.Colors.secondaryColor2,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tues';
              case 2:
                return 'Wed';
              case 3:
                return 'Thurs';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTextStyles: (context, value) => TextStyle(
                  color: Style.Colors.secondaryColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  FlTitlesData get _dayTitlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: Style.Colors.secondaryColor2,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '0:00';
              case 1:
                return '';
              case 2:
                return '4:00';
              case 3:
                return '';
              case 4:
                return '8:00';
              case 5:
                return '';
              case 6:
                return '12:00';
              case 7:
                return '';
              case 8:
                return '16:00';
              case 9:
                return '';
              case 10:
                return '20:00';
              case 11:
                return '';
              case 12:
                return '24:00';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTextStyles: (context, value) => TextStyle(
                  color: Style.Colors.secondaryColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Style.Colors.barColor,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Style.Colors.mainColor),
          );
        case 1:
          return PieChartSectionData(
            color: Style.Colors.pieColor1,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Style.Colors.mainColor),
          );
        case 2:
          return PieChartSectionData(
            color: Style.Colors.pieColor2,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Style.Colors.mainColor),
          );
        case 3:
          return PieChartSectionData(
            color: Style.Colors.pieColor3,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Style.Colors.mainColor),
          );
        default:
          throw Error();
      }
    });
  }

  FlTitlesData changeChartBottom(String value) {
    if (value == 'Today') {
      return _dayTitlesData;
    } else if (value == 'This Week') {
      return _weekTitlesData;
    } else if (value == 'This Month') {
      return FlTitlesData(show: false);
    } else if (value == 'This Year') {
      return _yearTitlesData;
    } else {
      return FlTitlesData(show: false);
    }
  }

  List<BarChartGroupData> changeChartLeft(String value) {
    if (value == 'Today') {
      return _dayBarGroups;
    } else if (value == 'This Week') {
      return _weeklyBarGroups;
    } else if (value == 'This Month') {
      return [];
    } else if (value == 'This Year') {
      return _yearlyBarGroups;
    } else {
      return [];
    }
  }
}
