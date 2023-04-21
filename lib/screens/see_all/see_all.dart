import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_house/constant.dart';

import '../../models/item_model.dart';
import '../home/components/details_screen.dart';

enum SortOption { name, date }

enum FilterOption { ascending, descending }

class MasonryGV extends StatefulWidget {
  final String type;
  const MasonryGV(this.type, {super.key});

  @override
  State<MasonryGV> createState() => _MasonryGVState();
}

class _MasonryGVState extends State<MasonryGV> {
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
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text(
          widget.type,
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
              icon: const Icon(Icons.sort),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sort by',
                        style: kSubTextStyle,
                      ),
                      RadioListTile<SortOption>(
                        title: const Text('Name', style: kSmallTextStyle),
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
                        title: const Text(
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
                      const Text(
                        'Filter by',
                        // style: TextStyle(
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 16,
                        //   color: kLightColor
                        // ),
                        style: kSubTextStyle,
                      ),
                      RadioListTile<FilterOption>(
                        title: const Text(
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
                        title: const Text(
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
      // body: MasonryGridView.builder(
      //   itemCount: 6,
      //   gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2),
      //   itemBuilder: (context, index) => Padding(
      //     padding: const EdgeInsets.all(2.0),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(12),
      //       child: Container(
      //         color: kPrimaryColor,
      //         height: 200,
      //       ),
      //     ),
      //   ),
      // ),
      body: (widget.type == "Nearby you")
          ? FutureBuilder<DocumentSnapshot?>(
              future: FirebaseFirestore.instance
                  .collection('properties')
                  .doc(userGlbData['location'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _items = [];

                  for (var k in propertyData.keys) {
                    _items.add(Item(
                      propertyData[k]['title'],
                      propertyData[k]['type'],
                      propertyData[k]['location'],
                      propertyData[k]['price'],
                      propertyData[k]['imageUrl'],
                      propertyData[k]['description'],
                      propertyData[k]['uid'],
                      k,
                      propertyData[k]['favorite'],
                      propertyData[k]['images'],
                    ));
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

                  return MasonryGridView.builder(
                    itemCount: _items.length,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsSreen(_items[index], () {
                                      setState(() {});
                                    })),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: index % 2 + 1,
                            child: Image(
                              image: NetworkImage(
                                  _items[index].thumb_url as String),
                              fit: BoxFit.cover,

                              // aspectRatio: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : FutureBuilder<QuerySnapshot?>(
              future: FirebaseFirestore.instance.collection('properties').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allPropData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  _items = [];

                  for (var i in allPropData) {
                    for (var j in i.keys) {
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

                      // print(i[j]['images']);
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

                  return MasonryGridView.builder(
                    itemCount: _items.length,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsSreen(_items[index], () {
                                      setState(() {});
                                    })),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: index % 2 + 1,
                            child: Image(
                              image: NetworkImage(
                                  _items[index].thumb_url as String),
                              fit: BoxFit.cover,

                              // aspectRatio: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }
}
