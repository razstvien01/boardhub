import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rent_house/drawer/nav_drawer.dart';
import 'package:rent_house/navbar.dart';
import 'package:rent_house/services/auth.dart';
import 'package:rent_house/screens/signin/signin.dart';
import 'package:rent_house/screens/signup/signup.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //* Setting statusbarcolor to kTransparent
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: kTransparent,
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'news_flight',

      //* Removing the debug banner
      debugShowCheckedModeBanner: false,

      //* Setting up themedata of the app
      // theme: ThemeData(
      //   primaryColor: kPrimaryColor,
      //   colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kDarkColor),
      //   highlightColor: kTransparent,
      //   fontFamily: 'Jaapokki',
      // ),
      home: NavBar(),

      //* App routes
      routes: {
      //   '/intro': (context) => const Intro(),
        '/auth': (context) => const AuthStateChange(),
      //   '/onboard': (context) => const Onboard(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
      },
    );
  }
}
