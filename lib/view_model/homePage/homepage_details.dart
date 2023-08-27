import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/view/chat/chatPage.dart';
import 'package:cityguide/view/favoritePage/favoritepage.dart';
import 'package:flutter/material.dart';

import '../../view/searchPage/searchPage.dart';

// ignore: must_be_immutable
class HomePageDetails extends StatelessWidget {
  const HomePageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 15, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchGroupPage(),
                ),
              );
            },
            color: Appcolor.textcolor,
            iconSize: 30,
          ),
          IconButton(
            icon: const Icon(
              Icons.message,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
            color: Appcolor.textcolor,
            iconSize: 30,
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritePage(),
                ),
              );
            },
            color: Appcolor.textcolor,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
