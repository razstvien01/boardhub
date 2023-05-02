import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/chat/chat.dart';
import 'package:rent_house/screens/home/home.dart';
import 'package:rent_house/screens/profile/profile.dart';

import 'screens/favorite/favorite.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final user = FirebaseAuth.instance.currentUser;

  // final docUser = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);

  // (user?.email != "admin@boardhub.com")
  List<Widget> widgetOptions() {
    return [
      const Home(),
      // Search(),
      Favorite(favItems),
      const Chat(),
      const Profile(isCurrUserProfile: true, uid: '',),
    ];
    // return (user?.email != "admin@boardhub.com")
    //     ? [
    //         const Home(),
    //         // Search(),
    //         Favorite(favItems),
    //         const Chat(),
    //         const Profile(),
    //       ]
    //     : [
    //         const Home(),
    //         // Search(),
    //         Favorite(favItems),
    //         const Chat(),
    //         const ProfileAdmin(),
    //       ];
    // return (user?.email == "admin@gmail.com")
    //   ? [
    //       Home(articles: glbArticles),
    //       Bookmark(bm: bm),
    //       const Report(),
    //       const Accounts(),
    //       const Profile(),
    //     ]
    //   : [
    //       Home(articles: glbArticles),
    //       Bookmark(bm: bm),
    //       const Profile(),
    //     ];
  }

  List<String> titleList = [];

  @override
  void initState() {
    super.initState();

    //* sorting cities
    cities.sort((a, b) => a.city.compareTo(b.city));
  }

  void onTap(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      // Icon(Icons.home, size: 25),
      const Icon(Icons.home, size: 25, color: kLightColor),
      // Icon(Icons.search, size: 25, color: kLightColor),
      const Icon(CupertinoIcons.heart_fill, size: 25, color: kLightColor),
      const Icon(Icons.message, size: 25, color: kLightColor),
      const Icon(Icons.person_2, size: 25, color: kLightColor)
    ];

    // titleList = [
    //   "Home",
    //   "Search",
    //   "Favorites",
    //   "Messages",
    //   "Profile",
    // ];

    return Scaffold(
      // extendBody: true,
      backgroundColor: kBGColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: kBGColor,
          // title: Text('Home'),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: kPrimaryColor)),
        child: CurvedNavigationBar(
          color: kPrimaryColor,
          backgroundColor: Colors.transparent,
          // backgroundColor: ,
          items: items,
          index: index,
          height: 60,
          buttonBackgroundColor: kPrimaryColor,
          onTap: onTap,
          animationCurve: Curves.easeInOut,
        ),
      ),
      body: IndexedStack(
        index: index,
        children: widgetOptions(),
      ),
      // body: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAr,
      //   children: widgetOptions(),
      // ),
    );
  }
}
