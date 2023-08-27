import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import 'package:cityguide/view_model/homePage/homepage_details.dart';
import 'package:cityguide/view/appinfo/sliderPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../model/hompedata/homePageDataFetching.dart';
import '../../model/notifications/notificationServices.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationServices notificationServices = NotificationServices();
  // NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    // Initialize NotificationServices
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    // _firebaseMessagingBackgroundHandler();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: SlideBar(),
        appBar: AppBar(
          centerTitle: true,
          title: const AutoSizeText(
            'City Guide',
            maxLines: 1,
            style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          backgroundColor: Appcolor.primaryColor,
          actions: const [
            HomePageDetails(),
          ],
        ),
        backgroundColor: Appcolor.primaryColor,
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 8),
            child: ListView(scrollDirection: Axis.vertical, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: AutoSizeText(
                      maxLines: 1,
                      'Most Visited Cities',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  HomePageDataFetching(
                    access: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: AutoSizeText(
                        maxLines: 1,
                        'Cities',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  HomePageDataFetching(
                    access: 2,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();

  //   debugPrint("Handling a background message: ${message.messageId}");
  // }
}
