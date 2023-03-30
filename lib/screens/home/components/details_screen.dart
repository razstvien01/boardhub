import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';

class DetailsSreen extends StatefulWidget {
  Item item;

  DetailsSreen(this.item, {super.key});

  @override
  State<DetailsSreen> createState() => _DetailsSreenState();
}

class _DetailsSreenState extends State<DetailsSreen> {
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
          widget.item.title!,
          style: kSubTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.item.thumb_url!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.item.category!,
                  style: kPrimTextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.item.title!,
                  style: kSubTextStyle,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    Text(
                      widget.item.location!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: kAccentColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.item.price}\$ / Month",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        overflow: TextOverflow.ellipsis,
                        color: kLightColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print("Add favorite") ;                     
                        
                        },
                      icon: Icon(Icons.favorite_border_outlined),
                      color: kPrimaryColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'posted by ',
                      style: kSmallTextStyle,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc('${widget.item.tenantID}')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();

                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Text(
                            data['fullname'],
                            style: kSubTextStyle,
                          );
                        }),
                  ],
                ),

                SizedBox(
                  height: 8.0,
                ),

                Text(
                  widget.item.description!,
                  style: kSmallTextStyle,
                ),
                // Expanded(child: Container()),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fillColor: kPrimaryColor,
                    child: Text(
                      "Contact Tenant",
                      style: kLightTextStyle,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
