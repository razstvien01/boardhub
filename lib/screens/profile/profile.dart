import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/profile/components/update_profile.dart';
import 'package:rent_house/ud_widgets/profile_menu.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // appBar: ,
      // body: profileUI(context),
      body: FutureBuilder<DocumentSnapshot?>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc("${currUser?.uid}")
            .get(),
        builder: getUserInfo,
      ),
    );
  }

  //* gets the user's information
  Widget getUserInfo(context, snapshot) {
    if (snapshot.hasData) {
      data = snapshot.data!.data() as Map<String, dynamic>;

      return profileUI(context);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  SingleChildScrollView profileUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  "https://scontent.fceb1-1.fna.fbcdn.net/v/t1.6435-9/106585158_747287316016240_935640362906304336_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=174925&_nc_eui2=AeHI1dgAXfNzynblv1fAew8rZ-2h2Sez125n7aHZJ7PXbgYTqVjRLlnzxjcQ78R61bdQdJiYymZ7zKBZ7SSUA5IQ&_nc_ohc=fiURfHCH8-YAX8TltIw&_nc_ht=scontent.fceb1-1.fna&oh=00_AfBcfbVmjbwb8UiYl28i_Ueg_NPYAICHo6TTNUTkO6-Ivw&oe=640459AD",
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kAccentColor),
                  child: Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data['fullname'],
            style: kTitleTextStyle,
          ),
          Text(
            "@${data['username']}",
            style: kSmallTextStyle,
          ),
          Text(
            "${currUser?.email}",
            style: kSmallTextStyle,
          ),
          SizedBox(
            height: 20,
          ),

          SizedBox(
            width: 250,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfile(() {
                    setState(() {
                      
                    });
                  })),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  side: BorderSide.none,
                  shape: StadiumBorder()),
              child: Text(
                "Edit Profile",
                style: kSubTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),

          //* Menu
          ProfileMenuWidget(
            title: "Settings",
            icon: Icons.settings,
            onPress: () {},
            textColor: kLightColor,
          ),

          Divider(),
          SizedBox(
            height: 10,
          ),
          ProfileMenuWidget(
            title: "Information",
            icon: Icons.info,
            onPress: () {},
            textColor: kLightColor,
          ),
          ProfileMenuWidget(
            title: "Logout",
            icon: Icons.logout,
            onPress: FirebaseAuth.instance.signOut,
            textColor: kAccentColor,
          ),
        ],
      ),
    );
  }
}
