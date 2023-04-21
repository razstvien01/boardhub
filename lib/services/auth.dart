import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/navbar.dart';
import 'package:rent_house/screens/blocked/blocked.dart';

import '../screens/onboard/onboard.dart';

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
        return const AlertDialog(
          title: Text('Basic dialog title'),
          content: Text('A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.'),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          
          return const NavBar();
        } else {
          
          if(enable)
          {
            // return const SignIn();
            return const OnboardingPage();
          }
          
          enable = !enable;
          return const Blocked();
          
        }
      },
    );
  }
}
