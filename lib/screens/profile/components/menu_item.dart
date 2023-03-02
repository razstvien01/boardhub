import 'package:flutter/material.dart';

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
  // static const List<MenuItem> firstItems = [home, share];
  // static const List<MenuItem> secondItems = [logout];

  static const camera = MenuItem(text: 'Take a photo', icon: Icons.photo_camera);
  static const upload = MenuItem(text: 'Select a photo', icon: Icons.add_a_photo);
  // static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

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

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.camera:
        //Do something
        break;
      case MenuItems.upload:
        //Do something
        break;
    }
  }
}
