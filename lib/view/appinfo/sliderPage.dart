import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_data/appData.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cityguide/view/tern&conditions/termsAndConditionsPage.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../../model/authentication/userAuthentication.dart';
import '../addData/addNewCityPage.dart';
import '../login/loginPage.dart';

class SlideBar extends StatelessWidget {
  SlideBar({super.key});
  final authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Appcolor.primaryColor,
      child: ListView(padding: null, children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Image.asset(
                  images.welcomeimage,
                  fit: BoxFit.cover,
                  height: 200,
                  width: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'City Guide',
                    style: TextStyle(
                        color: Appcolor.textcolor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {
                    Share.share(
                        'City Guide APP\nMaxmize Your Insder Tips with us');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate APP'),
                  onTap: () async {
                    var openAppResult = await LaunchApp.openApp(
                      androidPackageName: 'com.android.chrome',
                      iosUrlScheme: 'googlechrome://',
                      appStoreLink:
                          'https://itunes.apple.com/us/app/chrome/id535886823',
                    );
                    print(
                        'openAppResult => $openAppResult ${openAppResult.runtimeType}');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TersmsAndConDitions(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add New City'),
                  onTap: () {
                    Data.imageUrls.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewCty(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    authentication.signOut();
                    FireBaseFuncationalities().removeUserFCMToken();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
