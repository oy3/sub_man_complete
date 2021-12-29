class Subscriptions {
  final String name;
  final String category;
  final String image;
  final List<dynamic> plans;

  Subscriptions(this.name, this.category, this.image, this.plans);

  Subscriptions.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        category = json["category"],
        image = json["image"],
        plans = json["plans"];

}

class Plans {
  final String name;
  final double price;
  final String type;

  Plans(this.name, this.price, this.type);

  Plans.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        price = json["price"],
        type = json["type"];
}
