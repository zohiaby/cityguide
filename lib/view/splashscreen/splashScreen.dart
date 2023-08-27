import 'package:cityguide/res/app_images/app_images.dart';
import 'package:flutter/material.dart';

import '../../view_model/splashScreen/splashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServicse _splashServicse = SplashServicse();

  @override
  void initState() {
    super.initState();
    _splashServicse.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: SizedBox(
            height: 300,
            child: Image(
              image: AssetImage(images.welcomeimage),
            ),
          ),
        ),
      ),
    );
  }
}
