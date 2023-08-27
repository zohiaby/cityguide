import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:cityguide/res/app_data/appData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FireBaseFuncationalities {
  final userColledtion = FirebaseFirestore.instance.collection('users');
  final groupColledtion = FirebaseFirestore.instance.collection('groups');
  final userMobileToken = FirebaseFirestore.instance.collection("userToken");

  late String userName;
  late String userEmail;
  late String userID;
  late List<String> userGroups = []; // Initialize as an empty list
  late List<String> groupMembers = []; // Initialize as an empty list
  // static late List<String> UserTokens = []; // Initialize as an empty list

  // ignore: prefer_typing_uninitialized_variables
  static late var userToken;

  //static get http => null;

  Future uploadUserData(userID, userFullName, userEmail, userPassword) async {
    //await getFireBaseMessagingToken();

    return await userColledtion.doc(userID).set({
      "Name": userFullName,
      "Email": userEmail,
      "Password": userPassword,
      "Id": userID,
      "groups": [],
    });
  }

  Future uploadUserFCMToken() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await getFireBaseMessagingToken();
    return await userMobileToken.doc(userId).set({"userToken": userToken});
  }

  Future<void> removeUserFCMToken() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await userMobileToken
        .doc(userId)
        .update({"userToken": FieldValue.delete()});
  }

  Future<void> uploadGroupData(groupName) async {
    await userDataFetching();
    await groupColledtion.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${userID}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    }).then((value) async {
      // groupMembers.clear(); // Clear the list before adding new members
      groupMembers.add(userID);
      groupColledtion.doc(value.id).update({"groupId": value.id});
      await uploadGroupMeembers(value.id);
      await uploadUserMeembers(value.id);
    });
  }

  Future<void> uploadGroupMeembers(groupId) async {
    var userid = FirebaseAuth.instance.currentUser!.uid;

    if (groupId != null && groupId.isNotEmpty) {
      await groupColledtion.doc(groupId).update({
        'members': FieldValue.arrayUnion([userid]),
      });
    } else {
      debugPrint('Invalid groupId: $groupId');
    }
  }

  Future<void> uploadUserMeembers(groupId) async {
    var userid = FirebaseAuth.instance.currentUser!.uid;

    if (groupId != null && groupId.isNotEmpty) {
      await userColledtion.doc(userid).update({
        'groups': FieldValue.arrayUnion([groupId]),
      });
    } else {
      debugPrint('Invalid groupId: $groupId');
    }
  }

  userDataFetching() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    DocumentSnapshot<Map<String, dynamic>> data =
        await userColledtion.doc(firebaseUser!.uid).get();

    userName = data["Name"];
    userID = data['Id'];
    userEmail = data["Email"];
    userGroups = List<String>.from(data["groups"]);
    debugPrint("User Groups: $userGroups");

    return userGroups;
  }

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void> getFireBaseMessagingToken() async {
    await messaging.requestPermission();

    await messaging.getToken().then((token) {
      if (token != null) {
        userToken = token;
        //  UserTokens.add(token);
        debugPrint("User Token is: $userToken");
      }
    });
  }

  // // static Future<void> sendPushNotification() async {
  // //   var url = Uri.https('example.com', 'whatsit/create');
  // //   var response =
  // //       await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
  // //   print('Response status: ${response.statusCode}');
  // //   print('Response body: ${response.body}');
  // // }

  // // for sending push notification
  static Future<void> sendPushNotification(
      String message, List<String> userTokens, groupId) async {
    debugPrint("all user tokens: ${userTokens.toString()}");
    try {
      final body = {
        "registration_ids": userTokens,
        "notification": {
          "title": "You Have a New Message",
          "body": message,
          "android_channel_id": "chats"
        },
        'android': {
          'notification': {
            'notification_count': 23,
          },
        },
        'data': {'type': 'msj', 'id': groupId}
      };

      var res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=    YOUR KEY'
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }
}

// print('User granted permission: ${settings.authorizationStatus}');
//}
