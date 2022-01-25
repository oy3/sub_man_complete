import 'package:cloud_firestore/cloud_firestore.dart';

class UserSubscriptions {
  final String uid;
  final String name;
  final String category;
  final String image;
  final List<dynamic> plans;

  UserSubscriptions(this.name, this.category, this.image, this.plans, this.uid);

  UserSubscriptions.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        category = json["category"],
        image = json["image"],
        plans = json["plans"];
}

class UserPlans {
  final String name;
  final double price;
  final String type;
  final bool active;
  final String reminder;
  final Timestamp startDate;
  final Timestamp endDate;

  UserPlans(this.name, this.price, this.type, this.active, this.reminder,
      this.startDate, this.endDate);

  UserPlans.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        price = json["price"].toDouble(),
        type = json["type"],
        reminder = json["reminder"],
        startDate = json["start_date"],
        endDate = json["end_date"],
        active = json["active"];
}

class Logs {
  final String name;
  final String type;
  final double amount;
  final Timestamp billDate;

  Logs(this.name, this.type, this.amount, this.billDate);

  Logs.fromJson(Map<String, dynamic> json)
      : name = json["plan_name"],
        type = json["plan_type"],
        amount = json["amount"],
        billDate = json["bill_date"];
}
