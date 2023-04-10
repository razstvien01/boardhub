import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

import '../../models/item_model.dart';
import '../../ud_widgets/house_card.dart';
import '../home/components/details_screen.dart';

class CategoryPage extends StatefulWidget {
  String? category_name;
  VoidCallback refresh;
  CategoryPage(this.category_name, this.refresh, {super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Item> _items = [];
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the object is still mounted before calling setState
        setState(() {
          // Update the state
        });
      }
    });

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text(
          widget.category_name as String,
          style: kSubTextStyle,
        ),
      ),
      body: FutureBuilder<QuerySnapshot?>(
        future: FirebaseFirestore.instance.collection('properties').get(),
        builder: ((context, s) {
          if (s.hasData) {
            final allPropData = s.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            _items = [];

            print(allPropData);

            for (var i in allPropData) {
              for (var j in i.keys) {
                if (widget.category_name == i[j]['type']) {
                  _items.add(Item(
                    i[j]['title'],
                    i[j]['type'],
                    i[j]['location'],
                    i[j]['price'],
                    i[j]['imageUrl'],
                    i[j]['description'],
                    i[j]['uid'],
                    j,
                    i[j]['favorite'],
                    i[j]['images'],
                  ));
                }
              }
            }

            _items.sort((a, b) {
              DateTime dateTimeA = DateTime.parse(
                  "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
              DateTime dateTimeB = DateTime.parse(
                  "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
              return dateTimeB.compareTo(dateTimeA);
            });
            // return profile(context);
            // return Text("Have data", style: kSubTextStyle);
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: _items.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemCard(
                        _items[index],
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsSreen(_items[index], () {
                                      setState(() {});
                                    })),
                          );
                        },
                        widget.refresh,
                        "category",
                      );
                      
                    },
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
