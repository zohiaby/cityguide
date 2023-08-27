import 'package:auto_size_text/auto_size_text.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../view/messagePage/messagePage.dart';

class DiplayGroups extends StatefulWidget {
  final String groupId;
  const DiplayGroups({Key? key, required this.groupId}) : super(key: key);

  @override
  State<DiplayGroups> createState() => _DiplayGroupsState();
}

class _DiplayGroupsState extends State<DiplayGroups> {
  final groupColledtion = FirebaseFirestore.instance.collection('groups');
  // ignore: prefer_typing_uninitialized_variables
  var data;
  @override
  void initState() {
    data = groupColledtion.doc(widget.groupId).get();
    super.initState();
  }

  String groupName = "";
  String recentMessage = "";
  String groupIcon = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            color: Colors.deepPurple,
          ); // Show a loading indicator while waiting for the data
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          // Get the document data from the snapshot
          Map<String, dynamic>? data = snapshot.data?.data();

          if (data != null) {
            groupName = data["groupName"];
            recentMessage = data['recentMessage'];
            groupIcon = data["groupIcon"];

            return Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 7, bottom: 7),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          groupId: widget.groupId,
                        ),
                      ));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        groupIcon == ""
                            ? const Image(
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                                image: AssetImage(images.welcomeimage),
                              )
                            : const Icon(Icons.group,
                                size: 50, color: Colors.deepPurple),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                groupName,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              recentMessage != ""
                                  ? AutoSizeText(
                                      recentMessage.length <= 30
                                          ? recentMessage
                                          : '${recentMessage.substring(0, 30)}...',
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  : const AutoSizeText("No Message",
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 20))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Handle the case where the document data is null
            return const Text('Document data is null.');
          }
        } else {
          // Handle the case where the snapshot doesn't have data
          return const Text('No data found.');
        }
      },
    );
  }
}
