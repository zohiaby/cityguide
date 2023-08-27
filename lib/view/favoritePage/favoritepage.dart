import 'package:auto_size_text/auto_size_text.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/view_model/favoritePage/favoritepage_details.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  FavoritePageDetails favoritePageDetails = const FavoritePageDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AutoSizeText(
          maxLines: 1,
          'Favorites',
          style: FavoritePageDetails.heading,
        ),
        backgroundColor: Appcolor.primaryColor,
        iconTheme: const IconThemeData(color: Appcolor.textcolor),
      ),
      backgroundColor: Appcolor.primaryColor,
      body: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: FavoritePageDetails(),
      ),
    );
  }
}
