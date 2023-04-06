import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_house/constant.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      body: SafeArea(
        child: Column(children: [
          OutlinedButton(
            onPressed: imageSelect,
            child: Text(
              "Select Image",
              style: kSubTextStyle,
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        // child: Container(
                        //   child: Icon(Icons.delete, color: kPrimaryColor),
                        // ),
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: kPrimaryColor,
                          onPressed: () {
                            _imageList.removeAt(index);
                            setState(() {
                              
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  void imageSelect() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage!.path.isNotEmpty) {
      _imageList.add(selectedImage);
    }
    setState(() {});
  }
}
