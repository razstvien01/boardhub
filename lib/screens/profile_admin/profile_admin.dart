import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/accounts/accounts.dart';
import 'package:rent_house/ud_widgets/profile_menu.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  final currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data = {};
  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

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
      return const Center(child: CircularProgressIndicator());
    }
  }

  SingleChildScrollView profileUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              const CircleAvatar(
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
          const SizedBox(
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
          const SizedBox(
            height: 20,
          ),

          // SizedBox(
          //   width: 250,
          //   height: 45,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => UpdateProfile(() {
          //           setState(() {

          //           });
          //         })),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //         backgroundColor: kPrimaryColor,
          //         side: BorderSide.none,
          //         shape: StadiumBorder()),
          //     child: Text(
          //       "Edit Profile",
          //       style: kSubTextStyle,
          //     ),
          //   ),
          // ),
          const Divider(),

          //* Menu
          ProfileMenuWidget(
            title: "Settings",
            icon: Icons.settings,
            onPress: () {},
            textColor: kLightColor,
          ),

          const SizedBox(
            height: 5,
          ),

          ProfileMenuWidget(
            title: "Manage Accounts",
            icon: Icons.manage_accounts,
            onPress: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Accounts()));
            },
            textColor: kLightColor,
          ),

          const SizedBox(
            height: 5,
          ),

          ProfileMenuWidget(
            title: "View Log Report",
            icon: Icons.report,
            onPress: () {},
            textColor: kLightColor,
          ),

          const SizedBox(
            height: 5,
          ),

          ProfileMenuWidget(
            title: "View Report Bugs",
            icon: Icons.bug_report,
            onPress: () {},
            textColor: kLightColor,
          ),

          const Divider(),
          const SizedBox(
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
