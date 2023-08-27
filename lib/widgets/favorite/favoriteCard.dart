// ignore: file_names
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';

import '../../model/favoritePage/LocalStorage/favoritemodel.dart';
import 'package:share/share.dart';

import '../../res/app_image_cache/app_image_cache.dart';
import '../../view/citydetailsPage/citydetails.dart';

class FavoriteCard extends StatefulWidget {
  const FavoriteCard({
    Key? key,
    required this.onPressed,
    required this.starIcons,
    required this.image,
    required this.name,
    required this.id,
    required this.description,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget starIcons;
  final String image;
  final String name;
  final String description;
  final String id;

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  late List<bool> isFavoriteList;

  void addToFavorite(index) {
    setState(() {
      final box = Boxes.getData();
      // Find and delete the item with the matching 'id'
      final itemIndex =
          box.values.toList().indexWhere((element) => element.id == widget.id);
      box.deleteAt(itemIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    isFavoriteList = List<bool>.generate(widget.image.length, (index) => false);
  }

  void navigateToCityDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetails(
          id: widget.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Appcolor.primaryColor,
      elevation: 10,
      child: InkWell(
        onTap: () =>
            {navigateToCityDetails(context)}, // navigateToCityDetails(context),
        child: Row(
          children: [
            SizedBox(
              height: 150,
              width: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: FirestoreImageWidget(
                  imageUrl: widget.image,
                ),
              ),
            ),
            SizedBox(
              height: 150,
              width: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Share.share(
                                "${widget.image}\n${widget.name}\n${widget.description}");
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              addToFavorite(widget.id);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.textcolor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.textcolor,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          'Ratings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.textcolor,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Row(
                          children: [widget.starIcons],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
