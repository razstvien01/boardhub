import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  // final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text(
          "Edit Profile",
          style: kSubTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        "https://scontent.fceb1-1.fna.fbcdn.net/v/t1.6435-9/106585158_747287316016240_935640362906304336_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=174925&_nc_eui2=AeHI1dgAXfNzynblv1fAew8rZ-2h2Sez125n7aHZJ7PXbgYTqVjRLlnzxjcQ78R61bdQdJiYymZ7zKBZ7SSUA5IQ&_nc_ohc=fiURfHCH8-YAX8TltIw&_nc_ht=scontent.fceb1-1.fna&oh=00_AfBcfbVmjbwb8UiYl28i_Ueg_NPYAICHo6TTNUTkO6-Ivw&oe=640459AD"),
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
                        Icons.camera_alt,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                child: Column(
                  children: [
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _userController,
                      hintText: 'Username',
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => UpdateProfile()),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            side: BorderSide.none,
                            shape: StadiumBorder()),
                        child: Text(
                          "Confirm",
                          style: kSubTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kBigPadding,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                        elevation: 0,
                        foregroundColor: kPrimaryColor,
                        shape: StadiumBorder(),
                        side: BorderSide.none,
                        
                      ),
                      
                      child: Text(
                        "Delete Account",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
