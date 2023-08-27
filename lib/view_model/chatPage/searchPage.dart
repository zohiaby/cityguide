import 'package:auto_size_text/auto_size_text.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../view/messagePage/messagePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final authentication = FirebaseAuth.instance;

  final TextEditingController searchController = TextEditingController();

  late Stream<QuerySnapshot<Map<String, dynamic>>>? searchStream;

  var userid = FirebaseAuth.instance.currentUser!.uid;

  final userColledtion = FirebaseFirestore.instance.collection('users');
  final groupColledtion = FirebaseFirestore.instance.collection('groups');
  late List<String> userGroups = [];

  int displayLimit = 6;

  @override
  @override
  void initState() {
    super.initState();
    _updateSearchStream();
  }

  void _updateSearchStream() {
    setState(() {
      String searchText = searchController.text.trim();
      if (searchText.isNotEmpty) {
        searchStream = FirebaseFirestore.instance
            .collection('groups')
            .where('groupNameLower', isGreaterThanOrEqualTo: searchText)
            .where('groupNameLower', isLessThanOrEqualTo: '$searchText\uf8ff')
            .snapshots(includeMetadataChanges: true);
      } else {
        searchStream = FirebaseFirestore.instance
            .collection('groups')
            .limit(10)
            .snapshots(includeMetadataChanges: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: TextFormField(
            onFieldSubmitted: (value) {
              if (searchController.text.isNotEmpty) {
                setState(() {
                  //alldata = 2;
                  _updateSearchStream();
                });
              }
            },
            controller: searchController,
            style: const TextStyle(color: Colors.black, fontSize: 20),
            maxLines: 1,
            cursorColor: Appcolor.buttonclolor,
            cursorWidth: 3,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Appcolor.buttonclolor,
              ),
              border: InputBorder.none,
              hintText: 'Search Group...',
              contentPadding:
                  EdgeInsets.only(left: 10, top: 9, bottom: 4, right: 10),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream:
                searchStream, // Replace "userGroups" with your actual stream that fetches the DocumentSnapshot
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  color: Appcolor.buttonclolor,
                ); // Show a loading indicator while waiting for the data
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.hasData) {
                QuerySnapshot data = snapshot.data;

                List<QueryDocumentSnapshot> details = data.docs;

                List<Map<String, dynamic>> searchData = details
                    .map((e) => {
                          'Name': e['groupName'],
                          "groupIcon": e["groupIcon"],
                          "groupId": e['groupId'],
                        })
                    .toList();

                if (searchData.isNotEmpty) {
                  return ListView.builder(
                      itemCount: searchData.length,
                      // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
                      itemBuilder: (context, Index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                searchData[Index]["groupIcon"] != ""
                                    ? Image.network(
                                        searchData[Index]["groupIcon"],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        images.welcomeimage,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                const SizedBox(
                                    width:
                                        20), // Add some space between the icon and text
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Align children to opposite ends
                                    children: [
                                      AutoSizeText(
                                        searchData[Index]["Name"],
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      showButton(searchData[Index]["groupId"],
                                          searchData[Index]["Name"]),
                                      // FireBaseFuncationalities()
                                      //             .alreadyJoined(
                                      //                 searchData[Index]
                                      //                     ['groupId']) ==
                                      //         true
                                      //     ?
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        );
                      });
                } else {
                  // Handle the case where the document data is null
                  return const Text('No Such Group Exist');
                }
              } else {
                // Handle the case where the snapshot doesn't have data
                return const Text('No data found.');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget showButton(String groupId, String groupName) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocumentReference = userColledtion.doc(uid);

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
          return Text('Error: ${snapshot.error}');
        }

        DocumentSnapshot documentSnapshot = snapshot.data!;
        List<dynamic> groups = documentSnapshot['groups'];

        if (groups.contains(groupId)) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolor.buttonclolor,
            ),
            onPressed: () {
              debugPrint(groupId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(
                    groupId: groupId,
                  ),
                ),
              );
            },
            child: const AutoSizeText(
              "Open Group",
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolor.buttonclolor,
            ),
            onPressed: () {
              debugPrint(groupId);
              userColledtion.doc(userid).update({
                'groups': FieldValue.arrayUnion(
                  [groupId],
                ),
              });
              groupColledtion.doc(groupId).update({
                'members': FieldValue.arrayUnion(
                  [userid],
                ),
              });
            },
            child: const AutoSizeText(
              "Join Group",
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
