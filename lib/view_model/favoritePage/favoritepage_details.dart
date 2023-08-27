import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';

import '../../model/favoritePage/LocalStorage/favoritemodel.dart';
import '../../res/app_fonts/app_fonts.dart';
import '../../widgets/favorite/favoriteCard.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class FavoritePageDetails extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FavoritePageDetails({Key? key});

  static const TextStyle heading = TextStyle(
    color: Appcolor.textcolor,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.schylerRegular,
    fontStyle: FontStyle.normal,
  );

  @override
  State<FavoritePageDetails> createState() => _FavoritePageDetailsState();
}

class _FavoritePageDetailsState extends State<FavoritePageDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 10, bottom: 10, right: 10),
      child: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<FavoriteModel>();
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return FavoriteCard(
                    starIcons: starz(),
                    image: data[index].images.toString(),
                    name: data[index].name.toString(),
                    id: data[index].id.toString(),
                    onPressed: () {},
                    description:
                        'Welcome to ${data[index].name.toString()} This vibrant urban hub is a fascinating blend of history, culture, and modernity. ',
                  );
                });
          }),
    );
  }

  Widget starz() {
    List<Widget> starIcons = [];
    for (int i = 0; i < 5; i++) {
      starIcons.add(
        const Icon(
          Icons.star,
          size: 20,
          color: Colors.amber,
        ),
      );
    }
    return Row(children: starIcons);
  }
}
