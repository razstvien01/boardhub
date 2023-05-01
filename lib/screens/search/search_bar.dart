
import 'package:flutter/material.dart';
import 'package:rent_house/models/property.dart';

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({super.key});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {

  //List of apartment names and other variables
  static List<Property> apartment_list =[];

  //List that will filter from the apartment_list variable
  List<Property> display_list = List.from(apartment_list);


  void updateList(String value){
    // function that will filter the list
    setState(() {
      display_list = apartment_list.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search for", 
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0,),
            TextField(
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.deepOrange,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "eg: Apartment Name",
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: display_list.length == 0 ?Center(
                child: Text(
                  "No Result Found!" ,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    ),
                 ),
                ) :ListView.builder(
                itemCount: apartment_list.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(display_list[index].name!,
                  style: TextStyle(color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text(
                    "${display_list[index].dates}",
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                  trailing: Text(
                    "${display_list[index].likes}",
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                  leading: Image.network("${display_list[index].thumbnail}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}