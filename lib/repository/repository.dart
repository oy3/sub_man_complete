import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sub_man/model/subscription_list_response.dart';
import 'package:sub_man/model/user_response.dart';
import 'package:sub_man/model/user_subscriptions.dart';
import 'package:sub_man/model/user_subscriptions_list_response.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:sub_man/widgets/utils.dart';
import 'package:collection/collection.dart';

class Repository {
  final FirebaseAuth _firebaseAuth;
  var firebaseFirestore = FirebaseFirestore.instance;

  Repository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<num> doGetSubSum() async {
    List<num> amounts = [];
    var total;

    var snapshot = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    snapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc['plans'].forEach((plans) async {
          if (plans['active'] == true) {
            final activePlans = doc['plans'] as List<dynamic>;
            activePlans.map((data) {
              amounts.add(data["price"]);
            }).toList();
          }
        });
      }
    });

    total = amounts.sum;

    // debugPrint('Total Amount: ${double.parse((total).toStringAsFixed(2))};');

    return total;
  }

  Future<void> doGetBillingHistory(String docId) async {
    await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .doc(docId.trim())
        .collection('logs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        debugPrint(doc["plan_name"]);
      });
    });
  }

  Future<String> addSub(
      String image,
      String category,
      String name,
      String cycle,
      String plan,
      num price,
      DateTime date,
      String reminder) async {
    var endDate = date.add(Duration(days: subEndDate(cycle)));
    CollectionReference users = firebaseFirestore.collection('users');

    try {
      var getSubs = await users
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .where('name', isEqualTo: name)
          .get();

      if (getSubs.docs.isNotEmpty) {
        getSubs.docs.forEach((doc) {
          if (doc.exists) {
            // If subscription with name exist

            //Check if user has active subscription
            doc['plans'].forEach((plans) async {
              if (plans['active'] != true) {
                var planAdded = doc.reference.set({
                  'plans': FieldValue.arrayUnion([
                    {
                      'name': plan,
                      'price': price,
                      'start_date': date,
                      'end_date': endDate,
                      'reminder': reminder,
                      'type': cycle,
                      'active': true
                    }
                  ])
                }, SetOptions(merge: true)).whenComplete(() async {
                  await firebaseFirestore
                      .collection(
                          'users/${_firebaseAuth.currentUser!.uid}/subscriptions/${doc.id}/logs')
                      .add({
                    'plan_name': plan,
                    'plan_type': cycle,
                    'amount': price,
                    'bill_date': date
                  });
                });

                return doc['uid'];
              }
            });
          }
        });
      } else {
        // If subscription with name does not exist
        var subAdded = await users
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('subscriptions')
            .add({
          'image': image,
          'category': category,
          'name': name,
          'plans': [
            {
              'name': plan,
              'price': price,
              'start_date': date,
              'end_date': endDate,
              'reminder': reminder,
              'type': cycle,
              'active': true
            }
          ]
        });

        await firebaseFirestore
            .doc(subAdded.path.toString())
            .update({'uid': subAdded.id});

        await firebaseFirestore
            .collection(subAdded.path.toString() + '/logs')
            .add({
          'plan_name': plan,
          'plan_type': cycle,
          'amount': price,
          'bill_date': date
        });
        return subAdded.id;
      }
    } on FirebaseException catch (e) {
      debugPrint('Error Uploading $e');
      return '';
    }
    return '';
  }

  Future<List<String>> addCustomSub(
      File image,
      String category,
      String name,
      String cycle,
      String plan,
      double price,
      DateTime date,
      String reminder) async {
    var endDate = date.add(Duration(days: subEndDate(cycle)));

    try {
      CollectionReference users = firebaseFirestore.collection('users');

      var imageSaved = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_firebaseAuth.currentUser!.uid}')
          .child(path.basename(image.path))
          .putFile(image);

      var uploadedImage = await imageSaved.ref.getDownloadURL();
      /*    debugPrint(
          'uploaded file: ${path.basename(image.path)} with url: ${await imageSaved.ref.getDownloadURL()}');
*/
      var subAdded = await users
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .where('name', isEqualTo: name)
          .get();

      if (subAdded.docs.isNotEmpty) {
        subAdded.docs.forEach((doc) {
          if (doc.exists) {
            // If subscription with custom name exist

            //Check if user has active subscription
            doc['plans'].forEach((plans) async {
              if (plans['active'] != true) {
                /*      // debugPrint('first active is ${plans['active']}');
                return false;
              } else {*/
                //If user does not have active subscription

                // debugPrint('second case: active is ${plans['active']}');

                var planAdded = doc.reference.set({
                  'plans': FieldValue.arrayUnion([
                    {
                      'name': plan,
                      'price': price,
                      'start_date': date,
                      'end_date': endDate,
                      'reminder': reminder,
                      'type': cycle,
                      'active': true
                    }
                  ])
                }, SetOptions(merge: true)).whenComplete(() async {
                  await firebaseFirestore
                      .collection(
                          'users/${_firebaseAuth.currentUser!.uid}/subscriptions/${doc.id}/logs')
                      .add({
                    'plan_name': plan,
                    'plan_type': cycle,
                    'amount': price,
                    'bill_date': date
                  });
                });

                return [doc['uid'], uploadedImage];
              }
            });
          }
        });
      } else {
        // If subscription with custom name does not exist
        var subAdded2 = await users
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('subscriptions')
            .add({
          'image': uploadedImage,
          'category': category,
          'name': name,
          'plans': [
            {
              'name': plan,
              'price': price,
              'start_date': date,
              'end_date': endDate,
              'reminder': reminder,
              'type': cycle,
              'active': true
            }
          ]
        });

        await firebaseFirestore
            .doc(subAdded2.path.toString())
            .update({'uid': subAdded2.id});

        await firebaseFirestore
            .collection(subAdded2.path.toString() + '/logs')
            .add({
          'plan_name': plan,
          'plan_type': cycle,
          'amount': price,
          'bill_date': date
        });
        return [subAdded2.id, uploadedImage];
      }
    } on FirebaseException catch (e) {
      debugPrint('Error Uploading $e');
      return ['', ''];
    }
    return ['', ''];
  }

  Future<UserSubscriptionsListResponse> doGetUserSubscriptionList(
      String criteria) async {
    List<dynamic> customSubscriptionResponse = [];

    await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .orderBy(criteria, descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          debugPrint('Document data: ${doc.data()}');
          var value = doc.data();
          customSubscriptionResponse.add(value as Map<String, dynamic>);
        });
      } else {
        print('Document does not exist on the database');
      }
    });

    debugPrint("DONE WITH FIREBASE");

    if (customSubscriptionResponse.contains(null)) {
      return UserSubscriptionsListResponse.withError(
          "Error while fetching data");
    } else {
      return UserSubscriptionsListResponse.fromJson(customSubscriptionResponse);
    }
  }

  Future<SubscriptionListResponse> doGetSubscriptionList() async {
    List<Map<dynamic, dynamic>> subscriptionResponse = [];
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('subscriptions').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var element = querySnapshot.docs[i];
      var value = await element.reference.get();

      subscriptionResponse.add(value.data() as Map<String, dynamic>);
      debugPrint("doGetSubscriptionListResponse ${value.data()}");
    }

    debugPrint("DONE WITH FIREBASE");

    if (subscriptionResponse.contains(null)) {
      return SubscriptionListResponse.withError("Error while fetching data");
    } else {
      return SubscriptionListResponse.fromJson(subscriptionResponse);
    }
  }

  Future<num> doGetBillingSum(String docId) async {
    List<num> amounts = [];
    var total;

    await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .doc(docId.trim())
        .collection('logs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        amounts.add(doc["amount"]);
      });
      total = amounts.sum;
    });
    debugPrint('Total Amount: $total');
    return total;
  }

  doGetExpensePaid() async {
    List<num> amounts = [];
    var total;

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    sub.docs.forEach((doc) async {
      var price = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .get();

      price.docs.forEach((doc1) {
        amounts.add(doc1['amount']);
      });
    });
    debugPrint(amounts.toString());
    total = amounts.sum;
    debugPrint('Total Amount: $total');
  }

  Future<List<Map<String, dynamic>>> doGetExpenseByMonth() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    int currentYear = dateParse.year;

    DateTime first = DateTime.utc(DateTime.now().year, DateTime.january, 1);
    DateTime last = DateTime.utc(DateTime.now().year, DateTime.december, 31);

    Map<int, dynamic> amounts = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
      8: 0,
      9: 0,
      10: 0,
      11: 0
    };

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          /* .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();

      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          if (date.toDate().month == 1) {
            amounts.update(0, (value) => value + element['amount']);
          } else if (date.toDate().month == 2) {
            amounts.update(1, (value) => value + element['amount']);
          } else if (date.toDate().month == 3) {
            amounts.update(2, (value) => value + element['amount']);
          } else if (date.toDate().month == 4) {
            amounts.update(3, (value) => value + element['amount']);
          } else if (date.toDate().month == 5) {
            amounts.update(4, (value) => value + element['amount']);
          } else if (date.toDate().month == 6) {
            amounts.update(5, (value) => value + element['amount']);
          } else if (date.toDate().month == 7) {
            amounts.update(6, (value) => value + element['amount']);
          } else if (date.toDate().month == 8) {
            amounts.update(7, (value) => value + element['amount']);
          } else if (date.toDate().month == 9) {
            amounts.update(8, (value) => value + element['amount']);
          } else if (date.toDate().month == 10) {
            amounts.update(9, (value) => value + element['amount']);
          } else if (date.toDate().month == 11) {
            amounts.update(10, (value) => value + element['amount']);
          } else if (date.toDate().month == 12) {
            amounts.update(11, (value) => value + element['amount']);
          }
        }
      });
    }

    return [
      {'domain': 'Jan', 'measure': amounts[0]},
      {'domain': 'Feb', 'measure': amounts[1]},
      {'domain': 'Mar', 'measure': amounts[2]},
      {'domain': 'Apr', 'measure': amounts[3]},
      {'domain': 'May', 'measure': amounts[4]},
      {'domain': 'Jun', 'measure': amounts[5]},
      {'domain': 'Jul', 'measure': amounts[6]},
      {'domain': 'Aug', 'measure': amounts[7]},
      {'domain': 'Sep', 'measure': amounts[8]},
      {'domain': 'Oct', 'measure': amounts[9]},
      {'domain': 'Nov', 'measure': amounts[10]},
      {'domain': 'Dec', 'measure': amounts[11]},
    ];
  }

  doGetExpenseByWeek() {
    // Current date and time of system
    String date = DateTime.now().toString();

// This will generate the time and date for first day of month
    String firstDay = date.substring(0, 8) + '01' + date.substring(10);

// week day for the first day of the month
    int weekDay = DateTime.parse(firstDay).weekday;

    DateTime testDate = DateTime.now();

    int weekOfMonth;

//  If your calender starts from Monday
    weekDay--;
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    debugPrint('Week of the month: $weekOfMonth');
    weekDay++;

// If your calender starts from sunday
    if (weekDay == 7) {
      weekDay = 0;
    }
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    debugPrint('Week of the month: $weekOfMonth');
  }

  Future<List<Map<String, dynamic>>> doGetExpenseByDay() async {
    DateTime first = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 1,
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    DateTime last = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 7,
        hours: DateTime.now().hour - 23,
        minutes: DateTime.now().minute - 59,
        seconds: DateTime.now().second - 59,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    // debugPrint('This Week: $first and $last');

    Map<int, dynamic> amounts = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
    };

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          // .where('bill_date', isGreaterThan: first)
          // .where('bill_date', isLessThan: last)
          // .orderBy('bill_date', descending: true)
          .get();

      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          if (date.toDate().weekday == 1) {
            amounts.update(0, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 2) {
            amounts.update(1, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 3) {
            amounts.update(2, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 4) {
            amounts.update(3, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 5) {
            amounts.update(4, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 6) {
            amounts.update(5, (value) => value + element['amount']);
          } else if (date.toDate().weekday == 7) {
            amounts.update(6, (value) => value + element['amount']);
          }
        }
      });
    }

    // debugPrint('amounts: $amounts');

    return [
      {'domain': 'Mon', 'measure': amounts[0]},
      {'domain': 'Tues', 'measure': amounts[1]},
      {'domain': 'Wed', 'measure': amounts[2]},
      {'domain': 'Thurs', 'measure': amounts[3]},
      {'domain': 'Fri', 'measure': amounts[4]},
      {'domain': 'Sat', 'measure': amounts[5]},
      {'domain': 'Sun', 'measure': amounts[6]}
    ];
  }

  Future<List<Map<String, dynamic>>> doGetExpenseByHour() async {
    var today = DateTime.now();
    // today = DateTime(today.year, today.month, today.day);

    var todayFormat = '${today.year}-${today.month}-${today.day}';

    Map<int, dynamic> amounts = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
      8: 0,
      9: 0,
      10: 0,
      11: 0
    };

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          // .where('bill_date', isGreaterThanOrEqualTo: today)
          // .orderBy('bill_date', descending: true)
          .get();

      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          if (date.toDate().hour == 0 && date.toDate().hour <= 1) {
            amounts.update(0, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 2 && date.toDate().hour <= 3) {
            amounts.update(1, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 4 && date.toDate().hour <= 5) {
            amounts.update(2, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 6 && date.toDate().hour <= 7) {
            amounts.update(3, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 8 && date.toDate().hour <= 9) {
            amounts.update(4, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 10 && date.toDate().hour <= 11) {
            amounts.update(5, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 12 && date.toDate().hour <= 13) {
            amounts.update(6, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 14 && date.toDate().hour <= 15) {
            amounts.update(7, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 16 && date.toDate().hour <= 17) {
            amounts.update(8, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 18 && date.toDate().hour <= 19) {
            amounts.update(9, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 20 && date.toDate().hour <= 21) {
            amounts.update(10, (value) => value + element['amount']);
          } else if (date.toDate().hour >= 22) {
            amounts.update(11, (value) => value + element['amount']);
          }
        }
      });
    }

    return [
      {'domain': '0', 'measure': amounts[0]},
      {'domain': '2', 'measure': amounts[1]},
      {'domain': '4', 'measure': amounts[2]},
      {'domain': '6', 'measure': amounts[3]},
      {'domain': '8', 'measure': amounts[4]},
      {'domain': '10', 'measure': amounts[5]},
      {'domain': '12', 'measure': amounts[6]},
      {'domain': '14', 'measure': amounts[7]},
      {'domain': '16', 'measure': amounts[8]},
      {'domain': '18', 'measure': amounts[9]},
      {'domain': '20', 'measure': amounts[10]},
      {'domain': '22', 'measure': amounts[11]},
    ];
  }

  Future<bool> deleteSubscription(UserSubscriptions sub) async {
    DocumentReference documentReference = firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .doc(sub.uid);

    var imgUrl = Uri.decodeFull(path.basename(sub.image))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    var firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(imgUrl);

    if (sub.image.contains('uploads')) {
      // debugPrint('image: $firebaseStorageRef');
      return await firebaseStorageRef.delete().then((value) async {
        await firebaseFirestore.runTransaction((transaction) async {
          await transaction.delete(documentReference);
        }).then((value) async {
          documentReference.collection('logs').get().then((value) {
            value.docs.forEach((doc) async {
              //Delete sub-collection: logs
              await documentReference.collection('logs').doc(doc.id).delete();
            });
          }).whenComplete(() {
            print(
                "Sub-id: ${sub.uid} and img-url: $imgUrl deleted successfully");
            return true;
          });
        }).catchError((error) {
          print("Failed to delete subscription: $error");
          return false;
        });
        return true;
      }).catchError((error) {
        print("Failed to delete image: $error");
        return false;
      });
    } else {
      await firebaseFirestore.runTransaction((transaction) async {
        await transaction.delete(documentReference);
      }).then((value) async {
        documentReference.collection('logs').get().then((value) {
          value.docs.forEach((doc) async {
            //Delete sub-collection: logs
            await documentReference.collection('logs').doc(doc.id).delete();
          });
        }).whenComplete(() {
          print("Sub-id: ${sub.uid} and img-url: $imgUrl deleted successfully");
          return true;
        });
      }).catchError((error) {
        print("Failed to delete subscription: $error");
        return false;
      });
    }
    return true;
  }

  Future<UserResponse> doGetUserDetails(String userId) async {
    Map<String, dynamic> userResponse = {};

    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists ${documentSnapshot.data()} on the database');
        // var snapshot = documentSnapshot.data() as QuerySnapshot;
        userResponse = documentSnapshot.data() as Map<String, dynamic>;

        /*  snapshot.docs.forEach((doc) {
          debugPrint('Document data: ${doc.data()}');
          var value = doc.data();
          userResponse.add(value as Map<String, dynamic>);
        });*/
      } else {
        print('Document does not exist on the database');
      }
    });

    debugPrint("DONE WITH FIREBASE");

    if (userResponse.isEmpty) {
      return UserResponse.withError("Error while fetching data");
    } else {
      return UserResponse.fromJson(userResponse);
    }
  }

  /* Future<num> doGetYearlySumByCategory(String category) async {
    DateTime first = DateTime.utc(DateTime.now().year, DateTime.january, 1);
    DateTime last = DateTime.utc(DateTime.now().year, DateTime.december, 31);

    List<num> amounts = [];
    num total = 0;

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: category)
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var amountData = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();
      amountData.docs.forEach((element) {
        amounts.add(element['amount']);
      });
      total = amounts.sum;
    }

    // debugPrint('Amount List: $amounts');
    debugPrint('Total Category Amount: $total');
    return total;
  }
  Future<Map<int, dynamic>> getYearSumByCategory() async {
    Map<int, dynamic> yearlyCategory = {0: 0, 1: 0, 2: 0, 3: 0};

    doGetYearlySumByCategory('software').then((data) {
      // debugPrint('software: $data');
      yearlyCategory.update(0, (value) => value + data);
    });
    doGetYearlySumByCategory('entertainment').then((data) {
      // debugPrint('entertainment: $data');
      yearlyCategory.update(1, (value) => value + data);
    });
    doGetYearlySumByCategory('internet').then((data) {
      // debugPrint('internet: $data');
      yearlyCategory.update(2, (value) => value + data);
    });
    doGetYearlySumByCategory('others').then((data) {
      // debugPrint('others: $data');
      yearlyCategory.update(3, (value) => value + data);
    });

    // debugPrint('Total List: $yearlyCategory');

    return yearlyCategory;
  }*/

