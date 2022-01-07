import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/model/user_subscriptions_list_response.dart';
import 'package:sub_man/repository/repository.dart';

class UserSubscriptionsListBloc {
  Repository _repository = Repository();
  BehaviorSubject<UserSubscriptionsListResponse> _subject =
      BehaviorSubject<UserSubscriptionsListResponse>();

  BehaviorSubject<UserSubscriptionsListResponse> get subject => _subject;
  late UserSubscriptionsListResponse userSubscriptionListResponse;

  BehaviorSubject<bool> _addStatus = BehaviorSubject<bool>();

  BehaviorSubject<bool> get addStatus => _addStatus;

  // late UserSubscriptionsListResponse userSubscriptionListResponse;

  getUserSubscriptionList(String factor) async {
    userSubscriptionListResponse =
        await _repository.doGetUserSubscriptionList(factor);
    _subject.sink.add(userSubscriptionListResponse);
  }

  doDisplaySubscriptionList({String filter = "all"}) {
    List<UserSubscriptions> filtered = [];
    if (filter == "all") {
      _subject.sink.add(userSubscriptionListResponse);
    } else {
      userSubscriptionListResponse.userSubscriptionsList.forEach((item) {
        if (item.name.toLowerCase().contains(filter.toLowerCase())) {
          filtered.add(item);
        }
      });
      _subject.sink.add(UserSubscriptionsListResponse(filtered, ""));
    }
  }

  addCustomSubscription(File image, String category, String name, String cycle,
      String plan, double price, DateTime date, String reminder) async {
    var status = await _repository.addCustomSub(
        image, category, name, cycle, plan, price, date, reminder);
    _addStatus.sink.add(status);
  }

  dispose() {
    _subject.close();
    _addStatus.close();
  }
}
