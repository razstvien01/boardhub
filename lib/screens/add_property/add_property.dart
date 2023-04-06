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
  // List<XFile> _
  

  String? imageUrl;
  late File imageFile = File('');

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('properties')
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
      imageFile = File(file.path);
    });

    imageFile = await compressImage(file.path, 35);

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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Form(
            child: Column(
              children: [
                Column(
                  children: [
                    (imageFile.path == '')
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
                          (imageFile.path != '')
                              ? 'Change photo'
                              : 'Select photo',
                          style: kAccentTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
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
                    items: locations
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
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
                          thumbVisibility: MaterialStateProperty.all(true),
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
                        print(_titleController.text.trim());
                        print(selectedLocation);
                        print(_priceController.text.trim());
                        print(_descriptionController.text.trim());
                        print(widget.property_type);

                        String? uid = FirebaseAuth.instance.currentUser?.uid;

                        final properties = FirebaseFirestore.instance
                            .collection('properties')
                            .doc(selectedLocation);

                        await _uploadFile(imageFile.path);

                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – kk:mm').format(now);

                        Item.recommendation.add(Item(
                            _titleController.text.trim(),
                            widget.property_type,
                            selectedLocation,
                            double.parse(_priceController.text.trim()),
                            imageUrl,
                            _descriptionController.text.trim(),
                            uid,
                            formattedDate, false, ""));

                        Item newProperty = Item(
                            _titleController.text.trim(),
                            widget.property_type,
                            selectedLocation,
                            double.parse(_priceController.text.trim()),
                            imageUrl,
                            _descriptionController.text.trim(),
                            uid,
                            formattedDate, false, "");

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
      ),
    );
  }
}
