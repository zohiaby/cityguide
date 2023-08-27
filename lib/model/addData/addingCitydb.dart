import 'package:cityguide/res/app_data/appData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CityDataToDb {
  late String id;

  static Future<String> onPressed(name, description, private, public, summer,
      winter, rating, visitors, context) async {
    int ratingValue = int.parse(rating.text);
    int visitorsValue = int.parse(visitors.text);

    Map<String, dynamic> cityData = {
      "name": name.text,
      "description": description.text,
      "private": private.text,
      "public": public.text,
      "summer": summer.text,
      "winter": winter.text,
      "rating": ratingValue,
      "visitors": visitorsValue,
      "coverImage": Data.imageUrls[0],
    };

    DocumentReference cityDataRef =
        await FirebaseFirestore.instance.collection("city_data").add(cityData);

    String cityDataId = cityDataRef.id;
    debugPrint(cityDataId);
    debugPrint('City data added');

    Map<String, dynamic> cityPictures = {};
    for (int i = 1; i < Data.imageUrls.length; i++) {
      if (Data.imageUrls[i] != "") {
        cityPictures["image"] = Data.imageUrls[i];
        await FirebaseFirestore.instance
            .collection("city_data")
            .doc(cityDataId)
            .collection("images")
            .add(cityPictures);
      }
    }
    debugPrint('Images added');

    return cityDataId;
  }
}
