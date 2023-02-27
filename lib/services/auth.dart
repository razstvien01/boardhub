import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/navbar.dart';
import 'package:rent_house/screens/blocked/blocked.dart';
import 'package:rent_house/screens/signin/signin.dart';

class AuthStateChange extends StatefulWidget {
  const AuthStateChange({super.key});

  @override
  State<AuthStateChange> createState() => _AuthStateChangeState();
}

class _AuthStateChangeState extends State<AuthStateChange> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.'),
          // actions: <Widget>[
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text('Disable'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text('Enable'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {


          // return SignIn();

          // return Scaffold(
          //   body: FutureBuilder<DocumentSnapshot?>(
          //     future: FirebaseFirestore.instance
          //         .collection("users")
          //         .doc("${snapshot.data!.uid}")
          //         .get(),
          //     builder: (context, ss) {

          //       print("sfjwefiewfej");

          //       Map<String, dynamic> data = ss.data?.data() as Map<String, dynamic>;

          //       if (!data["enable"]) {
          //         print("PART 11111111111111111");
          //         _dialogBuilder(context);

          //         return SignIn();
          //       }

          //       print("PART 222222222222222");
          //       return NavBar();
          //     },
          //   ),
          // );
          
          return NavBar();
        } else {
          
          if(enable)
          {
            return SignIn();
          }
          
          enable = !enable;
          return Blocked();
          
        }
      },
    );
  }
}
