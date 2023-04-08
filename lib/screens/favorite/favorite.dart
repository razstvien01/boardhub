import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/house_card.dart';

import '../../models/item_model.dart';
import '../home/components/details_screen.dart';

class Favorite extends StatefulWidget {
  List<Item> items;
  Favorite(this.items, {super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isEmpty = true;
  // List<Item> favItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      _isEmpty = userGlbData['bookmark'].isEmpty;
    } catch (e) {}

    if (!_isEmpty) {
      widget.items = [];

      Map favs = userGlbData['bookmark'];
      
      // print()

      for (var k in favs.keys) {
        Item newItem = Item(
          favs[k]['title'],
          favs[k]['type'],
          favs[k]['location'],
          favs[k]['price'],
          favs[k]['imageUrl'],
          favs[k]['description'],
          favs[k]['uid'],
          k,
          true,
          favs[k]['images']
        );
        
        newItem.favAddTime = favs[k]['favAddTime'];
        widget.items.add(newItem);
      }

      //* sorting a properties based on their DateTime

      // widget.items.sort((a, b) {
      //   DateTime dateTimeA = DateTime.parse(
      //       a.favAddTime.split(" – ")[0] + " " + a.favAddTime.split(" – ")[1]);
      //   DateTime dateTimeB = DateTime.parse(
      //       b.favAddTime.split(" – ")[0] + " " + b.favAddTime.split(" – ")[1]);

      //   int dateCompare = dateTimeB.compareTo(dateTimeA);
      //   if (dateCompare != 0) return dateCompare;

      //   int hourCompare = dateTimeB.hour.compareTo(dateTimeA.hour);
      //   if (hourCompare != 0) return hourCompare;

      //   int secondCompare = dateTimeB.second.compareTo(dateTimeA.second);
      //   return secondCompare;
      // });
      
      widget.items.sort((a, b) => DateTime.parse(b.dateTime.replaceAll(' – ', ' ')).compareTo(DateTime.parse(a.dateTime.replaceAll(' – ', ' '))));
    }

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Text(
          "Favorites",
          style: kHeadTextStyle,
        ),
      ),
      body: (_isEmpty)
          ? Center(
              child: Text(
                'No Properties Saved',
                style: kSubTextStyle,
              ),
            )
          : genFavList(),
    );
  }

  SingleChildScrollView genFavList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: widget.items.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ItemCard(
                widget.items[index],
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsSreen(favItems[index], () {
                              setState(() {});
                            })),
                  );
                },
                () {
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
