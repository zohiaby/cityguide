import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatefulWidget {
  final String groupId;
  const GroupDetails({super.key, required this.groupId});

  @override
  State<GroupDetails> createState() => GroupDetailsState();
}

class GroupDetailsState extends State<GroupDetails> {
  final groupCollection = FirebaseFirestore.instance.collection('groups');
  final userCollection = FirebaseFirestore.instance.collection('users');
  late DocumentReference groupDocumentReference;

  @override
  void initState() {
    groupDocumentReference = groupCollection.doc(widget.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolor.primaryColor,
          centerTitle: true,
          title: const Text(
            'Group Details',
            style: TextStyle(
                color: Appcolor.textcolor,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Appcolor.textcolor),
        ),
        body: FutureBuilder(
          future: groupDocumentReference.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Appcolor.buttonclolor,
              ));
            }
            if (snapshot.hasError) {
              return Text("Error ${snapshot.error.toString()}");
            }
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data!;
              String groupIcon = documentSnapshot["groupIcon"];
              String groupname = documentSnapshot["groupName"];
              List<dynamic> groupMembers = documentSnapshot["members"];
              return Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: groupIcon != ""
                              ? Image.network(groupIcon)
                              : const Image(
                                  image: AssetImage(images.welcomeimage),
                                ),
                        ),
                        groupname != ""
                            ? Text(
                                groupname,
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Appcolor.textcolor),
                              )
                            : const Text(
                                "Invalid name",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Appcolor.buttonclolor),
                              ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Group Members",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.textcolor),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: groupMembers.length,
                          itemBuilder: (context, Index) {
                            debugPrint("Group Members: $groupMembers");
                            return showUser(groupMembers[Index]);
                          }))
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Appcolor.buttonclolor,
            ));
          },
        ));
  }

  Widget showUser(String membersId) {
    DocumentReference userDocumentReference = userCollection.doc(membersId);
    debugPrint("Member ID: $membersId");

    return FutureBuilder<DocumentSnapshot>(
      future: userDocumentReference.get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Appcolor.buttonclolor,
          ));
        }
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error.toString()}");
        }
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data!;
          String userName = documentSnapshot["Name"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 15, right: 15),
            child: Card(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Appcolor.textcolor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Appcolor.buttonclolor,
        ));
      },
    );
  }
}
