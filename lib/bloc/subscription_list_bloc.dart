import 'package:rxdart/rxdart.dart';
import 'package:sub_man/model/subscription_list_response.dart';
import 'package:sub_man/model/subscriptions.dart';
import 'package:sub_man/repository/repository.dart';

class SubscriptionListBloc {
  Repository _repository = Repository();
  BehaviorSubject<SubscriptionListResponse> _subject =
      BehaviorSubject<SubscriptionListResponse>();

  BehaviorSubject<SubscriptionListResponse> get subject => _subject;
  late SubscriptionListResponse subscriptionListResponse;

  getSubscriptionList() async {
    subscriptionListResponse = await _repository.doGetSubscriptionList();
    _subject.sink.add(subscriptionListResponse);
  }

  doDisplaySubscriptionList({String filter = "all"}) {
    List<Subscriptions> filtered = [];
    if (filter == "all") {
      _subject.sink.add(subscriptionListResponse);
    } else {
      subscriptionListResponse.subscriptionList.forEach((item) {
        if (item.name.toLowerCase().contains(filter.toLowerCase())) {
          filtered.add(item);
        }
      });
      _subject.sink.add(SubscriptionListResponse(filtered, ""));
    }
  }

  dispose() {
    _subject.close();
  }
}
