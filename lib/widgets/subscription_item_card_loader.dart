import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sub_man/style/theme.dart' as Style;

class SubscriptionItemCardLoader extends StatelessWidget {
  final bool change;

  const SubscriptionItemCardLoader(this.change);

  @override
  Widget build(BuildContext context) {
    return change == false ? first() : second();
  }

  Widget first() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          decoration: ShapeDecoration(
            color: Style.Colors.secondaryColor3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          margin: EdgeInsets.only(bottom: 15),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300, shape: BoxShape.circle)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: Colors.grey.shade300, width: 100, height: 20),
                    SizedBox(height: 5),
                    Container(
                        color: Colors.grey.shade300, width: 150, height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget second() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200, shape: BoxShape.circle)),
                SizedBox(width: 10),
                Container(color: Colors.grey.shade200, width: 100, height: 20),
              ],
            ),
          ),
        );
      },
      itemCount: 3,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
