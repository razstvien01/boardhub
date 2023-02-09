import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/home/components/details_screen.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';
import 'package:rent_house/ud_widgets/house_card.dart';

class SuggestionList extends StatefulWidget {
  String? title;
  List<Item> items;

  SuggestionList(this.title, this.items, {super.key});

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                // style: TextStyle(
                //   fontSize: 16,
                //   color: kLightColor,
                // ),
                style: kSubTextStyle,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See All",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          // SizedBox(height: 12.0),

          Container(
            height: 340.0,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  widget.items[index],
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsSreen(widget.items[index])
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
