import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_data/appData.dart';
import 'package:cityguide/view/addData/addCityDataPage.dart';
import 'package:flutter/material.dart';
import '../../model/addData/addingCitydb.dart';
import '../pickImage/pickImage.dart';

class AddNewCty extends StatefulWidget {
  const AddNewCty({Key? key}) : super(key: key);

  @override
  State<AddNewCty> createState() => _AddNewCtyState();
}

class _AddNewCtyState extends State<AddNewCty> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController private = TextEditingController();
  TextEditingController public = TextEditingController();
  TextEditingController summer = TextEditingController();
  TextEditingController winter = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController visitors = TextEditingController();
  //String coverphoto = '';

  int count = 0, count2 = 1;
  late String getCityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new city Details'),
        backgroundColor: Appcolor.primaryColor,
      ),
      backgroundColor: Appcolor.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Upload City Images',
                  style: TextStyle(
                      color: Appcolor.textcolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: PickeAndCompressImage(
                      access: 0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: PickeAndCompressImage(
                          access: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: PickeAndCompressImage(
                          access: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: PickeAndCompressImage(
                          access: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: PickeAndCompressImage(
                          access: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextField(
                controller: name,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: 'City Name'),
              ),
              TextField(
                controller: description,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              TextField(
                controller: private,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: 'Private Transport Option'),
              ),
              TextField(
                controller: public,
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: 'Public Transport Option'),
              ),
              TextField(
                controller: summer,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Summer Climate'),
              ),
              TextField(
                controller: winter,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Winter Climate'),
              ),
              TextField(
                controller: rating,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: 'City Ratings 1 to 10'),
              ),
              TextField(
                controller: visitors,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: 'Visitors Per Years'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (count2 == 1) {
                      CityDataToDb.onPressed(
                        name,
                        description,
                        private,
                        public,
                        summer,
                        winter,
                        rating,
                        visitors,
                        context,
                      ).then((cityDataId) {
                        debugPrint('Returned CityDataId: $cityDataId');
                        Data.imageUrls.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddCityData(cityid: cityDataId),
                          ),
                        );
                      }).catchError((error) {
                        debugPrint('Error: $error');
                      });

                      count2++;
                      final snackBar = SnackBar(
                        content: const Text('Data Added SuccessFully'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Upload Data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    count2 = 1;
                    name.clear();
                    description.clear();
                    private.clear();
                    public.clear();
                    summer.clear();
                    winter.clear();
                    rating.clear();
                    visitors.clear();
                    Data.imageUrls.clear();
                  },
                  child: const Text('Clear Page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
