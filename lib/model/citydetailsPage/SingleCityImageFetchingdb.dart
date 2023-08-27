import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/scrollPictures/view/ScrollPictures.dart';

class SingleCityImageFetchingDB extends StatefulWidget {
  final String id;
  final String name;
  final int acces;
  final double height;
  final double widget;
  final double getPading;
  final double getImagesToDisplay;

  SingleCityImageFetchingDB(
      {super.key,
      required this.id,
      required this.name,
      required this.acces,
      required this.height,
      required this.widget,
      required this.getPading,
      required this.getImagesToDisplay});

  @override
  State<SingleCityImageFetchingDB> createState() =>
      _SingleCityImageFetchingDBState();
}

class _SingleCityImageFetchingDBState extends State<SingleCityImageFetchingDB> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _cityDataStream;

  @override
  void initState() {
    if (widget.acces == 0) {
      _cityDataStream = FirebaseFirestore.instance
          .collection("city_data")
          .doc(widget.id)
          .collection('images')
          .snapshots();
    } else if (widget.acces >= 2) {
      _cityDataStream = FirebaseFirestore.instance
          .collection(widget.name)
          .where("cityId", isEqualTo: widget.id)
          .snapshots();
    } else {
      const Text('Invalid Access');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cityDataStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
                "${snapshot.hasError.toString()} no data and id id\n\n ${widget.id}   "),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          QuerySnapshot data = snapshot.data;
          List<QueryDocumentSnapshot> details = data.docs;

          List<Map<String, dynamic>> cityResturants = details
              .map((e) => {
                    'id': e.id,
                    "image": e["image"] as String,
                  })
              .toList();

          return ScrollPictures(
            images: cityResturants.map((data) => data["image"]).toList(),
            noOfImages: cityResturants.length,
            boxHeight: widget.height,
            boxWidth: widget.widget,
            noOfImagesDisplay: widget.getImagesToDisplay,
            getPading: widget.getPading,
            iconNameAccess: widget.acces,
            names: cityResturants,
            ids: cityResturants.map((data) => data["id"]).toList(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
