import 'package:flutter/material.dart';
import '../../../view/citydetailsPage/citydetails.dart';
import '../../citydetails/bottomsheat.dart';

// ignore: camel_case_types
class ScrollPictures_Detsils extends StatelessWidget {
  const ScrollPictures_Detsils({super.key});

  void imageIconsAccess(
    context,
    iconNameAccess,
    id,
    name,
  ) {
    if (iconNameAccess == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CityDetails(
            id: id,
          ),
        ),
      );
    } else if (iconNameAccess > 1) {
      bottomSheatContent(
        context,
        iconNameAccess,
        id,
      );
      const SnackBar(
        content: Text('accessing bottom sheat'),
      );
    }
  }

  void bottomSheatContent(
    context,
    iconNameAccess,
    index,
  ) {
    late String name;
    switch (iconNameAccess) {
      case 2:
        {
          name = "Attractions";
          showBottomSheet(
            context,
            index,
            name,
          );
          break;
        }
      case 3:
        {
          name = "Resturants";
          showBottomSheet(
            context,
            index,
            name,
          );
          break;
        }
      case 4:
        {
          name = "Festivals";
          showBottomSheet(
            context,
            index,
            name,
          );
          break;
        }
    }
  }

  showBottomSheet(
    context,
    String id,
    String name,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Set a fraction of the screen height
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomSheetContent(
                id: id,
                name: name,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
