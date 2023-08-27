// import 'dart:js';

import 'package:cityguide/view/splashscreen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';
import 'model/favoritePage/LocalStorage/favoritemodel.dart';

void main() async {
  /// insuring the connection is created
  WidgetsFlutterBinding.ensureInitialized();

  /// intilizing the app with firestore data
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(FavoriteModelAdapter());

  await Hive.openBox<FavoriteModel>('favorite');
  await Future.delayed(const Duration(milliseconds: 300));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'City Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
