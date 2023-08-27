import 'package:flutter/material.dart';
import 'package:cityguide/res/app_data/appData.dart';

import '../../res/app_colors/app_clolrs.dart';

class TersmsAndConDitions extends StatefulWidget {
  const TersmsAndConDitions({super.key});

  @override
  State<TersmsAndConDitions> createState() => _TersmsAndConDitionsState();
}

class _TersmsAndConDitionsState extends State<TersmsAndConDitions> {
  int noOflines = 50;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            top: 30,
            bottom: 10,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Terms and Conditions',
              // style: SingleCityPageDetails.heading,
            ),
          ),
        ),
        backgroundColor: Appcolor.primaryColor,
        //leading: SingleCityPageDetails.backicon(context),
      ),
      backgroundColor: Appcolor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              Data.termsAndConditions,
              style: const TextStyle(fontSize: 20),
              maxLines: noOflines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (isExpanded = !isExpanded) {
                  noOflines = 300;
                } else {
                  noOflines = 50;
                }
              });
            },
            child: Text(isExpanded ? 'Read Less' : 'Read More'),
          ),
        ]),
      ),
    );
  }
}
