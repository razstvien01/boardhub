import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextField(
        cursorColor: kPrimaryColor,
          decoration: InputDecoration(
      
            
        border: InputBorder.none,
        filled: true,
        fillColor: kAccentColor,
        hintText: "Search. . .",
        prefixIcon: Icon(
          Icons.search,
          color: kPrimaryColor,
        ),
        suffixIcon: Icon(
          Icons.filter_alt_outlined,
          color: kPrimaryColor,
        ),
      )),
    );
  }
}
