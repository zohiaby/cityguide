import 'package:flutter/material.dart';
import '../../model/citydetailsPage/SingleCitytextFetchingdb.dart';
import '../../model/citydetailsPage/SingleCityImageFetchingdb.dart';

class SingleCityPageDetails extends StatelessWidget {
  final int access;
  final String id;
  final double height;
  final double width;
  final double pading;
  final double imagesToDisplay;
  final String name;
  const SingleCityPageDetails({
    Key? key,
    required this.access,
    required this.id,
    required this.height,
    required this.width,
    required this.pading,
    required this.imagesToDisplay,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleCityImageFetchingDB(
          id: id,
          name: name,
          acces: access,
          height: height,
          widget: width,
          getPading: pading,
          getImagesToDisplay: imagesToDisplay,
        ),
        if (access == 0)
          SingleCityTextFetchingDB(
            id: id,
          ),
      ],
    );
  }
}
