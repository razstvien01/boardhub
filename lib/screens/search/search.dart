import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      body: const Center(
        child: Center(
          child: Text(
            'Search',
            style: kHeadTextStyle,
          ),
        ),
      ),
    );
  }
}
