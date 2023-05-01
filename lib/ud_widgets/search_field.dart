import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController searchController = TextEditingController();
  
  @override
  void dispose()
  {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: 500,
    //   child: TextField(
    //     cursorColor: kPrimaryColor,
    //       decoration: InputDecoration(

    //     border: InputBorder.none,
    //     filled: true,
    //     fillColor: kAccentColor,
    //     hintText: "Search. . .",
    //     prefixIcon: Icon(
    //       Icons.search,
    //       color: kPrimaryColor,
    //     ),
    //     suffixIcon: Icon(
    //       Icons.filter_alt_outlined,
    //       color: kPrimaryColor,
    //     ),
    //   )),
    // );
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: searchController,
      maxLines: null,
      decoration: InputDecoration(
        hintText: 'Search. . .',
        hintStyle: kSmallPrimTextStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: kPrimaryColor),
          onPressed: () async {
            if(searchController.text.trim() != '')
            {
              print(searchController.text.trim());
            }

            setState(() {});
            searchController.clear();
          },
        ),
      ),
      style: kSmallTextStyle,
    );
  }
}
