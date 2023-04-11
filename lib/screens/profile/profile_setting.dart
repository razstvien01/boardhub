import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_house/screens/profile/components/menu_item.dart';
import 'package:rent_house/screens/profile/components/update_profile.dart';
import 'package:rent_house/ud_widgets/profile_menu.dart';

import 'package:path/path.dart' as p;

import '../../constant.dart';

class ProfileSetting extends StatefulWidget {
  VoidCallback refresh;
  ProfileSetting(this.refresh, {super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data = {};

  final ImagePicker _picker = ImagePicker();

  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  Future<void> downloadURL() async {
    try {
      profileImageURL = await FirebaseStorage.instance
          .ref('profile/${currUser?.uid}' 'profile_pic')
          .getDownloadURL();
    } catch (e) {}
  }

  Future _uploadFile(String path) async {
    // final ref = FirebaseStorage.instance.ref().child('images').child('${DateTime.now().toIso8601String() + p.basename(path)}');
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile')
        .child('${currUser?.uid}' 'profile_pic');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      profileImageURL = fileUrl;
    });

    widget.refresh();
    print("REFRESH!!!!");
    // user.update({'profile_url': profileImageURL});
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (file == null) {
      return;
    }

    final imageFile = await compressImage(file.path, 35);

    await _uploadFile(imageFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
      ),
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

      userGlbData = data;

      //print(userGlbData['bookmark']);

      try {
        downloadURL();
      } catch (e) {
        print("Download URL");
        print(e);
      }

      if (!data['enable']) {
        enable = data['enable'];
        FirebaseAuth.instance.signOut();
      }
      // profileImageURL = data['profile_url'] as String?;

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
              (profileImageURL == null)
                  ? const Icon(
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
                    color: kLightColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Icon(
                        Icons.edit,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                      items: [
                        ...MenuItems.firstItems.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: MenuItems.buildItem(item),
                          ),
                        ),
                        // const DropdownMenuItem<Divider>(
                        //     enabled: false, child: Divider()),
                        // ...MenuItems.secondItems.map(
                        //   (item) => DropdownMenuItem<MenuItem>(
                        //     value: item,
                        //     child: MenuItems.buildItem(item),
                        //   ),
                        // ),
                      ],
                      onChanged: (value) {
                        MenuItems.onChanged(
                            context, value as MenuItem, _pickImage);
                      },
                      dropdownStyleData: DropdownStyleData(
                        width: 160,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          // color: Colors.redAccent,
                          color: kPrimaryColor,
                        ),
                        elevation: 8,
                        offset: const Offset(0, 8),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        customHeights: [
                          ...List<double>.filled(
                              MenuItems.firstItems.length, 48),
                          // 8,
                          // ...List<double>.filled(
                          //     MenuItems.secondItems.length, 48),
                        ],
                        padding: const EdgeInsets.only(left: 16, right: 16),
                      ),
                    ),
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

          SizedBox(
            width: 250,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfile(() {
                            setState(() {});
                          })),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text(
                "Edit Profile",
                style: kSubTextStyle,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),

          //* Menu
          ProfileMenuWidget(
            title: "Settings",
            icon: Icons.settings,
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
            onPress: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            textColor: kAccentColor,
          ),
        ],
      ),
    );
  }
}
