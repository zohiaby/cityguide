import 'package:carousel_slider/carousel_slider.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import '../../../model/citydetailsPage/SingleCitytextFetchingdb.dart';
import '../../../model/favoritePage/LocalStorage/favoritemodel.dart';
import '../../../res/app_image_cache/app_image_cache.dart';
import '../viewModel/ScrollPictureDestails.dart';

class ScrollPictures extends StatefulWidget {
  final List images;
  final List names;
  final double boxHeight;
  final double boxWidth;
  final double noOfImagesDisplay;
  final double getPading;
  final int iconNameAccess;
  final int noOfImages;
  final List ids;

  const ScrollPictures({
    Key? key,
    required this.images,
    required this.noOfImages,
    required this.boxHeight,
    required this.boxWidth,
    required this.noOfImagesDisplay,
    required this.getPading,
    required this.iconNameAccess,
    required this.names,
    required this.ids,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScrollPicturesState createState() => _ScrollPicturesState();
}

class _ScrollPicturesState extends State<ScrollPictures> {
  late List<bool> isFavoriteList;
  int currentIndex = 0;

  final CarouselController _carouselController = CarouselController();
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  void addToFavorite(index, String image, String name, String id) {
    setState(() {
      isFavoriteList[index] = !isFavoriteList[index];
      if (isFavoriteList[index]) {
        final data = FavoriteModel(image, name, id);
        final box = Boxes.getData();
        box.add(data);
      } else {
        final box = Boxes.getData();
        // Find and delete the item with the matching 'id'
        final itemIndex =
            box.values.toList().indexWhere((element) => element.id == id);
        if (itemIndex >= 0) {
          box.deleteAt(itemIndex);
        }
      }
    });
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Appcolor.buttonclolor : Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isFavoriteList =
        List<bool>.generate(widget.images.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: SizedBox(
        height: widget.boxHeight.toDouble(),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: widget.images.length,
                itemBuilder: (context, index, _) {
                  return GestureDetector(
                    onTap: () {
                      const ScrollPictures_Detsils().imageIconsAccess(
                        context,
                        widget.iconNameAccess,
                        widget.ids[index],
                        widget.names,
                      );
                      if (widget.iconNameAccess == 1) {
                        setState(() {
                          SingleCityTextFetchingDB(
                            id: widget.ids[index],
                          );
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: widget.getPading),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: widget.boxHeight.toDouble(),
                            width: widget.boxWidth.toDouble(),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: FirestoreImageWidget(
                                imageUrl: widget.images[index],
                              ),
                            ),
                          ),
                          if (widget.iconNameAccess == 1)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: Icon(
                                  isFavoriteList[index]
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavoriteList[index]
                                      ? Colors.red
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  if (index < 3) {
                                    addToFavorite(index, widget.images[index],
                                        widget.names[index], widget.ids[index]);
                                  }
                                },
                              ),
                            ),
                          if (widget.iconNameAccess == 1)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: widget.names[index] != null &&
                                      widget.names[index] != ""
                                  ? Text(
                                      widget.names[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text(""),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: widget.boxHeight.toDouble(),
                  viewportFraction: widget.noOfImagesDisplay,
                  autoPlay: true,
                  initialPage: 1,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, _) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0;
                      i < (widget.images.length < 5 ? widget.images.length : 5);
                      i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: buildIndicator(currentIndex == i),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
