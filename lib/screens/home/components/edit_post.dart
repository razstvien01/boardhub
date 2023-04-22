import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_house/screens/home/components/details_screen.dart';

import '../../../constant.dart';
import 'package:path/path.dart' as p;

import '../../../models/item_model.dart';

import '../../../ud_widgets/default_button.dart';
import '../../../ud_widgets/default_textfield.dart';

class EditPosts extends StatefulWidget {
  final Item item;
  EditPosts({
    super.key,
    required this.item,
  });

  @override
  State<EditPosts> createState() => _EditPostsState();
}

class _EditPostsState extends State<EditPosts> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  late File imageFile = File('');
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];

  String? selectedLocation;

  String? imageUrl;
  List<String?> imageUrls = [];

  @override
  void initState() {
    super.initState();

    //* initialized thumburl
    urlToFile(widget.item.thumb_url as String, "thumb", true);

    //* initialized images
    //widget.item.images

    int index = 0;
    for (var i in widget.item.images) {
      urlToFile(i, index.toString(), false);
      ++index;
    }

    //* initializing the previous values
    _titleController.text = widget.item.title!;

    selectedLocation = widget.item.location;

    _priceController.text = widget.item.price!.toString();

    _descriptionController.text = widget.item.description!;

    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  //* function to download the image from the URL and save it as a file with the given filename.
  Future<void> urlToFile(String imageUrl, String name, bool isThumbnail) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$name.png');

    //* used to write the bytes of the downloaded image data to the file. When you download an image from a URL using the http package in Flutter, the image data is returned as bytes in the response body. To save this data as a file on disk, you need to write these bytes to the file.
    await file.writeAsBytes(bytes);

    if (isThumbnail) {
      imageFile = file;
    } else {
      _imageList.add(file);
    }

    print("ImagePath");
    print(imageFile.path);

    setState(() {});
  }

  Future _uploadFile(String path, bool isThumbnail) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('properties')
        .child(DateTime.now().toIso8601String() + p.basename(path));

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
                ? Stack(
                    children: [
                      InkWell(
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
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: kPrimaryColor,
                          onPressed: () {
                            //_imageList.removeAt(index);
                            imageFile = File('');
                            setState(() {});
                          },
                        ),
                      ),
                    ],
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
              const SizedBox(
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
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: const Row(
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
                      const SizedBox(
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
                      const SizedBox(
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
                      const SizedBox(
                        height: 40,
                      ),
                      DefaultButton(
                          btnText: 'Update Post',
                          onPressed: () async {
                            Fluttertoast.showToast(
                              msg: "Updating property . . .",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kAccentColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            String? uid =
                                FirebaseAuth.instance.currentUser?.uid;

                            final properties = FirebaseFirestore.instance
                                .collection('properties')
                                .doc(selectedLocation);

                            await _uploadFile(imageFile.path, true);

                            for (File f in _imageList) {
                              await _uploadFile(f.path, false);
                            }

                            // DateTime now = DateTime.now();
                            // String formattedDate =
                            //     DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);

                            // Item.recommendation.add(Item(
                            //   _titleController.text.trim(),
                            //   widget.item.category,
                            //   selectedLocation,
                            //   double.parse(_priceController.text.trim()),
                            //   imageUrl,
                            //   _descriptionController.text.trim(),
                            //   uid,
                            //   formattedDate,
                            //   false,
                            //   imageUrls,
                            // ));

                            // Item.nearby.add(newProperty);

                            await properties.update({
                              widget.item.dateTime: {
                                'title': _titleController.text.trim(),
                                'type': widget.item.category,
                                'location': selectedLocation,
                                'price':
                                    double.parse(_priceController.text.trim()),
                                'imageUrl': imageUrl,
                                'description':
                                    _descriptionController.text.trim(),
                                'uid': uid,
                                'favorite': false,
                                'images': imageUrls,
                              }
                            });

                            Item newProperty = Item(
                              _titleController.text.trim(),
                              widget.item.category,
                              selectedLocation,
                              double.parse(_priceController.text.trim()),
                              imageUrl,
                              _descriptionController.text.trim(),
                              uid,
                              widget.item.dateTime,
                              false,
                              imageUrls,
                            );

                            if (widget.item.location != selectedLocation) {
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc('${widget.item.location}')
                                  .update({
                                widget.item.dateTime.toString():
                                    FieldValue.delete(),
                              });
                            }

                            Fluttertoast.showToast(
                              msg: "Updating completed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kAccentColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            // if (mounted) {
                            //   widget.refresh();
                            // }

                            // Navigator.of(context).pop();
                            // Navigator.of(context)
                            //         .pushReplacementNamed('/signup');

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailsSreen(newProperty, () {})),
                            );
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
}
