import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  ProfileMenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(100),
        //   color: kAccentColor,
        // ),
        child: Icon(
          icon,
          color: kPrimaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          color: textColor,
          fontWeight: FontWeight.bold,
          
        ),
        
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100),
              //     color: kAccentColor),
              child: Icon(
                Icons.arrow_forward_ios,
                color: kAccentColor,
              ),
            )
          : null,
    );
  }
}
