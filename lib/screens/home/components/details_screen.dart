import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/comment.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/home/components/edit_post.dart';
import 'package:rent_house/screens/home/components/view_images.dart';

class DetailsSreen extends StatefulWidget {
  final Item item;
  final VoidCallback refresh;
  const DetailsSreen(this.item, this.refresh, {super.key});

  @override
  State<DetailsSreen> createState() => _DetailsSreenState();
}

class _DetailsSreenState extends State<DetailsSreen> {
  TextEditingController commentController = TextEditingController();

  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  final currUser = FirebaseAuth.instance.currentUser;

  late String commentId;

  Map<String, dynamic> data = {};

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBGColor,
          title: const Text('Delete Post', style: kSubTextStyle),
          content: const Text(
            'Are you sure you want to delete this post?',
            style: kSmallTextStyle,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: kSmallPrimTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Deleting post . . .",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kAccentColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                FirebaseFirestore.instance
                    .collection('properties')
                    .doc('${widget.item.location}')
                    .update({
                  widget.item.dateTime.toString(): FieldValue.delete(),
                });

                Fluttertoast.showToast(
                  msg: "Deleting completed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kAccentColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                Navigator.of(context).popUntil((route) => route.isFirst);
                // Perform confirm action here
              },
              child: Text('Confirm', style: kSmallPrimTextStyle),
            ),
          ],
        );
      },
    );
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

    return Scaffold(
      backgroundColor: kBGColor,
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: kPrimaryColor,
                ));
          },
        ),
        actions: [
          if (currUser!.uid == widget.item.tenantID)
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      // _showDialogBox(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPosts(
                                  item: widget.item,
                                )),
                      );
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      _showDialogBox(context);
                    },
                    icon: const Icon(Icons.delete)),
              ],
            )
        ],
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
                            offset: const Offset(0, 0),
                            child: Container(
                              width: double
                                  .infinity, // Stretch container to cover entire width
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: const Text(
                                'View More',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign
                                    .center, // Center the text horizontally
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.item.category!,
                  style: kPrimTextStyle,
                ),
                const SizedBox(height: 8.0),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        overflow: TextOverflow.ellipsis,
                        color: kLightColor,
                      ),
                    ),
                    Row(
                      children: [
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
                              userGlbData['bookmark']
                                  .remove(widget.item.dateTime);
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
                        IconButton(
                            onPressed: () {
                              // showComments(context);
                              showCommentsSheet(context);
                            },
                            icon: Icon(
                              LineIcon.comments().icon,
                              color: kPrimaryColor,
                            )),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'posted by ',
                      style: kSmallTextStyle,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc('${widget.item.tenantID}')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Text(
                            data['fullname'],
                            style: kSubTextStyle,
                          );
                        }),
                  ],
                ),

                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  widget.item.dateTime,
                  style: kSmallTextStyle,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  widget.item.description!,
                  style: kSmallTextStyle,
                ),
                // Expanded(child: Container()),
                const SizedBox(
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
                    child: const Text(
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

  showCommentsSheet(BuildContext context) {
    commentId = '${widget.item.dateTime}|${widget.item.tenantID as String}';

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: kBGColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: kLightColor,
                  ),
                ),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: kLightColor,
                    // ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Comments',
                      style: kPrimTextStyle,
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comments')
                        .doc(commentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(
                      //     child: CircularProgressIndicator(),
                      //   );
                      // }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: kSubTextStyle,
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'No Comment Posts Yet',
                            style: kSubTextStyle,
                          ),
                        );
                      }

                      List<UserComment> comments = [];

                      data = snapshot.data!.data()! as Map<String, dynamic>;

                      for (var k in data.keys) {
                        UserComment newComment = UserComment(
                          name: data[k]['name'],
                          comment: data[k]['comment'],
                          datePosted: data[k]['datePosted'],
                          profile_url: data[k]['profile_url'],
                        );

                        comments.add(newComment);
                      }

                      comments.sort((a, b) {
                        DateTime dateTimeA = DateTime.parse(
                            "${a.datePosted!.split(" – ")[0]} ${a.datePosted!.split(" – ")[1]}");
                        DateTime dateTimeB = DateTime.parse(
                            "${b.datePosted!.split(" – ")[0]} ${b.datePosted!.split(" – ")[1]}");
                        return dateTimeB.compareTo(dateTimeA);
                      });


                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            String id = data.keys.elementAt(index);

                            // commentsList = comments.entries.toList();

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: kPrimaryColor,
                                            radius: 15.0,
                                            backgroundImage: NetworkImage(
                                              comments[index].profile_url as String,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            // data['name'],
                                            comments[index].name as String,
                                            style: kSmallTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    LineIcon.arrowUp().icon,
                                                    color: kPrimaryColor),
                                              ),
                                              const Text(
                                                '0',
                                                style: kSmallTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.delete,
                                                    color: kPrimaryColor),
                                              ),
                                              const Text(
                                                '0',
                                                style: kSmallTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.report,
                                              color: kPrimaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: kPrimaryColor,
                                          ),
                                          onPressed: () {
                                            print("Pressed");
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            comments[index].comment as String,
                                            style: kSmallTextStyle,
                                            // overflow:
                                            //     TextOverflow.ellipsis,
                                            maxLines: null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: kLightColor.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: commentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
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
                            icon: Icon(Icons.send, color: kPrimaryColor),
                            onPressed: () async {
                              if (commentController.text.isNotEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Adding comment . . .",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kAccentColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                final currUser =
                                    FirebaseAuth.instance.currentUser;

                                // currUser.

                                //* getting data without using FutureBuilder or StreamBuilder
                                final documentSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(currUser?.uid)
                                    .get();

                                DateTime now = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd – kk:mm:ss')
                                        .format(now);

                                if (documentSnapshot.exists) {
                                  final data = documentSnapshot.data();

                                  final comments = FirebaseFirestore.instance
                                      .collection('comments');

                                  final newComment = {
                                    '$formattedDate|${currUser?.uid as String}|comment':
                                        {
                                      'name': data?['fullname'],
                                      'profile_url': data?['profile_url'],
                                      'comment': commentController.text.trim(),
                                      'datePosted': formattedDate,
                                    }
                                  };

                                  DocumentReference docRef = FirebaseFirestore
                                      .instance
                                      .collection('comments')
                                      .doc(commentId);

                                  docRef.get().then((docSnapshot) {
                                    if (docSnapshot.exists) {
                                      comments
                                          .doc(commentId)
                                          .update(newComment)
                                          .then((value) {
                                        // property data added successfully
                                        print('comment added succesfully');
                                      }).catchError((error) {
                                        // an error occurred while adding the property data
                                        print(
                                            'an error occurred while adding the property data');
                                      });
                                    } else {
                                      comments
                                          .doc(commentId)
                                          .set(newComment)
                                          .then((value) {
                                        // property data added successfully
                                        print('comment added succesfully');
                                      }).catchError((error) {
                                        // an error occurred while adding the property data
                                        print(
                                            'an error occurred while adding the property data');
                                      });
                                    }
                                  });

                                  // comments
                                  //     .doc(commentId)
                                  //     .set(newComment)
                                  //     .then((value) {
                                  //   // property data added successfully
                                  //   print('comment added succesfully');
                                  // }).catchError((error) {
                                  //   // an error occurred while adding the property data
                                  //   print('an error occurred while adding the property data');
                                  // });
                                }
                                setState(() {});
                              }
                              // '${widget.item.dateTime}|${widget.item.tenantID as String}'
                              // FirebaseFirestore.instance
                              // widget.item.thumb_url
                              // commentController
                              //widget.item.tenantID;

                              // Send message logic here
                              commentController.clear();
                            },
                          ),
                        ),
                        style: kSmallTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
