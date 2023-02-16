

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/drawer/nav_drawer.dart';
import 'package:rent_house/navbar.dart';
import 'package:rent_house/screens/signin/signin.dart';

class AuthStateChange extends StatefulWidget {
  const AuthStateChange({super.key});

  @override
  State<AuthStateChange> createState() => _AuthStateChangeState();
}

class _AuthStateChangeState extends State<AuthStateChange> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(snapshot.hasData)
        {
          // return NavDrawer();
          return NavBar();
        }
        else {
          return SignIn();
        }
      },
    );
  }
}