import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/category/category.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Widget categoryButton(IconData icon, String? text) {
    return Container(
      margin: const EdgeInsets.all(18.0),
      width: 80.0,
      height: 80.0,
      // decoration: BoxDecoration(
      //   border: Border.all(color: kAccentColor),
      // ),
      child: InkWell(
        onTap: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(text, () { setState(() {
                      
                    });}),
              ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: kPrimaryColor),
            Text(
              "$text",
              style: const TextStyle(
                fontSize: 14,
                color: kLightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.0,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          categoryButton(Icons.house_rounded, "House"),
          categoryButton(Icons.landscape, "Land"),
          categoryButton(Icons.apartment_rounded, "Apartment"),
          categoryButton(LineIcons.building, 'Condo'),
          categoryButton(Icons.villa_rounded, "Villa"),
          categoryButton(Icons.castle_rounded, "Castle"),
          
        ],
      ),
    );
  }
}
