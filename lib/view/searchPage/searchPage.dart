import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/app_image_cache/app_image_cache.dart';
import '../citydetailsPage/citydetails.dart';

class SearchGroupPage extends StatefulWidget {
  const SearchGroupPage({
    super.key,
  });

  @override
  State<SearchGroupPage> createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  final authentication = FirebaseAuth.instance;

  final TextEditingController searchController = TextEditingController();

  late Stream<QuerySnapshot<Map<String, dynamic>>>? searchStream;

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
            .collection('city_data')
            .where("name", isGreaterThanOrEqualTo: searchText)
            .where("name", isLessThanOrEqualTo: '$searchText\uf8ff')
            .snapshots(includeMetadataChanges: true);
      } else {
        searchStream = FirebaseFirestore.instance
            .collection('city_data')
            .limit(10)
            .snapshots(includeMetadataChanges: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor.primaryColor,
        centerTitle: true,
        title: const Text(
          "Search City",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Appcolor.textcolor),
        ),
        iconTheme: const IconThemeData(color: Appcolor.textcolor),
      ),
      backgroundColor: Appcolor.primaryColor,
      body: Column(
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
                hintText: 'Search City...',
                contentPadding:
                    EdgeInsets.only(left: 10, top: 9, bottom: 4, right: 10),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: searchStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    color: Appcolor.buttonclolor,
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  QuerySnapshot data = snapshot.data;

                  List<QueryDocumentSnapshot> details = data.docs;

                  List<Map<String, dynamic>> searchData = details
                      .map((e) => {
                            'name': e['name'],
                            "coverImage": e["coverImage"],
                            "cityId": e.id,
                          })
                      .toList();

                  if (searchData.isNotEmpty) {
                    return ListView.builder(
                        itemCount: searchData.length,
                        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                        itemBuilder: (context, Index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CityDetails(
                                      id: searchData[Index]["cityId"],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                  child: Row(
                                children: [
                                  searchData[Index]["coverImage"] != ""
                                      ? SizedBox(
                                          height: 100,
                                          width: 130,
                                          child: FirestoreImageWidget(
                                            imageUrl: searchData[Index]
                                                ["coverImage"],
                                          ),
                                        )
                                      : Image.asset(
                                          images.welcomeimage,
                                          height: 100,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          searchData[Index]["name"],
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          );
                        });
                  } else {
                    // Handle the case where the document data is null
                    return const Text('No Such City Exist');
                  }
                } else {
                  // Handle the case where the snapshot doesn't have data
                  return const Text('No data found.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
