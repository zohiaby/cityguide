import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

import '../../res/app_image_cache/app_image_cache.dart';

class BottomSheetContent extends StatefulWidget {
  final String id;
  final String name;

  const BottomSheetContent({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _cityDataStream;

  @override
  void initState() {
    _cityDataStream = FirebaseFirestore.instance
        .collection(widget.name)
        .doc(widget.id)
        .snapshots();
    super.initState();
  }

  Widget buttons(name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: () async {
          var openAppResult = await LaunchApp.openApp(
            androidPackageName: 'com.android.chrome',
            iosUrlScheme: 'googlechrome://',
            appStoreLink: 'https://itunes.apple.com/us/app/chrome/id535886823',
          );
          debugPrint(
              'openAppResult => $openAppResult ${openAppResult.runtimeType}');
        },
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _cityDataStream,
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data()!;

              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: double.infinity,
                    child: FirestoreImageWidget(
                      imageUrl: data["image"],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data["name"],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.textcolor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data["location"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.textcolor,
                        ),
                      ),
                    ),
                  ),
                  buttons('More Details'),
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Appcolor.buttonclolor,
            ));
          }),
    );
  }
}
