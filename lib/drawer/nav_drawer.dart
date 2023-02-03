import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'dart:math';

import 'package:rent_house/home/home.dart';
import 'package:rent_house/navbar.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  double value = 0;

  ListTile TileButton(IconData icon, String label, VoidCallback tap) {
    return ListTile(
      // selectedColor: Colors.amber,
      // selectedTileColor: Colors.amber,
      // tileColor: Colors.amber,
      // focusColor: Colors.amber,
      // hoverColor: Colors.amber,
      onTap: tap,
      leading: Icon(
        icon,
        color: kLightColor,
      ),
      title: Text(
        label,
        style: kSubTextStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          //* Let's start first by creating the background of the
          // Container(
          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(colors: [
          //     kAccentColor,
          //     kPrimaryColor,
          //   ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          // ),

          //* navigation menu
          SafeArea(
            child: Container(
              width: 200.0,
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              "https://scontent.fceb1-1.fna.fbcdn.net/v/t1.6435-9/106585158_747287316016240_935640362906304336_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=174925&_nc_eui2=AeHI1dgAXfNzynblv1fAew8rZ-2h2Sez125n7aHZJ7PXbgYTqVjRLlnzxjcQ78R61bdQdJiYymZ7zKBZ7SSUA5IQ&_nc_ohc=fiURfHCH8-YAX8TltIw&_nc_ht=scontent.fceb1-1.fna&oh=00_AfBcfbVmjbwb8UiYl28i_Ueg_NPYAICHo6TTNUTkO6-Ivw&oe=640459AD"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Johan Liebert",
                          style: kHeadTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: [
                      TileButton(Icons.account_circle, "Profile", (){}),
                      TileButton(Icons.color_lens, "Theme", (){}),
                      TileButton(Icons.settings, "Settings", () {}),
                      TileButton(Icons.logout, "Log out", FirebaseAuth.instance.signOut),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          //* main screen
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            builder: (_, double val, __) {
              return (Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                // child: Scaffold(
                //   // backgroundColor: kPrimaryColor,
                //   appBar: AppBar(
                //     title: Text("3D Drawer Menu"),
                //   ),
                //   body: Center(
                //     child: Text("Swipe right to open the menu"),
                //   ),
                // ),
                child: NavBar(),
              ));
            },
          ),

          //* To open the drawer
          GestureDetector(
            // onTap: ()
            // {
            //   setState(() {
            //     //* if the value is equal to 0 then when we tap it will become 1 else it will become 0
            //     value == 0 ? value = 1 : value = 0;
            //   });
            // }
            onHorizontalDragUpdate: (e) {
              // print(e.delta.dx);
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
