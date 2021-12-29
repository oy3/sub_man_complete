import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_man/bloc/subscription_list_bloc.dart';
import 'package:sub_man/model/subscription_list_response.dart';
import 'package:sub_man/style/theme.dart' as Style;
import 'package:sub_man/widgets/bottom_custom_sub_sheet.dart';
import 'package:sub_man/widgets/bottom_sub_detail_sheet.dart';
import 'package:sub_man/widgets/general_subscription_item.dart';
import 'package:sub_man/widgets/subscription_item_card_loader.dart';

class BottomHomeSheet extends StatefulWidget {
  @override
  _BottomHomeSheetState createState() => _BottomHomeSheetState();
}

class _BottomHomeSheetState extends State<BottomHomeSheet> {
  TextEditingController _searchEditingController = TextEditingController();
  SubscriptionListBloc subscriptionListBloc = SubscriptionListBloc();

  @override
  void initState() {
    super.initState();

    subscriptionListBloc.getSubscriptionList();
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
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: Text(Style.Strings.addSub,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
              ))),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 3),
                child: TextField(
                  controller: _searchEditingController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      hintText: "Search",
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Style.Colors.secondaryColor3,
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  onChanged: (searchString) {
                    subscriptionListBloc.doDisplaySubscriptionList(
                        filter: searchString);
                  },
                ),
              ),
              Divider(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<SubscriptionListResponse>(
                      stream: subscriptionListBloc.subject.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<SubscriptionListResponse> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SubscriptionItemCardLoader(true);
                          default:
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.subscriptionList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: GeneralSubscriptionItem(
                                      snapshot.data!.subscriptionList[index]),
                                  onTap: () {
                                    showModalBottomSheet(
                                      enableDrag: false,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          BottomSubDetailSheet(snapshot
                                              .data!.subscriptionList[index]),
                                    );
                                  },
                                );
                              },
                            );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(30),
          child: ElevatedButton(
            child: Text(Style.Strings.addSub2,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ))),
            onPressed: () {
              showModalBottomSheet(
                enableDrag: false,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) => BottomCustomSubSheet(),
              );
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
