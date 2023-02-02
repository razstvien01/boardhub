
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/home/home.dart';
import 'package:rent_house/search/search.dart';

import 'bookmark/bookmark.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  final user = FirebaseAuth.instance.currentUser;
  
  List<Widget> widgetOptions()
  {
      return [
        Home(),
        Search(),
        Bookmark(),
      ];
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
  void initState()
  {
    
  }
  
  void onTap(int index)
  {
    setState(() {
      this.index = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      // Icon(Icons.home, size: 25),
      Icon(Icons.home, size: 25, color: kLightColor),
      Icon(Icons.search, size: 25, color: kLightColor),
      Icon(Icons.bookmark, size: 25, color: kLightColor),
      
    ];
    
    titleList = [
      "Home",
      "Search",
      "Bookmark",
    ];
    
    return Scaffold(
      extendBody: true,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text(
        //       titleList[index],
        //       style: kHeadTextStyle,
        //     ),
        //   ],
        // ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: kPrimaryColor)),
        child: CurvedNavigationBar(
          color: kPrimaryColor,
          backgroundColor: kPrimaryColor,
          items: items,
          index: index,
          height: 60,
          buttonBackgroundColor: kPrimaryColor,
          onTap: onTap,
        ),
      ),
      body: IndexedStack(
        index: index,
        children: widgetOptions(),
      ),
    );
  }
}