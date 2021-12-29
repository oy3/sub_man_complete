import 'package:sub_man/model/user_subscriptions.dart';

class UserSubscriptionsListResponse {
  List<UserSubscriptions> userSubscriptionsList = [];
  String errorValue = "";

  UserSubscriptionsListResponse(this.userSubscriptionsList, this.errorValue);

  UserSubscriptionsListResponse.fromJson(List<dynamic> json) {
    this.userSubscriptionsList =
        json.map((e) => UserSubscriptions.fromJson(e)).toList();
  }

  UserSubscriptionsListResponse.withError(String errorValue)
      : this.userSubscriptionsList = [],
        this.errorValue = errorValue;
}