/*  Future<List<Map<String, dynamic>>> doGetYearAmountByCategory() async {
    DateTime first = DateTime.utc(DateTime.now().year, DateTime.january, 1);
    DateTime last = DateTime.utc(DateTime.now().year, DateTime.december, 31);

    List<num> softwareAmounts = [];
    List<num> entertainmentAmounts = [];
    List<num> internetAmounts = [];
    List<num> othersAmounts = [];
    num softwareTotal = 0;
    num entertainmentTotal = 0;
    num internetTotal = 0;
    num othersTotal = 0;

    //For Software Category
    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'software')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var amountData = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();
      amountData.docs.forEach((element) {
        softwareAmounts.add(element['amount']);
      });
      softwareTotal = softwareAmounts.sum;
    }

    //For Entertainment Category
    var sub2 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'entertainment')
        .get();

    var documentData2 = sub2.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData2) {
      var amountData2 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();
      amountData2.docs.forEach((element) {
        entertainmentAmounts.add(element['amount']);
      });
      entertainmentTotal = entertainmentAmounts.sum;
    }

    //For Internet Category
    var sub3 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'internet')
        .get();

    var documentData3 = sub3.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData3) {
      var amountData3 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();
      amountData3.docs.forEach((element) {
        internetAmounts.add(element['amount']);
      });
      internetTotal = internetAmounts.sum;
    }

    //For Others Category
    var sub4 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'others')
        .get();

    var documentData4 = sub4.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData4) {
      var amountData4 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();
      amountData4.docs.forEach((element) {
        othersAmounts.add(element['amount']);
      });
      othersTotal = othersAmounts.sum;
    }

    num softwarePer = 0, entertainmentPer = 0, internetPer = 0, othersPer = 0;

    softwarePer = (softwareTotal /
            (softwareTotal +
                entertainmentTotal +
                internetTotal +
                othersTotal)) *
        100;
    entertainmentPer = (entertainmentTotal /
            (softwareTotal +
                entertainmentTotal +
                internetTotal +
                othersTotal)) *
        100;
    internetPer = (internetTotal /
            (softwareTotal +
                entertainmentTotal +
                internetTotal +
                othersTotal)) *
        100;
    othersPer = (othersTotal /
            (softwareTotal +
                entertainmentTotal +
                internetTotal +
                othersTotal)) *
        100;

    debugPrint(
        'Total Yearly Category Amount: $softwareTotal, $entertainmentTotal, $internetTotal, $othersTotal');

    debugPrint(
        'Total Yearly Category %: $softwarePer, $entertainmentPer, $internetPer, $othersPer');
    return [
      {'domain': 'Software', 'measure': softwarePer},
      {'domain': 'Entertainment', 'measure': entertainmentPer},
      {'domain': 'Internet', 'measure': internetPer},
      {'domain': 'Others', 'measure': othersPer},
    ];
  }*/

  Future<Map<int, dynamic>> doGetYearAmountByCategory() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    int currentYear = dateParse.year;

    DateTime first = DateTime.utc(DateTime.now().year, DateTime.january, 1);
    DateTime last = DateTime.utc(DateTime.now().year, DateTime.december, 31);

    List<num> softwareAmounts = [];
    List<num> entertainmentAmounts = [];
    List<num> internetAmounts = [];
    List<num> othersAmounts = [];
    num softwareTotal = 0;
    num entertainmentTotal = 0;
    num internetTotal = 0;
    num othersTotal = 0;

    //For Software Category
    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'software')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var amountData = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          softwareAmounts.add(element['amount']);
        }
      });
      softwareTotal = softwareAmounts.sum;
    }

    //For Entertainment Category
    var sub2 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'entertainment')
        .get();

    var documentData2 = sub2.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData2) {
      var amountData2 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          /*  .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData2.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          entertainmentAmounts.add(element['amount']);
        }
      });
      entertainmentTotal = entertainmentAmounts.sum;
    }

    //For Internet Category
    var sub3 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'internet')
        .get();

    var documentData3 = sub3.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData3) {
      var amountData3 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          /*    .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData3.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          internetAmounts.add(element['amount']);
        }
      });
      internetTotal = internetAmounts.sum;
    }

    //For Others Category
    var sub4 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'others')
        .get();

    var documentData4 = sub4.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData4) {
      var amountData4 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData4.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          othersAmounts.add(element['amount']);
        }
      });
      othersTotal = othersAmounts.sum;
    }

    return {
      0: softwareTotal,
      1: entertainmentTotal,
      2: internetTotal,
      3: othersTotal
    };
  }

  Future<Map<int, dynamic>> doGetWeekAmountByCategory() async {
    DateTime first = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 1,
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    DateTime last = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 7,
        hours: DateTime.now().hour - 23,
        minutes: DateTime.now().minute - 59,
        seconds: DateTime.now().second - 59,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    List<num> softwareAmounts = [];
    List<num> entertainmentAmounts = [];
    List<num> internetAmounts = [];
    List<num> othersAmounts = [];
    num softwareTotal = 0;
    num entertainmentTotal = 0;
    num internetTotal = 0;
    num othersTotal = 0;

    //For Software Category
    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'software')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var amountData = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last
          .orderBy('bill_date', descending: true))*/
          .get();
      amountData.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          softwareAmounts.add(element['amount']);
        }
      });
      softwareTotal = softwareAmounts.sum;
    }

    //For Entertainment Category
    var sub2 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'entertainment')
        .get();

    var documentData2 = sub2.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData2) {
      var amountData2 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData2.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          entertainmentAmounts.add(element['amount']);
        }
      });
      entertainmentTotal = entertainmentAmounts.sum;
    }

    //For Internet Category
    var sub3 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'internet')
        .get();

    var documentData3 = sub3.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData3) {
      var amountData3 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData3.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          internetAmounts.add(element['amount']);
        }
      });
      internetTotal = internetAmounts.sum;
    }

    //For Others Category
    var sub4 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'daily')
        .get();

    var documentData4 = sub4.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData4) {
      var amountData4 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          /*.where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData4.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          othersAmounts.add(element['amount']);
        }
      });
      othersTotal = othersAmounts.sum;
    }

    /*   debugPrint(
        'Total Weekly Category Amount: $softwareTotal, $entertainmentTotal, $internetTotal, $othersTotal');

    debugPrint(
        'Total Weekly Category %: $softwarePer, $entertainmentPer, $internetPer, $othersPer');*/

    return {
      0: softwareTotal,
      1: entertainmentTotal,
      2: internetTotal,
      3: othersTotal
    };
  }

  Future<Map<int, dynamic>> doGetDayAmountByCategory() async {
    var today = DateTime.now();
    var todayFormat = '${today.year}-${today.month}-${today.day}';
    // today = DateTime(today.year, today.month, today.day);

    List<num> softwareAmounts = [];
    List<num> entertainmentAmounts = [];
    List<num> internetAmounts = [];
    List<num> othersAmounts = [];
    num softwareTotal = 0;
    num entertainmentTotal = 0;
    num internetTotal = 0;
    num othersTotal = 0;

    //For Software Category
    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'software')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var amountData = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          /*.where('bill_date', isGreaterThanOrEqualTo: today)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          softwareAmounts.add(element['amount']);
        }
      });
      softwareTotal = softwareAmounts.sum;
    }

    //For Entertainment Category
    var sub2 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'entertainment')
        .get();

    var documentData2 = sub2.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData2) {
      var amountData2 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          /*.where('bill_date', isGreaterThanOrEqualTo: today)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData2.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          entertainmentAmounts.add(element['amount']);
        }
      });
      entertainmentTotal = entertainmentAmounts.sum;
    }

    //For Internet Category
    var sub3 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'internet')
        .get();

    var documentData3 = sub3.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData3) {
      var amountData3 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          /*.where('bill_date', isGreaterThanOrEqualTo: today)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData3.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          internetAmounts.add(element['amount']);
        }
      });
      internetTotal = internetAmounts.sum;
    }

    //For Others Category
    var sub4 = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .where('category', isEqualTo: 'others')
        .get();

    var documentData4 = sub4.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData4) {
      var amountData4 = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          /*.where('bill_date', isGreaterThanOrEqualTo: today)
          .orderBy('bill_date', descending: true)*/
          .get();
      amountData4.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          othersAmounts.add(element['amount']);
        }
      });
      othersTotal = othersAmounts.sum;
    }

    return {
      0: softwareTotal,
      1: entertainmentTotal,
      2: internetTotal,
      3: othersTotal
    };
  }

  Future<List<Map<String, dynamic>>> doGetMonthlyServices() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    int currentYear = dateParse.year;

    List<Map<String, dynamic>> passData = [];

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'monthly')
          .get();
      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().year == currentYear) {
          passData.add(
              {'domain': doc.data()['name'], 'measure': element['amount']});
        }
      });
    }

    return passData;
  }

  Future<List<Map<String, dynamic>>> doGetDailyServices() async {
    DateTime first = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 1,
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    DateTime last = DateTime.now().subtract(new Duration(
        days: DateTime.now().weekday - 7,
        hours: DateTime.now().hour - 23,
        minutes: DateTime.now().minute - 59,
        seconds: DateTime.now().second - 59,
        microseconds: DateTime.now().microsecond - 999,
        milliseconds: DateTime.now().millisecond - 999));

    List<Map<String, dynamic>> passData = [];

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'daily')
          .get();
      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

        if (date.toDate().isAfter(first) && date.toDate().isBefore(last)) {
          passData.add(
              {'domain': doc.data()['name'], 'measure': element['amount']});
        }
      });
    }

    return passData;
  }

  Future<List<Map<String, dynamic>>> doGetHourlyServices() async {
    var today = DateTime.now();
    var todayFormat = '${today.year}-${today.month}-${today.day}';

    List<Map<String, dynamic>> passData = [];

    var sub = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();

    var documentData = sub.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documentData) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('plan_type', isEqualTo: 'hourly')
          .get();
      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;
        var billDate =
            '${date.toDate().year}-${date.toDate().month}-${date.toDate().day}';

        if (billDate.trim() == todayFormat.trim()) {
          passData.add(
              {'domain': doc.data()['name'], 'measure': element['amount']});
        }
      });
    }

    return passData;
  }

  doGetPaidExpenses() async {
    var snapshot = await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
        .get();
  }
}
