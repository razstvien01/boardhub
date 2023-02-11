import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rent_house/constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // appBar: ,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                  "https://scontent.fceb1-1.fna.fbcdn.net/v/t1.6435-9/106585158_747287316016240_935640362906304336_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=174925&_nc_eui2=AeHI1dgAXfNzynblv1fAew8rZ-2h2Sez125n7aHZJ7PXbgYTqVjRLlnzxjcQ78R61bdQdJiYymZ7zKBZ7SSUA5IQ&_nc_ohc=fiURfHCH8-YAX8TltIw&_nc_ht=scontent.fceb1-1.fna&oh=00_AfBcfbVmjbwb8UiYl28i_Ueg_NPYAICHo6TTNUTkO6-Ivw&oe=640459AD"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Johan Liebert",
              style: kTitleTextStyle,
            ),
            Text(
              "johan.liebert@gmail.com",
              style: kSmallTextStyle,
            ),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
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
            ),
            
            Divider(),
            SizedBox(height: 10,),
            ProfileMenuWidget(
              title: "Information",
              icon: Icons.info,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Logout",
              icon: Icons.logout,
              onPress: () {},
            ),
          ],
        ),
      ),
    );
  }
}

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
        style: kSubTextStyle,
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
