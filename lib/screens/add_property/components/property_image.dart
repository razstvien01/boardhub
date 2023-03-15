import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_house/constant.dart';

import 'package:path/path.dart' as p;

class PropertyImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  const PropertyImage({super.key, required this.onFileChanged});

  @override
  State<PropertyImage> createState() => _PropertyImageState();
}

class _PropertyImageState extends State<PropertyImage> {
  final ImagePicker _picker = ImagePicker();

  String? imageUrl;
  late File imageFile;

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    final file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
    );

    if (file == null) {
      return;
    }

    setState(() {
      imageFile = file as File;
    });

    //imageFile = await compressImage(file.path, 35);

    //await _uploadFile(imageFile.path);
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        backgroundColor: kPrimaryColor,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera, color: kLightColor),
                title: Text(
                  'Camera',
                  style: kSmallTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.filter, color: kLightColor),
                title: Text(
                  'Pick a file',
                  style: kSmallTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (imageUrl == null)
            ? Icon(
                Icons.image,
                size: 60,
                color: kPrimaryColor,
              )
            : InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _selectPhoto(),
                // child: Image.network(
                //   imageUrl as String,
                //   width: 400,
                //   height: 200,
                // ),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.fill,
                ),
              ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              (imageUrl != null) ? 'Change photo' : 'Select photo',
              style: kAccentTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
