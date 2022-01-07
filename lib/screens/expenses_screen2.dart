import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/repository/repository.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/indicator.dart';

class ExpensesScreen2 extends StatefulWidget {
  @override
  State<ExpensesScreen2> createState() => _ExpensesScreen2State();
}

class _ExpensesScreen2State extends State<ExpensesScreen2>
    with TickerProviderStateMixin {
  String dropdownValue = 'Today';
  int selectedTabIndex = 0;
  TabController? tabController;

  Repository repository = Repository();

  List<Map<String, dynamic>> nullPieData = [
    {'domain': 'Null', 'measure': 100},
  ];

  List<Map<String, dynamic>> dayPieData = [
    {'domain': 'Null', 'measure': 100},
  ];

  List<Map<String, dynamic>> weekPieData = [
    {'domain': 'Null', 'measure': 100},
  ];

  List<Map<String, dynamic>> monthPieData = [
    {'domain': 'Null', 'measure': 100},
  ];

  List<Map<String, dynamic>> yearPieData = [
    {'domain': 'Null', 'measure': 100},
  ];

  List<Map<String, dynamic>> dayChartData = [
    {'domain': '0', 'measure': 0},
    {'domain': '2', 'measure': 0},
    {'domain': '4', 'measure': 0},
    {'domain': '6', 'measure': 0},
    {'domain': '8', 'measure': 0},
    {'domain': '10', 'measure': 0},
    {'domain': '12', 'measure': 0},
    {'domain': '14', 'measure': 0},
    {'domain': '16', 'measure': 0},
    {'domain': '18', 'measure': 0},
    {'domain': '20', 'measure': 0},
    {'domain': '22', 'measure': 0},
  ];

  List<Map<String, dynamic>> weekChartData = [
    {'domain': 'Mon', 'measure': 0},
    {'domain': 'Tues', 'measure': 0},
    {'domain': 'Wed', 'measure': 0},
    {'domain': 'Thurs', 'measure': 0},
    {'domain': 'Fri', 'measure': 0},
    {'domain': 'Sat', 'measure': 0},
    {'domain': 'Sun', 'measure': 0}
  ];

  List<Map<String, dynamic>> monthChartData = [
    {'domain': 'Week 1', 'measure': 0},
    {'domain': 'Week 2', 'measure': 0},
    {'domain': 'Week 3', 'measure': 0},
    {'domain': 'Week 4', 'measure': 0},
  ];

  List<Map<String, dynamic>> yearChartData = [
    {'domain': 'Jan', 'measure': 0},
    {'domain': 'Feb', 'measure': 0},
    {'domain': 'Mar', 'measure': 0},
    {'domain': 'Apr', 'measure': 0},
    {'domain': 'May', 'measure': 0},
    {'domain': 'Jun', 'measure': 0},
    {'domain': 'Jul', 'measure': 0},
    {'domain': 'Aug', 'measure': 0},
    {'domain': 'Sep', 'measure': 0},
    {'domain': 'Nov', 'measure': 0},
    {'domain': 'Dec', 'measure': 0},
  ];

  List<Map<String, dynamic>> yearHorizontalChartData = [];
  List<Map<String, dynamic>> monthHorizontalChartData = [];
  List<Map<String, dynamic>> weekHorizontalChartData = [];
  List<Map<String, dynamic>> dayHorizontalChartData = [];

  @override
  void initState() {
    super.initState();

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
                                Text(Style.Strings.gbpSymbol + '0.00',
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
                                Text(Style.Strings.gbpSymbol + '0.00',
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
                                Text(Style.Strings.gbpSymbol + '0.00',
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
                    FutureBuilder(
                      future: selectFuture(dropdownValue),
                      builder: (context, asyncSnapshot) {
                        if (!asyncSnapshot.hasError) {
                          if (asyncSnapshot.hasData) {
                            if (dropdownValue == "Today") {
                              dayChartData = asyncSnapshot.data
                                  as List<Map<String, dynamic>>;
                            } else if (dropdownValue == "This Week") {
                              weekChartData = asyncSnapshot.data
                                  as List<Map<String, dynamic>>;
                            } else if (dropdownValue == "This Year") {
                              yearChartData = asyncSnapshot.data
                                  as List<Map<String, dynamic>>;
                            }
                          }
                        } else {
                          debugPrint('Error loading data ');
                        }

                        return mainChart();
                      },
                    ),
                    SizedBox(height: 50),
                    tabBar(),
                    SizedBox(height: 30),
                    selectedTabIndex == 0
                        ? Column(
                            children: [
                              FutureBuilder(
                                future: selectPieFuture(dropdownValue),
                                builder: (context, asyncSnapshot) {
                                  if (!asyncSnapshot.hasError) {
                                    if (asyncSnapshot.hasData) {
                                      var list = asyncSnapshot.data
                                          as Map<int, dynamic>;

                                      num software = list[0];
                                      num entertainment = list[1];
                                      num internet = list[2];
                                      num others = list[3];

                                      num softwarePer = (software / (software + entertainment + internet + others)) * 100,
                                          entertainmentPer = (entertainment /
                                                  (software +
                                                      entertainment +
                                                      internet +
                                                      others)) *
                                              100,
                                          internetPer = (internet /
                                                  (software +
                                                      entertainment +
                                                      internet +
                                                      others)) *
                                              100,
                                          othersPer = (others /
                                                  (software +
                                                      entertainment +
                                                      internet +
                                                      others)) *
                                              100;

                                      var finalData;

                                      if (softwarePer.isNaN ||
                                          softwarePer.isInfinite &&
                                              entertainmentPer.isNaN ||
                                          entertainmentPer.isInfinite &&
                                              internetPer.isNaN ||
                                          internetPer.isInfinite &&
                                              othersPer.isNaN ||
                                          othersPer.isInfinite) {
                                        finalData = [
                                          {'domain': 'Null', 'measure': 100},
                                        ];
                                      } else {
                                        finalData = [
                                          {
                                            'domain': 'Software',
                                            'measure': softwarePer
                                          },
                                          {
                                            'domain': 'Entertainment',
                                            'measure': entertainmentPer
                                          },
                                          {
                                            'domain': 'Internet',
                                            'measure': internetPer
                                          },
                                          {
                                            'domain': 'Others',
                                            'measure': othersPer
                                          },
                                        ];
                                      }

                                      if (dropdownValue == "Today") {
                                        dayPieData = finalData;
                                      } else if (dropdownValue == "This Week") {
                                        weekPieData = finalData;
                                      } else if (dropdownValue == "This Year") {
                                        yearPieData = finalData;
                                      }

                                      return pieChart();
                                    } else {
                                      return AspectRatio(
                                          aspectRatio: 12 / 9,
                                          child: DChartPie(
                                            data: [
                                              {
                                                'domain': 'Null',
                                                'measure': 100
                                              },
                                            ],
                                            fillColor: (pieData, index) =>
                                                Colors.grey[300],
                                            donutWidth: 40,
                                            showLabelLine: false,
                                            labelFontSize: 0,
                                            labelColor: Colors.black,
                                          ));
                                    }
                                  }

                                  return Container(
                                    height: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircularProgressIndicator(
                                            color: Style.Colors.barColor),
                                        Text('Loading PieChart...',
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              color: Style.Colors.barColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                            )))
                                      ],
                                    ),
                                  );
                                },
                              ),
                              FutureBuilder(
                                future: selectPieFuture(dropdownValue),
                                builder: (context, snapshot) {
                                  List<Map<String, dynamic>> category = [
                                    {
                                      'color': Style.Colors.barColor,
                                      'type': 'Software',
                                      'price': 0
                                    },
                                    {
                                      'color': Style.Colors.pieColor1,
                                      'type': 'Entertainment',
                                      'price': 0
                                    },
                                    {
                                      'color': Style.Colors.pieColor2,
                                      'type': 'Internet',
                                      'price': 0
                                    },
                                    {
                                      'color': Style.Colors.pieColor3,
                                      'type': 'Others',
                                      'price': 0
                                    }
                                  ];

                                  if (!snapshot.hasError) {
                                    if (snapshot.hasData) {
                                      var list =
                                          snapshot.data as Map<int, dynamic>;
                                      category = [
                                        {
                                          'color': Style.Colors.barColor,
                                          'type': 'Software',
                                          'price': list[0]
                                        },
                                        {
                                          'color': Style.Colors.pieColor1,
                                          'type': 'Entertainment',
                                          'price': list[1]
                                        },
                                        {
                                          'color': Style.Colors.pieColor2,
                                          'type': 'Internet',
                                          'price': list[2]
                                        },
                                        {
                                          'color': Style.Colors.pieColor3,
                                          'type': 'Others',
                                          'price': list[3]
                                        }
                                      ];

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: category.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var item;
                                          var data = category[index];

                                          item = Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Indicator(
                                                  textColor: Style
                                                      .Colors.secondaryColor2,
                                                  color: data['color'],
                                                  text: data['type'].toString(),
                                                  isSquare: false,
                                                ),
                                                Text(
                                                  Style.Strings.gbpSymbol +
                                                      data['price'].toString(),
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                    color: Style
                                                        .Colors.secondaryColor5,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  )),
                                                )
                                              ],
                                            ),
                                          );

                                          return item;
                                        },
                                      );
                                    }
                                  }

                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: category.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item;
                                      var data = category[index];

                                      item = Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Indicator(
                                              textColor:
                                                  Style.Colors.secondaryColor2,
                                              color: data['color'],
                                              text: data['type'].toString(),
                                              isSquare: false,
                                            ),
                                            Text(
                                              Style.Strings.gbpSymbol +
                                                  data['price'].toString(),
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                color: Style
                                                    .Colors.secondaryColor5,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              )),
                                            )
                                          ],
                                        ),
                                      );

                                      return item;
                                    },
                                  );
                                },
                              ),
                              /*ListView.separated(
                                shrinkWrap: true,
                                itemCount: categoryType.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemBuilder: (BuildContext context, int index) {
                                  var item;
                                  var data = categoryType[index];

                                  item = Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Indicator(
                                          textColor:
                                              Style.Colors.secondaryColor2,
                                          color: data['color'],
                                          text: data['type'].toString(),
                                          isSquare: false,
                                        ),
                                        Text(
                                          Style.Strings.gbpSymbol +
                                              data['price'].toString(),
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
                              ),*/
                            ],
                          )
                        : FutureBuilder(
                            future: selectServiceFuture(dropdownValue),
                            builder: (context, snapshot) {
                              if (!snapshot.hasError) {
                                if (snapshot.hasData) {
                                  if (dropdownValue == "Today") {
                                    dayHorizontalChartData = snapshot.data
                                        as List<Map<String, dynamic>>;
                                  } else if (dropdownValue == "This Week") {
                                    weekHorizontalChartData = snapshot.data
                                        as List<Map<String, dynamic>>;
                                  } else if (dropdownValue == "This Year") {
                                    yearHorizontalChartData = snapshot.data
                                        as List<Map<String, dynamic>>;
                                  }

                                  return horizontalBarChart();
                                }
                              }
                              return AspectRatio(
                                aspectRatio: 1,
                                child: DChartBar(
                                  data: [
                                    {
                                      'id': 'Bar',
                                      'data': [
                                        {'domain': '', 'measure': 0}
                                      ]
                                    },
                                  ],
                                  domainLabelPaddingToAxisLine: 16,
                                  axisLineColor: Colors.grey[400],
                                  measureLabelPaddingToAxisLine: 16,
                                  barColor: (barData, index, id) =>
                                      Style.Colors.barColor,
                                  verticalDirection: false,
                                  barValue: (barData, index) =>
                                      '${barData['measure']}',
                                  showBarValue: true,
                                  barValueColor: Colors.white,
                                  barValueFontSize: 12,
                                  barValueAnchor: BarValueAnchor.end,
                                  barValuePosition: BarValuePosition.auto,
                                ),
                              );
                            },
                          ),
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

  Future<List>? selectFuture(String option) {
    Future<List>? repo;

    switch (option) {
      case 'Today':
        repo = repository.doGetExpenseByHour();
        break;
      case 'This Week':
        repo = repository.doGetExpenseByDay();
        break;
      case 'This Month':
        repo = null;
        break;
      case 'This Year':
        repo = repository.doGetExpenseByMonth();
        break;
      default:
        repo = null;
    }

    return repo;
  }

  Future<Map<int, dynamic>>? selectPieFuture(String option) {
    Future<Map<int, dynamic>>? repo;

    switch (option) {
      case 'Today':
        repo = repository.doGetDayAmountByCategory();
        break;
      case 'This Week':
        repo = repository.doGetWeekAmountByCategory();
        break;
      case 'This Month':
        repo = null;
        break;
      case 'This Year':
        repo = repository.doGetYearAmountByCategory();
        break;
      default:
        repo = null;
    }

    return repo;
  }

  Future<List<Map<String, dynamic>>>? selectServiceFuture(String option) {
    Future<List<Map<String, dynamic>>>? repo;

    switch (option) {
      case 'Today':
        repo = repository.doGetHourlyServices();
        break;
      case 'This Week':
        repo = repository.doGetDailyServices();
        break;
      case 'This Month':
        repo = null;
        break;
      case 'This Year':
        repo = repository.doGetMonthlyServices();
        break;
      default:
        repo = null;
    }

    return repo;
  }

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

  Widget mainChart() {
    return AspectRatio(
      aspectRatio: 1,
      child: DChartBar(
        data: [
          {
            'id': 'Bar',
            'data': changeChart(dropdownValue),
          },
        ],
        // yAxisTitle: 'Price(£)',
        // xAxisTitle: 'Hours(24Hrs)',
        domainLabelPaddingToAxisLine: 16,
        axisLineTick: 2,
        axisLinePointTick: 2,
        axisLinePointWidth: 10,
        axisLineColor: Colors.grey[400],
        measureLabelPaddingToAxisLine: 16,
        barColor: (barData, index, id) => Style.Colors.barColor,
        showBarValue: true,
      ),
    );
  }

  Widget pieChart() {
    return AspectRatio(
      aspectRatio: 12 / 9,
      child: DChartPie(
        data: changePieChart(dropdownValue),
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Software':
              return Style.Colors.barColor;
            case 'Entertainment':
              return Style.Colors.pieColor1;
            case 'Internet':
              return Style.Colors.pieColor2;
            case 'Others':
              return Style.Colors.pieColor3;
            default:
              return Colors.grey[300];
          }
        },
        showLabelLine: false,
        strokeWidth: 0,
        labelFontSize: 0,
        donutWidth: 40,
        labelColor: Colors.white,
      ),
    );
  }

  Widget horizontalBarChart() {
    return AspectRatio(
      aspectRatio: 1,
      child: DChartBar(
        data: [
          {'id': 'Bar', 'data': changeServiceChart(dropdownValue)},
        ],
        domainLabelPaddingToAxisLine: 16,
        axisLineColor: Colors.grey[400],
        measureLabelPaddingToAxisLine: 16,
        barColor: (barData, index, id) => Style.Colors.barColor,
        verticalDirection: false,
        domainLabelRotation: 270,
        barValue: (barData, index) => '${barData['measure']}',
        showBarValue: true,
        barValueColor: Colors.white,
        barValueFontSize: 12,
        barValueAnchor: BarValueAnchor.end,
        barValuePosition: BarValuePosition.auto,
      ),
    );
  }

  List<Map<String, dynamic>> changeChart(String value) {
    if (value == 'Today') {
      return dayChartData;
    } else if (value == 'This Week') {
      return weekChartData;
    } else if (value == 'This Month') {
      return monthChartData;
    } else if (value == 'This Year') {
      return yearChartData;
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> changePieChart(String value) {
    if (value == 'Today') {
      return dayPieData;
    } else if (value == 'This Week') {
      return weekPieData;
    } else if (value == 'This Month') {
      return monthPieData;
    } else if (value == 'This Year') {
      return yearPieData;
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> changeServiceChart(String value) {
    if (value == 'Today') {
      return dayHorizontalChartData;
    } else if (value == 'This Week') {
      return weekHorizontalChartData;
    } else if (value == 'This Month') {
      return monthHorizontalChartData;
    } else if (value == 'This Year') {
      return yearHorizontalChartData;
    } else {
      return [];
    }
  }
}
