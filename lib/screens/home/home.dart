import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/add_property/add_property.dart';
import 'package:rent_house/screens/notification/notification_page.dart';
import 'package:rent_house/screens/select_locations/select_locations.dart';
import 'package:rent_house/ud_widgets/search_field.dart';
import 'package:rent_house/ud_widgets/select_category.dart';
import 'package:rent_house/ud_widgets/suggestion_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  void refreshHome(VoidCallback refresh) {
    refresh();
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? _timer;

  @override
  void initState() {
    
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in the dispose() method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) { // Check if the object is still mounted before calling setState
        setState(() {
          // Update the state
        });
      }
    });

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.location_on, color: kPrimaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectLocation(refresh: () {
                            setState(() {});
                          })),
                );
              },
            ),
            (userGlbData['location'] == null) ? const CircularProgressIndicator() : Text(
              userGlbData['location'],
              style: kSubTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationUI()),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SearchField(),
              const SelectCategory(),
              SuggestionList(
                "Recommendation for you",
                Item.recommendation,
              ),
              SuggestionList(
                "Nearby you",
                const [],
              ),
            ],
          ),
        ),
      ),

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
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'House',
                          refresh: () => setState(() {}),
                        )),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              LineIcons.building,
              color: kPrimaryColor,
            ),
            label: 'Land',
            onTap: () {
              Fluttertoast.showToast(
                msg: "Land Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'Land',
                          refresh: () => setState(() {}),
                        )),
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
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'Apartment',
                          refresh: () => setState(() {}),
                        )),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              LineIcons.building,
              color: kPrimaryColor,
            ),
            label: 'Condo',
            onTap: () {
              print('ontap');
              // Fluttertoast.showToast(msg: "RANDOM", fontSize: 18, );
              Fluttertoast.showToast(
                msg: "Condo Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'Condo',
                          refresh: () => setState(() {}),
                        )),
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
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'Villa',
                          refresh: () => setState(() {}),
                        )),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: kBGColor,
            child: Icon(
              Icons.castle,
              color: kPrimaryColor,
            ),
            label: 'Castle',
            onTap: () {
              Fluttertoast.showToast(
                msg: "Castle Selected . . .",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: kAccentColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProperty(
                          property_type: 'Castle',
                          refresh: () => setState(() {}),
                        )),
              );
            },
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
