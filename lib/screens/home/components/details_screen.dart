import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/home/components/view_images.dart';

class DetailsSreen extends StatefulWidget {
  Item item;
  VoidCallback refresh;
  DetailsSreen(this.item, this.refresh, {super.key});

  @override
  State<DetailsSreen> createState() => _DetailsSreenState();
}

class _DetailsSreenState extends State<DetailsSreen> {
  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  @override
  Widget build(BuildContext context) {
    for (var key in userGlbData['bookmark'].keys) {
      if (key == widget.item.dateTime) {
        setState(() {
          widget.item.favorite = true;
        });
      }
    }

    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        // title: Text(
        //   widget.item.title!,
        //   style: kSubTextStyle,
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewImages(images: widget.item.images)),
                    );
                  },
                  child: Stack(
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
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Transform.translate(
                            offset: Offset(0, 0),
                            child: Container(
                                        width: double.infinity, // Stretch container to cover entire width
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                'View More',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                 textAlign: TextAlign.center, // Center the text horizontally
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    // child: Container(
                    //   width: double.infinity,
                    //   height: 300.0,
                    //   decoration: BoxDecoration(
                    //     color: kAccentColor,
                    //     borderRadius: BorderRadius.circular(16.0),
                    //     image: DecorationImage(
                    //       image: NetworkImage(widget.item.thumb_url!),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
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
                        setState(() {
                          widget.item.favorite = !(widget.item.favorite!);
                        });
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
                        if (userGlbData['bookmark'][widget.item.dateTime] ==
                            null) {
                          userGlbData['bookmark'][widget.item.dateTime] = {
                            'description': widget.item.description,
                            'imageUrl': widget.item.thumb_url,
                            'location': widget.item.location,
                            'price': widget.item.price,
                            'type': widget.item.category,
                            'title': widget.item.title,
                            'uid': widget.item.tenantID,
                            'favAddTime': formattedDate,
                            'images': widget.item.images
                          };
                        } else {
                          userGlbData['bookmark'].remove(widget.item.dateTime);
                        }

                        //print(userGlbData['bookmark']);

                        user.update({
                          'bookmark': userGlbData['bookmark'],
                        });

                        widget.refresh();
                      },
                      icon: Icon((!(widget.item.favorite!))
                          ? Icons.favorite_border_outlined
                          : Icons.favorite_outlined),
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
                  widget.item.dateTime,
                  style: kSmallTextStyle,
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
