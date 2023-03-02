import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class AddProperty extends StatefulWidget {
  final String property_type;
  
  const AddProperty({super.key, required this.property_type});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => NotificationUI()),
        //       );
        //     },
        //     icon: Icon(
        //       Icons.notifications,
        //       color: kPrimaryColor,
        //     ),
        //   )
        // ],
      ),
      backgroundColor: kBGColor,
      
    );
  }
}