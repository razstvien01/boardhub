
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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
