import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/signin/components/default_button.dart';
import 'package:rent_house/ud_widgets/search_field.dart';
import 'package:rent_house/ud_widgets/select_category.dart';
import 'package:rent_house/ud_widgets/suggestion_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: kPrimaryColor,
            ),
            Text(
              "Cebu City, Philippines",
              style: kSubTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: kPrimaryColor,
            ),
          )
        ],
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchField(),
              SelectCategory(),
              // SizedBox(
              //   height: 10.0,
              // ),
              SuggestionList("Recommendation for you", Item.recommendation),
            ],
          ),
        ),
      ),
    );
  }
}
