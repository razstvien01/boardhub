import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/house_card.dart';

import '../../models/item_model.dart';
import '../home/components/details_screen.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

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
    } catch (e) {

    }

    if (!_isEmpty) {
      favItems = [];

      Map favs = userGlbData['bookmark'];

      for (var k in favs.keys) {

        favItems.add(
          Item(
            favs[k]['title'],
            favs[k]['type'],
            favs[k]['location'],
            favs[k]['price'],
            favs[k]['imageUrl'],
            favs[k]['description'],
            favs[k]['uid'],
            k,
            true,
          ),
        );
      }
      
      
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
            itemCount: favItems.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ItemCard(
                favItems[index],
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsSreen(favItems[index], () {
                              setState(() {});
                            })),
                  );
                },
                () { setState(() {
                  
                });},
              );
            },
          ),
        ],
      ),
    );
  }
}
