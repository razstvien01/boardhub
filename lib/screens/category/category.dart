import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

import '../../models/item_model.dart';
import '../../ud_widgets/house_card.dart';
import '../home/components/details_screen.dart';

enum SortOption { name, date }
enum FilterOption { ascending, descending }

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
  SortOption? _selectedSortOption = SortOption.date;
  FilterOption? _selectedFilterOption = FilterOption.descending;

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
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: PopupMenuButton(
              shadowColor: kBGColor,
              color: kPrimaryColor,
              icon: Icon(Icons.sort),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sort by',
                        style: kSubTextStyle,
                      ),
                      RadioListTile<SortOption>(
                        title: Text('Name', style: kSmallTextStyle),
                        value: SortOption.name,
                        groupValue: _selectedSortOption,
                        onChanged: (SortOption? value) {
                          setState(() {
                            _selectedSortOption = value;
                          });

                          Navigator.pop(context);
                        },
                        activeColor: Colors.white,
                        selectedTileColor: Colors.transparent,
                        tileColor: kPrimaryColor,
                      ),
                      RadioListTile<SortOption>(
                        title: Text(
                          'Date',
                          style: kSmallTextStyle,
                        ),
                        value: SortOption.date,
                        groupValue: _selectedSortOption,
                        onChanged: (SortOption? value) {
                          setState(() {
                            _selectedSortOption = value;
                          });

                          Navigator.pop(context);
                        },
                        activeColor: Colors.white,
                        selectedTileColor: Colors.transparent,
                        tileColor: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by',
                        // style: TextStyle(
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 16,
                        //   color: kLightColor
                        // ),
                        style: kSubTextStyle,
                      ),
                      RadioListTile<FilterOption>(
                        title: Text(
                          'Ascending',
                          style: kSmallTextStyle,
                        ),
                        value: FilterOption.ascending,
                        groupValue: _selectedFilterOption,
                        onChanged: (FilterOption? value) {
                          setState(() {
                            _selectedFilterOption = value;
                          });

                          Navigator.pop(context);
                        },
                        activeColor: Colors.white,
                        selectedTileColor: Colors.transparent,
                        tileColor: kPrimaryColor,
                      ),
                      RadioListTile<FilterOption>(
                        title: Text(
                          'Descending',
                          style: kSmallTextStyle,
                        ),
                        value: FilterOption.descending,
                        groupValue: _selectedFilterOption,
                        onChanged: (FilterOption? value) {
                          setState(() {
                            _selectedFilterOption = value;
                          });

                          Navigator.pop(context);
                        },
                        activeColor: Colors.white,
                        selectedTileColor: Colors.transparent,
                        tileColor: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
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

            //* sorting a properties based on their DateTime
            if (_selectedSortOption == SortOption.date) {
              if (_selectedFilterOption == FilterOption.descending) {
                _items.sort((a, b) {
                  DateTime dateTimeA = DateTime.parse(
                      "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
                  DateTime dateTimeB = DateTime.parse(
                      "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
                  return dateTimeB.compareTo(dateTimeA);
                });
              } else {
                _items.sort((a, b) {
                  DateTime dateTimeA = DateTime.parse(
                      "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
                  DateTime dateTimeB = DateTime.parse(
                      "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
                  return dateTimeA.compareTo(dateTimeB);
                });
              }
            } else if (_selectedSortOption == SortOption.name) {
              if (_selectedFilterOption == FilterOption.descending) {
                _items.sort((a, b) => b.title!.compareTo(a.title!));
              } else {
                _items.sort((a, b) => a.title!.compareTo(b.title!));
              }
            }
            
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
