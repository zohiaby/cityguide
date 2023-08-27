import 'package:flutter/material.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/view_model/SingleCityPage/singleCityPage_Details.dart';

class CityDetails extends StatefulWidget {
  final String id;
  const CityDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CityDetails> createState() => _CityDetailsState();
}

class _CityDetailsState extends State<CityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'City Details',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Appcolor.textcolor),
        backgroundColor: Appcolor.primaryColor,
      ),
      backgroundColor: Appcolor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SingleCityPageDetails(
                      access: 0,
                      id: widget.id,
                      height: 300,
                      imagesToDisplay: 1,
                      pading: 0,
                      width: 400,
                      name: '',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Popular Destinations',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SingleCityPageDetails(
                      access: 2,
                      id: widget.id,
                      height: 150,
                      imagesToDisplay: 0.4,
                      pading: 10,
                      width: 150,
                      name: 'Attractions',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Popular Resturants',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SingleCityPageDetails(
                      access: 3,
                      id: widget.id,
                      height: 150,
                      imagesToDisplay: 0.4,
                      pading: 10,
                      width: 150,
                      name: 'Resturants',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Upcoming Events & Feastivals',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SingleCityPageDetails(
                      access: 4,
                      id: widget.id,
                      height: 150,
                      imagesToDisplay: 0.4,
                      pading: 10,
                      width: 150,
                      name: 'Festivals',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
