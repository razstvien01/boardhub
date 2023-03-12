import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rent_house/constant.dart';

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [camera, upload];

  static const camera = MenuItem(text: 'Take a photo', icon: Icons.photo_camera);
  static const upload = MenuItem(text: 'Select a photo', icon: Icons.add_a_photo);
  

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 20),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, Function function) {
    switch (item) {
      case MenuItems.camera:
        
        function(ImageSource.camera);
        break;
      case MenuItems.upload:
        
        function(ImageSource.gallery);
        break;
    }
  }
}
