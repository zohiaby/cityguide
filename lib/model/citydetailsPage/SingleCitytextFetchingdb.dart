import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SingleCityTextFetchingDB extends StatefulWidget {
  final String id;
  SingleCityTextFetchingDB({
    super.key,
    required this.id,
  });
  String name = '';
  @override
  State<SingleCityTextFetchingDB> createState() =>
      _SingleCityTextFetchingDBState();
}

class _SingleCityTextFetchingDBState extends State<SingleCityTextFetchingDB> {
  bool isExpanded = false;
  late int lines = 3;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("city_data")
          .doc(widget.id)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data!.data()!;
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['description'],
                  maxLines: lines,
                  style: const TextStyle(fontSize: 18),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (isExpanded = !isExpanded) {
                          lines = 30;
                        } else {
                          lines = 3;
                        }
                      });
                    },
                    child: Text(isExpanded ? 'Read Less' : 'Read More'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Climate',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                dataget('Summer', data['summer']),
                dataget('Winter', data['winter']),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'City Transport',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                dataget('Public', data['public']),
                dataget('Private', data['private']),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget dataget(heading, details) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                heading,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              details,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        )
      ],
    );
  }
}
