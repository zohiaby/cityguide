import 'package:cityguide/res/app_data/appData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CityDetailsDataToDb {
  final firestoreInstance = FirebaseFirestore.instance;
  final firestoreInstanceImages = FirebaseFirestore.instance;

  static onPressed(
      rname, rlocation, ename, elocation, aname, alocation, cityid) {
    Map<String, dynamic> resturantData = {
      "name": rname.text,
      "location": rlocation.text,
      "image": Data.imageUrls[0],
      "cityId": cityid,
    };
    Map<String, dynamic> fesivalData = {
      "name": rname.text,
      "location": rlocation.text,
      "image": Data.imageUrls[1],
      "cityId": cityid,
    };
    Map<String, dynamic> attractionData = {
      "name": rname.text,
      "location": rlocation.text,
      "image": Data.imageUrls[2],
      "cityId": cityid,
    };
    if (Data.imageUrls[1] != "") {
      FirebaseFirestore.instance
          .collection('Resturants')
          .add(resturantData)
          .then((value) {
        debugPrint('Data Added');
      });
    }
    if (Data.imageUrls[2] != "") {
      FirebaseFirestore.instance
          .collection('Attractions')
          .add(attractionData)
          .then((value) {
        debugPrint(value.id);
        debugPrint('Data Added');
      });
    }
    if (Data.imageUrls[0] != "") {
      FirebaseFirestore.instance
          .collection('Festivals')
          .add(fesivalData)
          .then((value) {
        debugPrint(value.id);
        debugPrint('Data Added');
      });
    }
  }
}
