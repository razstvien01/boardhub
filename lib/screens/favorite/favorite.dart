import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
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