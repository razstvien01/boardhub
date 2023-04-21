import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constant.dart';
import 'package:path/path.dart' as p;

class EditPosts extends StatefulWidget {
  const EditPosts({super.key});

  @override
  State<EditPosts> createState() => _EditPostsState();
}

class _EditPostsState extends State<EditPosts> {
  late File imageFile = File('');
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];

  Column addImageWidget(bool isThumbnail) {
    return Column(
      children: [
        (imageFile.path == '' && isThumbnail)
            ? Icon(
                Icons.image,
                size: 60,
                color: kPrimaryColor,
              )
            : (isThumbnail)
                ? InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _selectPhoto(true),
                    // child: Image.network(
                    //   imageUrl as String,
                    //   width: 400,
                    //   height: 200,
                    // ),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(),
        InkWell(
          onTap: () => _selectPhoto(isThumbnail),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (imageFile.path != '' && isThumbnail)
                  ? 'Change thumbnail'
                  : (isThumbnail)
                      ? 'Select thumbnail'
                      : 'Add Images',
              style: kAccentTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
  }

  void selectImages(ImageSource source) async {
    final selectedImage = await _picker.pickImage(source: source);

    print("Passed");

    if (selectedImage == null) return;

    // if (selectedImage!.path.isNotEmpty) {
    //   _imageList.add(selectedImage);
    // }

    final file = await ImageCropper().cropImage(sourcePath: selectedImage.path);

    var imgFile = File(file!.path);

    imgFile = await compressImage(file.path, 35);

    _imageList.add(imgFile);

    setState(() {});

    // _imageList.add(await compressImage(file.pa
    // , 35))
  }

  Future _pickImage(ImageSource source, double x, double y) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    final file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: x, ratioY: y),
    );

    if (file == null) {
      return;
    }

    // setState(() {
    imageFile = File(file.path);
    // });

    imageFile = await compressImage(file.path, 35);

    setState(() {});

    //await _uploadFile(imageFile.path);
  }

  Future _selectPhoto(bool isThumbnail) async {
    await showModalBottomSheet(
        backgroundColor: kPrimaryColor,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: kLightColor),
                title: const Text(
                  'Camera',
                  style: kSmallTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  (isThumbnail)
                      ? _pickImage(ImageSource.camera, 16, 9)
                      // : _pickImage(ImageSource.camera, 16, 9);
                      : selectImages(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.filter, color: kLightColor),
                title: const Text(
                  'Pick a file',
                  style: kSmallTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  (isThumbnail)
                      ? _pickImage(ImageSource.gallery, 16, 9)
                      // : _pickImage(ImageSource.gallery, 16, 9);
                      : selectImages(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: const Text(
          'Edit Post',
          style: kSubTextStyle,
        ),
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              addImageWidget(true),
              addImageWidget(false),
              (_imageList.isNotEmpty)
                  ? SizedBox(
                      height: 180,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: _imageList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(
                                    _imageList[index].path,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      _imageList.removeAt(index);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: kDefaultPadding,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
