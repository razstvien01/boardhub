import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/signin/components/default_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // body: Center(
      //   child: Center(
      //     child: DefaultButton(
      //         btnText: 'Sign Out',
      //         onPressed: FirebaseAuth.instance
      //             .signOut //* a method that signs out the user from database,
      //         ),
      //   ),
      // ),
    );
  }
}
