import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/home/components/details_screen.dart';
import 'package:rent_house/screens/test/multiple_images.dart';
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
  Widget getPropertiesInfo(context, snapshot) {
    if (snapshot.hasData) {
      
      try {
        propertyData = snapshot.data!.data() as Map<String, dynamic>;
      } catch (e) {
        return Container(color: kBGColor,);
      }
      

      widget.items = [];

      for (var k in propertyData.keys) {
        widget.items.add(Item(
          propertyData[k]['title'],
          propertyData[k]['type'],
          propertyData[k]['location'],
          propertyData[k]['price'],
          propertyData[k]['imageUrl'],
          propertyData[k]['description'],
          propertyData[k]['uid'],
          k,
          propertyData[k]['favorite'],
          "",
        ));
      }

      //* sorting a properties based on their DateTime
      // widget.items.sort((a, b) => DateTime.parse(b.dateTime.split(" – ")[0])
      //     .compareTo(DateTime.parse(a.dateTime.split(" – ")[0])));

      widget.items.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(
            a.dateTime.split(" – ")[0] + " " + a.dateTime.split(" – ")[1]);
        DateTime dateTimeB = DateTime.parse(
            b.dateTime.split(" – ")[0] + " " + b.dateTime.split(" – ")[1]);
        return dateTimeB.compareTo(dateTimeA);
      });

      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title!,
                  style: kSubTextStyle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Test(),
                      ),
                    );
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 12.0),

            Container(
              height: 300.0,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                //itemCount: data.keys.length,
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
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget getAllPropertiesInfo(context, snapshot) {
    if (snapshot.hasData) {
      final allPropData = snapshot.data!.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      widget.items = [];

      for (var i in allPropData) {
        for (var j in i.keys) {
          widget.items.add(Item(
            i[j]['title'],
            i[j]['type'],
            i[j]['location'],
            i[j]['price'],
            i[j]['imageUrl'],
            i[j]['description'],
            i[j]['uid'],
            j,
            i[j]['favorite'],
            "",
          ));
        }
      }

      //* sorting a properties based on their DateTime
      // widget.items.sort((a, b) => DateTime.parse(b.dateTime.split(" – ")[0])
      //     .compareTo(DateTime.parse(a.dateTime.split(" – ")[0])));

      widget.items.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(
            a.dateTime.split(" – ")[0] + " " + a.dateTime.split(" – ")[1]);
        DateTime dateTimeB = DateTime.parse(
            b.dateTime.split(" – ")[0] + " " + b.dateTime.split(" – ")[1]);
        return dateTimeB.compareTo(dateTimeA);
      });

      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title!,
                  style: kSubTextStyle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Test(),
                      ),
                    );
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 12.0),

            Container(
              height: 300.0,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                //itemCount: data.keys.length,
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
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.title == "Nearby you")
        ? FutureBuilder<DocumentSnapshot?>(
            future: FirebaseFirestore.instance
                .collection('properties')
                .doc(userGlbData['location'])
                .get(),
            builder: getPropertiesInfo,
          )
        : FutureBuilder<QuerySnapshot?>(
            future: FirebaseFirestore.instance.collection('properties').get(),
            builder: getAllPropertiesInfo,
          );
  }
}
