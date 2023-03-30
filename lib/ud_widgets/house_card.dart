import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';

class ItemCard extends StatefulWidget {
  Item item;
  VoidCallback onTap;

  ItemCard(this.item, this.onTap, {super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        // color: Color
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all()
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  // color: Colors.grey.
                  image: DecorationImage(
                    image: NetworkImage(widget.item.thumb_url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.item.category!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.item.title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: kLightColor,
                  overflow: TextOverflow.ellipsis,
                ),
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
                      print("Fav button pressed");
                      setState(() {
                        widget.item.favorite = !(widget.item.favorite!);
                      });

                      //userGlbData['bookmark']
                      final user = FirebaseFirestore.instance
                          .collection("users")
                          .doc("${FirebaseAuth.instance.currentUser?.uid}");
                      
                      // if (userGlbData['bookmark'][widget.item.dateTime] ==
                      //     null) {
                      //   // userGlbData['bookmark'][widget.item.dateTime] = {
                      //   //   'description': widget.item.description,
                      //   //   'imageUrl': widget.item.thumb_url,
                      //   //   'location': widget.item.location,
                      //   //   'price': widget.item.price,
                      //   //   'type': widget.item.category,
                      //   //   'title': widget.item.title,
                      //   //   'uid': widget.item.tenantID
                      //   // };
                      //   print(userGlbData);
                      // }
                      // if(favItems[widget.item.dateTime] == null)
                      // {

                      //   favItems[widget.item.dateTime] =
                      //   {
                      //     'description': widget.item.description,
                      //     'imageUrl': widget.item.thumb_url,
                      //     'location': widget.item.location,
                      //     'price': widget.item.price,
                      //     'type': widget.item.category,
                      //     'title': widget.item.title,
                      //     'uid': widget.item.tenantID
                      //   };
                      // }
                      // else{
                      //   favItems.remove(widget.item.dateTime);
                      // }
                      
                      // else
                      // {
                      //   userGlbData['bookmark'].remove(widget.item.dateTime);
                      // }
                      
                      if(userGlbData['bookmark'][widget.item.dateTime] == null)
                      {
                        print("Pass here");
                        userGlbData['bookmark'][widget.item.dateTime] = {
                          'description': widget.item.description,
                          'imageUrl': widget.item.location,
                          'location': widget.item.price,
                          'price': widget.item.price,
                          'type': widget.item.category,
                          'title': widget.item.title,
                          'uid': widget.item.tenantID,
                        };
                      }
                      else{
                        userGlbData['bookmark'].remove(widget.item.dateTime);
                      }
                      
                      print(userGlbData['bookmark']);
                      

                      user.update({
                        'bookmark': userGlbData['bookmark'],
                      });
                    },
                    icon: Icon((!(widget.item.favorite!))
                        ? Icons.favorite_border_outlined
                        : Icons.favorite_outlined),
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
