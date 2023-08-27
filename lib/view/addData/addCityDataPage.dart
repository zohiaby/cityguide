import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_data/appData.dart';
import 'package:flutter/material.dart';
import '../../model/addData/addCityDatadb.dart';
import '../pickImage/pickImage.dart';

class AddCityData extends StatefulWidget {
  final String cityid;
  const AddCityData({Key? key, required this.cityid}) : super(key: key);

  @override
  State<AddCityData> createState() => _AddCityDataState();
}

class _AddCityDataState extends State<AddCityData> {
  TextEditingController rname = TextEditingController();
  TextEditingController rlocation = TextEditingController();
  TextEditingController ename = TextEditingController();
  TextEditingController elocation = TextEditingController();
  TextEditingController aname = TextEditingController();
  TextEditingController alocation = TextEditingController();

  List<String> imageUrls = [];
  int count = 0, count2 = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add More City Details'),
        backgroundColor: Appcolor.primaryColor,
      ),
      backgroundColor: Appcolor.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Upload Resturant Image',
                    style: TextStyle(
                        color: Appcolor.textcolor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: PickeAndCompressImage(
                      access: 10,
                    ),
                  ),
                  TextField(
                    controller: rname,
                    keyboardType: TextInputType.name,
                    decoration:
                        const InputDecoration(hintText: 'Resturant Name'),
                  ),
                  TextField(
                    controller: rlocation,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: 'Location'),
                  ),
                  const Text(
                    'Upload Event Image',
                    style: TextStyle(
                        color: Appcolor.textcolor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: PickeAndCompressImage(
                      access: 10,
                    ),
                  ),
                  TextField(
                    controller: ename,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'Event Name'),
                  ),
                  TextField(
                    controller: elocation,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: 'Location'),
                  ),
                  const Text(
                    'Upload Attraction Image',
                    style: TextStyle(
                        color: Appcolor.textcolor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: PickeAndCompressImage(
                      access: 10,
                    ),
                  ),
                  TextField(
                    controller: aname,
                    keyboardType: TextInputType.name,
                    decoration:
                        const InputDecoration(hintText: 'Attraction Name'),
                  ),
                  TextField(
                    controller: alocation,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: 'Location'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (count2 == 1) {
                      CityDetailsDataToDb.onPressed(rname, rlocation, ename,
                          elocation, aname, alocation, widget.cityid);
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
                  child: Text('Upload Data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    count2 = 1;
                    rname.clear();
                    rlocation.clear();
                    aname.clear();
                    alocation.clear();
                    elocation.clear();
                    ename.clear();
                    Data.imageUrls.clear();
                  },
                  child: const Text('Refresh Page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
