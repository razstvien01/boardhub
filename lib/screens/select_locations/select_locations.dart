import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class SelectLocation extends StatefulWidget {
  final VoidCallback refresh;

  const SelectLocation({super.key, required this.refresh});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  final currUser = FirebaseAuth.instance.currentUser;

  ListTile placeTile(String url, String location) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
      title: Text(location, style: kSmallTextStyle),
      onTap: () {
        userGlbData['location'] = location;

        FirebaseFirestore.instance
            .collection('users')
            .doc('${currUser?.uid}')
            .update({
          'location': userGlbData['location'],
        });

        widget.refresh();

        Navigator.of(context).pop();
      },
      enabled: true,
      trailing: const Icon(Icons.place),
    );
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
        title: const Text(
          "Choose location",
          style: kSubTextStyle,
        ),
      ),
      
      body: Column(
        children: [
          ListView.builder(
              itemCount: cities.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return placeTile(cities[index].pict, cities[index].city);
              })),
        ],
      ),
    );
  }
}
