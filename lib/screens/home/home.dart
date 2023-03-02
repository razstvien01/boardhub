import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/add_property/add_property.dart';
import 'package:rent_house/screens/notification/notification.dart';
import 'package:rent_house/screens/signin/components/default_button.dart';
import 'package:rent_house/ud_widgets/search_field.dart';
import 'package:rent_house/ud_widgets/select_category.dart';
import 'package:rent_house/ud_widgets/suggestion_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: kPrimaryColor,
            ),
            Text(
              "Cebu City, Philippines",
              style: kSubTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationUI()),
              );
            },
            icon: Icon(
              Icons.notifications,
              color: kPrimaryColor,
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchField(),
              SelectCategory(),
              // SizedBox(
              //   height: 10.0,
              // ),
              SuggestionList("Recommendation for you", Item.recommendation),
              SuggestionList("Nearby you", Item.nearby),
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: kBGColor,
      //   foregroundColor: kPrimaryColor,
      //   shape: BeveledRectangleBorder(
      //     borderRadius: BorderRadius.circular(20.0),
      //     side: BorderSide(color: kPrimaryColor, width: 3.0, style: BorderStyle.solid),
      //   ),
      //   // mini: true,
      // ),
      floatingActionButton: SpeedDial(
        icon: Icons.add_home,
        backgroundColor: kBGColor,
        foregroundColor: kPrimaryColor,
        overlayColor: kBGColor,
        overlayOpacity: 0.4,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
              color: kPrimaryColor, width: 2.0, style: BorderStyle.solid),
        ),
        children: [
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              Icons.house,
              color: kPrimaryColor,
            ),
            label: 'House',
            onTap: () {
              Fluttertoast.showToast(
                msg: "House Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProperty(property_type: 'House')),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              Icons.villa,
              color: kPrimaryColor,
            ),
            label: 'Villa',
            onTap: () {
              Fluttertoast.showToast(
                msg: "Villa Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProperty(property_type: 'Villa')),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              Icons.apartment,
              color: kPrimaryColor,
            ),
            label: 'Apartment',
            onTap: () {
              print('ontap');
              // Fluttertoast.showToast(msg: "RANDOM", fontSize: 18, );
              Fluttertoast.showToast(
                msg: "Apartment Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProperty(property_type: 'Apartment')),
              );
            },
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
