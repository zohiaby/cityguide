import 'dart:async';
import 'package:cityguide/view/homePage/homepage.dart';
import 'package:cityguide/view/login/loginPage.dart';
import 'package:cityguide/view/welcomePage/welcomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../res/app_data/appData.dart';

class SplashServicse {
  Future<void> isLogin(context) async {
    final authentication = FirebaseAuth.instance;
    final user = authentication.currentUser;
    Data.box = await Hive.openBox('box');
    var accessPage = Data.box.get('access', defaultValue: 0);
    //await Data.box.close("box");
    if (accessPage == 1) {
      if (user != null) {
        Timer(
          const Duration(seconds: 1),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              )),
        );
      } else {
        Timer(
            const Duration(seconds: 1),
            () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeView()));
    }
  }
}
