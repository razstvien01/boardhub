import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/house_card.dart';

import '../../models/item_model.dart';
import '../home/components/details_screen.dart';

enum SortOption { name, date, date_added }

enum FilterOption { ascending, descending }

class Favorite extends StatefulWidget {
  List<Item> items;
  Favorite(this.items, {super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isEmpty = true;
  Timer? _timer;

  SortOption? _selectedSortOption = SortOption.date_added;
  FilterOption? _selectedFilterOption = FilterOption.descending;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in the dispose() method
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
            favs[k]['images']);

        newItem.favAddTime = favs[k]['favAddTime'];
        widget.items.add(newItem);
      }

      //* sorting a properties based on their DateTime
      if (_selectedSortOption == SortOption.date) {
        if (_selectedFilterOption == FilterOption.descending) {
          widget.items.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(
                "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
            DateTime dateTimeB = DateTime.parse(
                "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
            return dateTimeB.compareTo(dateTimeA);
          });
        } else {
          widget.items.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(
                "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
            DateTime dateTimeB = DateTime.parse(
                "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else if (_selectedSortOption == SortOption.date_added) {
        if (_selectedFilterOption == FilterOption.descending) {
          widget.items.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(
                "${a.favAddTime.split(" – ")[0]} ${a.favAddTime.split(" – ")[1]}");
            DateTime dateTimeB = DateTime.parse(
                "${b.favAddTime.split(" – ")[0]} ${b.favAddTime.split(" – ")[1]}");
            return dateTimeB.compareTo(dateTimeA);
          });
        } else {
          widget.items.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(
                "${a.favAddTime.split(" – ")[0]} ${a.favAddTime.split(" – ")[1]}");
            DateTime dateTimeB = DateTime.parse(
                "${b.favAddTime.split(" – ")[0]} ${b.favAddTime.split(" – ")[1]}");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else if (_selectedSortOption == SortOption.name) {
        if (_selectedFilterOption == FilterOption.descending) {
          widget.items.sort((a, b) => b.title!.compareTo(a.title!));
        } else {
          widget.items.sort((a, b) => a.title!.compareTo(b.title!));
        }
      }
    }

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: const Text(
          "Favorites",
          style: kHeadTextStyle,
        ),
        actions: [
          // IconButton(
          //   onPressed: ,
          //   icon: Icon(
          //     Icons.sort,
          //     color: kPrimaryColor,
          //   ),
          // )
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
                          'Date Added',
                          style: kSmallTextStyle,
                        ),
                        value: SortOption.date_added,
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
      body: (_isEmpty)
          ? const Center(
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
                        builder: (context) =>
                            DetailsSreen(widget.items[index], () {
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
