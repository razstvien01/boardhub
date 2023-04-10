import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

import '../../models/item_model.dart';
import '../home/components/details_screen.dart';
import 'profile_setting.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data = {};
  Timer? _timer;
  List<Item> _items = [];
  int total_post = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  Future<void> downloadURL() async {
    try {
      profileImageURL = await FirebaseStorage.instance
          .ref('profile/${currUser?.uid}' 'profile_pic')
          .getDownloadURL();

      // print()
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the object is still mounted before calling setState
        setState(() {
          // Update the state
        });
      }
    });

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        toolbarHeight: 80.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: kPrimaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileSetting(() {
                          setState(() {});
                        })),
              );
            },
          ),
        ],
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

      // print(propertyData);

      // for (var k in propertyData.keys) {
      //   print("sdssd");
      //   if (currUser?.uid == propertyData[k]['uid']) {

      //     print("Inside");
      //     _items.add(Item(
      //       propertyData[k]['title'],
      //       propertyData[k]['type'],
      //       propertyData[k]['location'],
      //       propertyData[k]['price'],
      //       propertyData[k]['imageUrl'],
      //       propertyData[k]['description'],
      //       propertyData[k]['uid'],
      //       k,
      //       propertyData[k]['favorite'],
      //       propertyData[k]['images'],
      //     ));
      //   }
      // }

      // _items.sort((a, b) {
      //   DateTime dateTimeA = DateTime.parse(
      //       "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
      //   DateTime dateTimeB = DateTime.parse(
      //       "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
      //   return dateTimeB.compareTo(dateTimeA);
      // });

      // return profile(context);
      return FutureBuilder<QuerySnapshot?>(
        future: FirebaseFirestore.instance.collection('properties').get(),
        builder: ((context, s) {
          if (s.hasData) {
            final allPropData = s.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            _items = [];

            total_post = 0;

            for (var i in allPropData) {
              for (var j in i.keys) {
                if (currUser?.uid == i[j]['uid']) {
                  ++total_post;
                  _items.add(Item(
                    i[j]['title'],
                    i[j]['type'],
                    i[j]['location'],
                    i[j]['price'],
                    i[j]['imageUrl'],
                    i[j]['description'],
                    i[j]['uid'],
                    j,
                    i[j]['favorite'],
                    i[j]['images'],
                  ));
                }

                // print(i[j]['images']);
              }
            }

            _items.sort((a, b) {
              DateTime dateTimeA = DateTime.parse(
                  "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
              DateTime dateTimeB = DateTime.parse(
                  "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
              return dateTimeB.compareTo(dateTimeA);
            });
            
            return profile(context);
            // return Text("Have data", style: kSubTextStyle);
          } else {
            return Container();
          }
        }),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Center profile(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 10),
                )
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage((profileImageURL != null)
                    ? profileImageURL!
                    : 'https://wallpapercave.com/wp/wp7151787.jpg'),
                // image: NetworkImage(profileImageURL!),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            data['fullname'],
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              statsWidget('Followers', '255K'),
              statsWidget('Post', total_post.toString()),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              height: 18.0,
              thickness: 0.6,
              color: Colors.orangeAccent,
            ),
          ),
          Expanded(
            // ignore: avoid_unnecessary_containers
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsSreen(_items[index], () {
                                    setState(() {});
                                  })),
                        );
                      },
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  _items[index].thumb_url as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget statsWidget(String title, String stat) {
  return Expanded(
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
        Text(
          stat,
          style: const TextStyle(
            color: Colors.orange,
          ),
        ),
      ],
    ),
  );
}
