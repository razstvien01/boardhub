import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';
import 'package:rent_house/ud_widgets/default_button.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';

import 'components/property_image.dart';
import 'package:path/path.dart' as p;

import 'package:intl/intl.dart';

class AddProperty extends StatefulWidget {
  final String property_type;
  final VoidCallback refresh;

  const AddProperty(
      {super.key, required this.property_type, required this.refresh});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final currUser = FirebaseAuth.instance.currentUser;

  final List<String> locations = ['Cebu City, Cebu', 'Talisay City, Cebu'];
  String? selectedLocation;

  final ImagePicker _picker = ImagePicker();
  List<File> _imageList = [];

  String? imageUrl;
  List<String?> imageUrls = [];
  late File imageFile = File('');

  Future _uploadFile(String path, bool isThumbnail) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('properties')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      if (isThumbnail) {
        imageUrl = fileUrl;
      } else {
        imageUrls.add(fileUrl);
      }
    });
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
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
                leading: Icon(Icons.camera, color: kLightColor),
                title: Text(
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
                leading: Icon(Icons.filter, color: kLightColor),
                title: Text(
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
              // if (!isThumbnail)
              //   Expanded(
              //     child: GridView.builder(
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 3,
              //       ),
              //       itemCount: _imageList.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.all(2.0),
              //           child: Stack(),
              //         );
              //       },
              //     ),
              //   ),
            ],
          );
        });
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_imageList.length);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Text(
          'Add ${widget.property_type}',
          style: kSubTextStyle,
        ),
      ),
      backgroundColor: kBGColor,
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
                                    icon: Icon(Icons.delete),
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
                  : SizedBox(
                      height: kDefaultPadding,
                    ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                child: Form(
                  child: Column(
                    children: [
                      // Form(child:  )

                      DefaultTextField(
                        validator: (value) {
                          return null;
                        },
                        controller: _titleController,
                        hintText: 'Title',
                        icon: Icons.title,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 16,
                                color: kLightColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'Select Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kLightColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: cities
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.city,
                                    child: Text(
                                      item.city,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedLocation,
                          onChanged: (value) {
                            setState(() {
                              selectedLocation = value as String;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 350,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: kPrimaryColor,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Colors.yellow,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 350,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: kPrimaryColor,
                              ),
                              elevation: 8,
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              )),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      DefaultTextField(
                        validator: (value) {
                          return null;
                        },
                        controller: _priceController,
                        hintText: 'Price per month',
                        icon: LineIcons.dollarSign,
                        keyboardType: TextInputType.number,
                        maxLines: 8,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      DefaultTextField(
                        validator: (value) {
                          return null;
                        },
                        controller: _descriptionController,
                        hintText: 'Description',
                        icon: Icons.description,
                        keyboardType: TextInputType.text,
                        maxLines: 50,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      DefaultButton(
                          btnText: 'Add Property',
                          onPressed: () async {
                            if (_titleController.text.trim() != null) {
                              // print(_titleController.text.trim());
                              // print(selectedLocation);
                              // print(_priceController.text.trim());
                              // print(_descriptionController.text.trim());
                              // print(widget.property_type);

                              String? uid =
                                  FirebaseAuth.instance.currentUser?.uid;

                              final properties = FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(selectedLocation);

                              await _uploadFile(imageFile.path, true);

                              for (File f in _imageList) {
                                await _uploadFile(f.path, false);
                              }

                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd – kk:mm:ss')
                                      .format(now);

                              Item.recommendation.add(Item(
                                _titleController.text.trim(),
                                widget.property_type,
                                selectedLocation,
                                double.parse(_priceController.text.trim()),
                                imageUrl,
                                _descriptionController.text.trim(),
                                uid,
                                formattedDate,
                                false,
                                imageUrls,
                              ));

                              Item newProperty = Item(
                                _titleController.text.trim(),
                                widget.property_type,
                                selectedLocation,
                                double.parse(_priceController.text.trim()),
                                imageUrl,
                                _descriptionController.text.trim(),
                                uid,
                                formattedDate,
                                false,
                                imageUrls,
                              );

                              Item.nearby.add(newProperty);

                              properties.update({
                                newProperty.dateTime: {
                                  'title': newProperty.title,
                                  'type': newProperty.category,
                                  'location': newProperty.location,
                                  'price': newProperty.price,
                                  'imageUrl': newProperty.thumb_url,
                                  'description': newProperty.description,
                                  'uid': newProperty.tenantID,
                                  'favorite': false,
                                  'images': newProperty.images,
                                }
                              });

                              Fluttertoast.showToast(
                                msg: "Posting property . . .",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kAccentColor,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                              if (mounted) {
                                widget.refresh();
                              }
                              Navigator.of(context).pop();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            padding: EdgeInsets.all(8.0),
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
}
