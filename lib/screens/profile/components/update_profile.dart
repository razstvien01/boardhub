import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';

class UpdateProfile extends StatefulWidget {
  final VoidCallback refresh;

  UpdateProfile(this.refresh, {super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _userController = TextEditingController();
  // final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  // final _passwordController1 = TextEditingController();
  // final _passwordController2 = TextEditingController();

  final currUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _userController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

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
                  // CircleAvatar(
                  //   radius: 50.0,
                  //   backgroundImage: NetworkImage(
                  //       profileImageURL as String,
                  //       ),
                  // ),
                  (profileImageURL == null)
                  ? Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    )
                  : CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(profileImageURL as String),
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
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_2,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _numberController,
                      hintText: 'Contact Number',
                      icon: Icons.phone,
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
                          //* if text is empty
                          if (_userController.text.trim() == '' ||
                              _nameController.text.trim() == '' ||
                              _numberController.text.trim() == '') {
                            // AlertDialog(
                            //   content: Text("Don't leave the entry empty."),
                            // );
                            return;
                          }

                          //* update
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc('${currUser?.uid}')
                              .update({
                            'username': _userController.text.trim(),
                            'fullname': _nameController.text.trim(),
                            'contact number': _numberController.text.trim(),
                          });

                          widget.refresh();

                          //* pop
                          Navigator.pop(context);
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
                      onPressed: () async{
                        await AuthService().deleteUser();
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                        elevation: 0,
                        foregroundColor: kLightColor,
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
