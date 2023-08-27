import 'package:cityguide/model/authentication/userAuthentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageHandling {
  String groupId;

  MessageHandling(this.groupId);

  Future<void> sendMessage(String message) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> messageData = {
      "senderId": userId,
      "date": DateTime.now(),
      "messageType": "text",
      "message": message,
    };

    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add(messageData);

    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .update({"recentMessage": message, "recentMessageSender": userId});

    // Fetch group members
    DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .get();

    List<String> groupMembers = List<String>.from(groupSnapshot["members"]);

    // Fetch user tokens for the group members and use them
    List<String> userTokens = [];

    for (String memberId in groupMembers) {
      DocumentSnapshot userTokenSnapshot = await FirebaseFirestore.instance
          .collection("userToken")
          .doc(memberId)
          .get();

      if (userTokenSnapshot.exists) {
        String userToken = userTokenSnapshot["userToken"] as String;
        if (userId != memberId) {
          userTokens.add(userToken);
        }
      }
    }
    debugPrint("user tokens : ${userTokens.toString()}");
    // Use userTokens for sending push notifications
    await FireBaseFuncationalities.sendPushNotification(
        message, userTokens, groupId);
  }
}
