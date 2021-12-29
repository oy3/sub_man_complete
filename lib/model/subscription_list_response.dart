import 'package:sub_man/model/subscriptions.dart';

class SubscriptionListResponse {
  List<Subscriptions> subscriptionList = [];
  String errorValue = "";

  SubscriptionListResponse(this.subscriptionList, this.errorValue);

  SubscriptionListResponse.fromJson(List<dynamic> json) {
    this.subscriptionList = json.map((e) => Subscriptions.fromJson(e)).toList();
  }


  SubscriptionListResponse.withError(String errorValue)
      : this.subscriptionList = [],
        this.errorValue = errorValue;
}
