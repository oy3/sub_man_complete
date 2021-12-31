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

  Future<void> doGetBillingHistory(String docId) async {
    debugPrint(docId);
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

  Future<bool> addSub(String image, String category, String name, String cycle,
      String plan, num price, DateTime date, String reminder) async {
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

                return true;
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
        return true;
      }
    } on FirebaseException catch (e) {
      debugPrint('Error Uploading $e');
      return false;
    }
    return false;
  }

  Future<bool> addCustomSub(
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

                return true;
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
        return true;
      }
    } on FirebaseException catch (e) {
      debugPrint('Error Uploading $e');
      return false;
    }
    return false;
  }

  Future<UserSubscriptionsListResponse> doGetUserSubscriptionList() async {
    List<dynamic> customSubscriptionResponse = [];

    await firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('subscriptions')
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

  Future<Map<int, dynamic>> doGetExpenseByMonth() async {
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

    sub.docs.forEach((doc) async {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();

      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

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
        // debugPrint(amounts.toString());
      });
    });

    return amounts;
  }

  Future<Map<int, dynamic>> doGetExpenseByDay() async {
    DateTime first =
        DateTime.now().subtract(new Duration(days: DateTime.now().weekday - 1));

    DateTime last =
        DateTime.now().subtract(new Duration(days: DateTime.now().weekday - 7));

    debugPrint('week: $first and $last');
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

    sub.docs.forEach((doc) async {
      var data = await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('subscriptions')
          .doc(doc.id)
          .collection('logs')
          .where('bill_date', isGreaterThan: first)
          .where('bill_date', isLessThan: last)
          .orderBy('bill_date', descending: true)
          .get();

      data.docs.forEach((element) {
        var date = element['bill_date'] as Timestamp;

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

        // debugPrint('amount: $amounts');
      });
    });

    return amounts;
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

  //**
  Future<num> doGetYearlySumByCategory(String category) async {
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

     sub.docs.forEach((doc) async {
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
      debugPrint('Amount List: $amounts');
      total = amounts.sum;
      debugPrint('Total Amount: $total');
    });

    return total;
  }
}
