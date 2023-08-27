import 'dart:io';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_data/appData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class PickeAndCompressImage extends StatefulWidget {
  final int access;
  const PickeAndCompressImage({Key? key, required this.access})
      : super(key: key);

  @override
  State<PickeAndCompressImage> createState() => _PickeAndCompressImageState();
}

class _PickeAndCompressImageState extends State<PickeAndCompressImage> {
  File? newImage;
  XFile? image;
  CroppedFile? _croppedFile;

  final picker = ImagePicker();

  // method to pick single image while replacing the photo
  Future imagePickerFromGallery() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _cropImage();

      final bytes = await _croppedFile!.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        debugPrint('original image size:$mb');
      }
    }
    if (_croppedFile != null) {
      await _compress();
    }
  }

  Future<void> _compress() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    String imagePathToCompress =
        (_croppedFile != null) ? _croppedFile!.path : image!.path;

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      imagePathToCompress,
      targetPath,
      minHeight: 880, //you can play with this to reduce size
      minWidth: 880,
      quality: 60, // keep this high to get the original quality of image
    );

    final data = await result?.readAsBytes();
    final newKb = data!.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      debugPrint('compress image size:$newMb');
    }
    // ignore: unrelated_type_equality_checks
    if (File(result!.path) != "") {
      setState(() {
        newImage = File(result.path);
      });
      if (newImage == null) return;
      String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('cityimages');
      Reference referenceImageToUpload =
          referenceDirImage.child(uniqueImageName);
      try {
        await referenceImageToUpload.putFile(File(newImage!.path));
        String imageUrl = await referenceImageToUpload.getDownloadURL();
        setState(() async {
          Data.imageUrls.add(await imageUrl);
        });
        debugPrint('data added ${imageUrl.length}');
      } catch (error) {
        SnackBar(content: Text(error.toString()));
      }
    }
  }

  Future<void> _cropImage() async {
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop The Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop The Image',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (newImage == null || widget.access == Data.imagePickaccess) {
      return SizedBox(
          height: 50,
          width: 50,
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Appcolor.buttonclolor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_sharp,
                  size: 50,
                ),
              ),
            ),
            onTap: () async {
              await imagePickerFromGallery();
            },
          ));
    }
    return const Icon(
      Icons.done,
      color: Appcolor.buttonclolor,
    );
  }
}
