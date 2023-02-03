import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: kBGColor,
      body: Center(
        child: Center(
          child: Text(
            'Bookmark',
            style: kHeadTextStyle,
          ),
        ),
      ),
    );
  }
}