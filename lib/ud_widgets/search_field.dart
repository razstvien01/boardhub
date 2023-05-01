import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/search/search_bar.dart';

// enum FilterOption { name, category, city, description }

// enum SortOption{ ascending, descending }


enum FilterOption { name, category, city, description }

enum SortOption{ ascending, descending }

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController searchController = TextEditingController();

  SortOption? _selectedSortOption = SortOption.descending;
  FilterOption? _selectedFilterOption = FilterOption.name;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: 500,
    //   child: TextField(
    //     cursorColor: kPrimaryColor,
    //       decoration: InputDecoration(

    //     border: InputBorder.none,
    //     filled: true,
    //     fillColor: kAccentColor,
    //     hintText: "Search. . .",
    //     prefixIcon: Icon(
    //       Icons.search,
    //       color: kPrimaryColor,
    //     ),
    //     suffixIcon: Icon(
    //       Icons.filter_alt_outlined,
    //       color: kPrimaryColor,
    //     ),
    //   )),
    // );
    return Container(
      height: 60,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
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
              if (searchController.text.trim() != '') {
                print('Searching ' + searchController.text.trim());
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchBarPage(
                        initialSearchText: searchController.text.trim(),
                        initialFilter: _selectedFilterOption,
                        initialSort: _selectedSortOption),
                  ),
                );
              }

              setState(() {});
              searchController.clear();
            },
          ),
          prefix: PopupMenuButton(
            shadowColor: kBGColor,
            color: kPrimaryColor,
            icon: Icon(Icons.sort, color: kPrimaryColor),
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
                        // updateList(searchController.text.trim());
          
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
          
                        // updateList(searchController.text.trim());
          
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
    );
  }
}
