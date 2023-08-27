// ignore: file_names
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/scrollPictures/view/ScrollPictures.dart';

class City {
  final String name;
  final String image;
  final int rating;
  final String id;
  final int visitors;

  City(
      {required this.name,
      required this.image,
      required this.rating,
      required this.visitors,
      required this.id});

  // Factory method to create a City object from a Firestore document snapshot
  factory City.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return City(
      id: snapshot.id,
      name: data['name'] ?? '',
      image: data['coverImage'] ?? '',
      rating: (data['rating']),
      visitors: data["visitors"],
    );
  }
}

// ignore: must_be_immutable
class HomePageDataFetching extends StatefulWidget {
  int access = 0;

  HomePageDataFetching({Key? key, required this.access}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageDataFetchingState createState() => _HomePageDataFetchingState();
}

class _HomePageDataFetchingState extends State<HomePageDataFetching> {
  // ignore: non_constant_identifier_names
  late Future<List<City>> _FilteredCitiesData;
  // ignore: non_constant_identifier_names
  late Future<List<City>> _MostVisitedData;

  @override
  void initState() {
    super.initState();
    _FilteredCitiesData = _getCitiesWithFilter('All');
    _MostVisitedData = _MostVisited();
  }

  ///
  /// fetching data with button filters
  ///
  Future<List<City>> _getCitiesWithFilter(String filter) async {
    Query query;

    if (filter == 'All') {
      query = FirebaseFirestore.instance.collection('city_data');
    } else if (filter == 'Recommended') {
      query = FirebaseFirestore.instance
          .collection('city_data')
          .where('rating', isGreaterThanOrEqualTo: 10);
    } else if (filter == 'Popular') {
      query = FirebaseFirestore.instance
          .collection('city_data')
          .where('rating', isGreaterThanOrEqualTo: 7);
    } else {
      throw ArgumentError('Invalid filter value: $filter');
    }

    final QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) => City.fromSnapshot(doc)).toList();
  }

  ///
  /// fetching data by vsistiors condition
  ///
  Future<List<City>> _MostVisited() async {
    // Query query;
    // query = FirebaseFirestore.instance
    //     .collection('city_data')
    //     .where('visitors', isGreaterThanOrEqualTo: '1000');
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('city_data')
        .where('visitors', isGreaterThanOrEqualTo: 1000)
        .get();
    // final QuerySnapshot snapshot = await query.get();
    final cities = snapshot.docs.map((doc) => City.fromSnapshot(doc)).toList();

    return cities;
  }

  Widget button() {
    return DefaultTabController(
      //  initialIndex: 1,
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Appcolor.buttonclolor,
            unselectedLabelColor: Colors.black,
            indicatorColor: Appcolor.buttonclolor,
            onTap: (val) {
              if (val == 0) {
                setState(() {
                  _FilteredCitiesData = _getCitiesWithFilter("All");
                });
              }
              if (val == 1) {
                setState(() {
                  _FilteredCitiesData = _getCitiesWithFilter("Recommended");
                });
              }
              if (val == 2) {
                setState(() {
                  _FilteredCitiesData = _getCitiesWithFilter("Popular");
                });
              }
            },
            tabs: const <Widget>[
              Tab(
                text: "All",
                icon: Icon(Icons.all_inclusive),
              ),
              Tab(
                text: "Recommended",
                icon: Icon(Icons.recommend_outlined),
              ),
              Tab(
                text: "Popular",
                icon: Icon(Icons.animation),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget fetchingFilteredData() {
    return FutureBuilder<List<City>>(
      future: _FilteredCitiesData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Appcolor.buttonclolor,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final cities = snapshot.data;
          return ScrollPictures(
            images: cities!.map((data) => data.image).toList(),
            noOfImages: cities.length,
            boxHeight: 280,
            boxWidth: 350,
            noOfImagesDisplay: 0.6,
            getPading: 10,
            iconNameAccess: 1,
            names: cities.map((data) => data.name).toList(),
            ids: cities.map((data) => data.id).toList(),
          );
        }
      },
    );
  }

  Widget fetchingData() {
    return FutureBuilder<List<City>>(
      future: _MostVisitedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Appcolor.buttonclolor,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final cities = snapshot.data;
          return ScrollPictures(
            images: cities!.map((data) => data.image).toList(),
            noOfImages: cities.length,
            boxHeight: 310,
            boxWidth: 500,
            noOfImagesDisplay: 1,
            getPading: 0,
            iconNameAccess: 1,
            names: cities.map((data) => data.name).toList(),
            ids: cities.map((data) => data.id).toList(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.access == 1) fetchingData(),
        if (widget.access == 2) button(),
        if (widget.access == 2) fetchingFilteredData(),
      ],
    );
  }
}
