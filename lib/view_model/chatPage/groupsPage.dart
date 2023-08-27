import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../res/app_colors/app_clolrs.dart';
import 'displaayGroups.dart';

class LoadGroups extends StatefulWidget {
  const LoadGroups({super.key});

  @override
  State<LoadGroups> createState() => _LoadGroupsState();
}

class _LoadGroupsState extends State<LoadGroups> {
  final userColledtion = FirebaseFirestore.instance.collection('users');

  late Stream<DocumentSnapshot<Map<String, dynamic>>>? userGroups;

  var userid = FirebaseAuth.instance.currentUser!.uid;
  final fbm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    userGroups =
        userColledtion.doc(userid).snapshots(includeMetadataChanges: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userGroups,
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                color: Appcolor.buttonclolor,
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              Map<String, dynamic>? data = snapshot.data?.data();

              if (data != null) {
                if (data.containsKey('groups') &&
                    data['groups'] is List<dynamic>) {
                  List<dynamic> groupsData = data['groups'];
                  List<String> groupsList = groupsData.cast<String>();
                  return Expanded(
                      child: ListView.builder(
                          itemCount: groupsList.length,
                          // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                          itemBuilder: (context, Index) {
                            return DiplayGroups(
                              groupId: groupsList[Index],
                            );
                          }));
                } else {
                  return const SizedBox(
                    child: Text('No valid groups data found in the document.'),
                  );
                }
              } else {
                return const Text('Document data is null.');
              }
            } else {
              return const Text('No data found.');
            }
          },
        ),
      ],
    );
  }
}
