import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/home/components/details_screen.dart';
import 'package:rent_house/ud_widgets/house_card.dart';

import '../../ud_widgets/search_field.dart';

// enum FilterOption { name, category, city, description }

// enum SortOption{ ascending, descending }

class SearchBarPage extends StatefulWidget {
  final String initialSearchText;
  final FilterOption? initialFilter;
  final SortOption? initialSort;
  const SearchBarPage({super.key, required this.initialSearchText, required this.initialFilter, required this.initialSort});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  //List of apartment names and other variables
  // static List<Property> apartment_list =[];

  //List that will filter from the apartment_list variable
  List<Item> display_list = List.from(Item.recommendation);
  TextEditingController searchController = TextEditingController();

  SortOption? _selectedSortOption = SortOption.descending;
  FilterOption? _selectedFilterOption = FilterOption.name;

  @override
  void initState() {
    super.initState();
    // Property p = Property('sddsdsdsds', 5, 'sdsds', 'https://i.pinimg.com/736x/4c/63/8d/4c638d0c9a64a46f0ab2a65607be4dfc.jpg');

    // apartment_list.add(p);

    // print(Item.recommendation);
    searchController.text = widget.initialSearchText;
    
    _selectedFilterOption = widget.initialFilter;
    _selectedSortOption = widget.initialSort;

    updateList(searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateList(String value) {
    // function that will filter the list
    setState(() {
      // if(_selectedFilterOption == Sort)
      if (_selectedFilterOption == FilterOption.name) {
        display_list = Item.recommendation
            .where((element) =>
                element.title!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      if (_selectedFilterOption == FilterOption.category) {
        display_list = Item.recommendation
            .where((element) =>
                element.category!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      if (_selectedFilterOption == FilterOption.city) {
        display_list = Item.recommendation
            .where((element) =>
                element.location!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      if (_selectedFilterOption == FilterOption.description) {
        display_list = Item.recommendation
            .where((element) =>
                element.description!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      if (_selectedSortOption == SortOption.descending) {
        display_list.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(
              "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
          DateTime dateTimeB = DateTime.parse(
              "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
          return dateTimeB.compareTo(dateTimeA);
        });
      }  
      
      
      if (_selectedSortOption == SortOption.ascending) {
        display_list.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(
              "${a.dateTime.split(" – ")[0]} ${a.dateTime.split(" – ")[1]}");
          DateTime dateTimeB = DateTime.parse(
              "${b.dateTime.split(" – ")[0]} ${b.dateTime.split(" – ")[1]}");
          return dateTimeA.compareTo(dateTimeB);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // apartment_list = [];

    // Property p = Property('sddsdsdsds', 5, 'apartment', 'https://i.pinimg.com/736x/4c/63/8d/4c638d0c9a64a46f0ab2a65607be4dfc.jpg');

    // apartment_list.add(p);

    //* sorting a properties based on their DateTime

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0.0,
      // ),
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        // title: Text(
        //   widget.category_name as String,
        //   style: kSubTextStyle,
        // ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: kPrimaryColor,
                ));
          },
        ),
        // actions: [
        //   if (currUser!.uid == widget.item.tenantID)
        //     Row(
        //       children: [
        //         IconButton(
        //             onPressed: () {
        //               // _showDialogBox(context);

        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => EditPosts(
        //                           item: widget.item,
        //                         )),
        //               );
        //             },
        //             icon: const Icon(Icons.edit)),
        //         IconButton(
        //             onPressed: () {
        //               _showDialogBox(
        //                   context,
        //                   'properties',
        //                   widget.item.location as String,
        //                   widget.item.dateTime.toString());
        //             },
        //             icon: const Icon(Icons.delete)),
        //       ],
        //     )
        // ],
      ),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search for",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // TextField(
            //   onChanged: (value) => updateList(value),
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.deepOrange,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       borderSide: BorderSide.none,
            //     ),
            //     hintText: "eg: Apartment Name",
            //     prefixIcon: const Icon(Icons.search),
            //     prefixIconColor: Colors.black,
            //   ),
            // ),

            Container(
              height: 60,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) => updateList(value),
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
                      // if (searchController.text.trim() != '') {
                      //   print(searchController.text.trim());

                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => SearchBarPage(),
                      //     ),
                      //   );
                      // }

                      // setState(() {});
                      // searchController.clear();
                    },
                  ),
                  
                  prefix: PopupMenuButton(
                    shadowColor: kBGColor,
                    color: kPrimaryColor,
                    icon: const Icon(Icons.sort),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Search by',
                              style: kSubTextStyle,
                            ),
                            RadioListTile<FilterOption>(
                              title: const Text('Name', style: kSmallTextStyle),
                              value: FilterOption.name,
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
                                'Property Type',
                                style: kSmallTextStyle,
                              ),
                              value: FilterOption.category,
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
                                'Location',
                                style: kSmallTextStyle,
                              ),
                              value: FilterOption.city,
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
                                'Description',
                                style: kSmallTextStyle,
                              ),
                              value: FilterOption.description,
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
                      PopupMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sort by',
                              // style: TextStyle(
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 16,
                              //   color: kLightColor
                              // ),
                              style: kSubTextStyle,
                            ),
                            RadioListTile<SortOption>(
                              title: const Text(
                                'Ascending',
                                style: kSmallTextStyle,
                              ),
                              value: SortOption.ascending,
                              groupValue: _selectedSortOption,
                              onChanged: (SortOption? value) {
                                setState(() {
                                  _selectedSortOption = value;
                                });
                                updateList(searchController.text.trim());

                                Navigator.pop(context);
                              },
                              activeColor: Colors.white,
                              selectedTileColor: Colors.transparent,
                              tileColor: kPrimaryColor,
                            ),
                            RadioListTile<SortOption>(
                              title: const Text(
                                'Descending',
                                style: kSmallTextStyle,
                              ),
                              value: SortOption.descending,
                              groupValue: _selectedSortOption,
                              onChanged: (SortOption? value) {
                                setState(() {
                                  _selectedSortOption = value;
                                });

                                updateList(searchController.text.trim());

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
                
                ),
                style: kSmallTextStyle,
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: display_list.length == 0
                  ? Center(
                      child: Text(
                        "No Result Found!",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          display_list[index],
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsSreen(display_list[index], () {
                                        setState(() {});
                                      })),
                            );
                          },
                          () {
                            setState(() {});
                          },
                          "",
                        );
                      },
                      //   itemBuilder: (context, index) => ListTile(
                      //     contentPadding: EdgeInsets.all(8.0),
                      //     title: Text(display_list[index].title!,
                      //     style: TextStyle(color: Colors.deepOrange,
                      //     fontWeight: FontWeight.bold,
                      //     ),
                      //     ),
                      //     subtitle: Text(
                      //       "${display_list[index].dateTime}",
                      //       style: TextStyle(
                      //         color: Colors.deepOrange,
                      //       ),
                      //     ),
                      //     trailing: Text(
                      //       "${display_list[index].price}",
                      //       style: TextStyle(
                      //         color: Colors.deepOrange,
                      //       ),
                      //     ),
                      //     leading: Image.network("${display_list[index].thumb_url}"),
                      //   ),
                      // ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
