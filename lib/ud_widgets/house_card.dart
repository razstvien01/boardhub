import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';

class ItemCard extends StatefulWidget {
  Item item;
  VoidCallback onTap;
  VoidCallback refresh;
  String screen;

  ItemCard(this.item, this.onTap, this.refresh, this.screen, {super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var key in userGlbData['bookmark'].keys) {
      if (key == widget.item.dateTime) {
        setState(() {
          widget.item.favorite = true;
        });
      }
    }

    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        // color: Color
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all()
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
              if (widget.screen != "category")
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
                style: const TextStyle(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      overflow: TextOverflow.ellipsis,
                      color: kLightColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.item.favorite = !(widget.item.favorite!);

                        print(widget.item.favorite);
                      });
                      if (userGlbData['bookmark'][widget.item.dateTime] ==
                          null) {
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
                        userGlbData['bookmark'][widget.item.dateTime] = {
                          'description': widget.item.description,
                          'imageUrl': widget.item.thumb_url,
                          'location': widget.item.location,
                          'price': widget.item.price,
                          'type': widget.item.category,
                          'title': widget.item.title,
                          'uid': widget.item.tenantID,
                          'favAddTime': formattedDate,
                          'images': widget.item.images,
                        };
                      } else {
                        setState(() {
                          userGlbData['bookmark'].remove(widget.item.dateTime);
                        });
                      }

                      user.update({
                        'bookmark': userGlbData['bookmark'],
                      });

                      widget.refresh();
                      setState(() {});
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
