import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:cityguide/view/login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../res/app_data/appData.dart';

// ignore: use_key_in_widget_constructors
class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              child: Image.asset(
                images.welcomeimage,
              ),
            ),
            const Text(
              "City Guide",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Maximize your insider Tips with us",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Appcolor.textcolor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  Data.box = await Hive.openBox('box');
                  Data.box.put('access', 1);
                  //await Data.box.close();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolor.buttonclolor,
                  elevation: 10,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 4.0,
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
