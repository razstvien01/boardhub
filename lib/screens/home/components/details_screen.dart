import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:line_icons/line_icon.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/comment.dart';
import 'package:rent_house/models/item_model.dart';
import 'package:rent_house/screens/chat/chat_room.dart';
import 'package:rent_house/screens/home/components/edit_post.dart';
import 'package:rent_house/screens/home/components/view_images.dart';
import 'package:rent_house/screens/profile/profile.dart';

class DetailsSreen extends StatefulWidget {
  final Item item;
  final VoidCallback refresh;
  const DetailsSreen(this.item, this.refresh, {super.key});

  @override
  State<DetailsSreen> createState() => _DetailsSreenState();
}

class _DetailsSreenState extends State<DetailsSreen> {
  TextEditingController commentController = TextEditingController();
  final TextEditingController _editCommentController = TextEditingController();
  int indexToEdit = -1;
  Timer? _timer;
  bool isViewedComment = false;
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> commentData = {};

  final myWidgetKey = GlobalKey();

  final user = FirebaseFirestore.instance
      .collection("users")
      .doc("${FirebaseAuth.instance.currentUser?.uid}");

  final currUser = FirebaseAuth.instance.currentUser;

  late String commentId;

  Map<String, dynamic> data = {};

  List<UserComment> comments = [];

  @override
  void dispose() {
    _timer?.cancel;
    commentController.dispose();
    _editCommentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    commentId = '${widget.item.dateTime}|${widget.item.tenantID as String}';
    super.initState();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      500,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showDialogBox(BuildContext context, String collection, String docStr,
      String keyToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBGColor,
          title: Text(
              'Delete ${(collection == 'properties') ? 'Post' : 'Comment'}',
              style: kSubTextStyle),
          content: Text(
            'Are you sure you want to delete this ${(collection == 'properties') ? 'post?' : 'comment?'}',
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
                  msg: (collection == 'properties')
                      ? "Deleting post . . ."
                      : 'Deleting comment . . .',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kAccentColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                if (collection == 'properties') {
                  FirebaseFirestore.instance
                      .collection(collection)
                      .doc(docStr)
                      .update({
                    keyToDelete: FieldValue.delete(),
                  });

                  // Perform confirm action here
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
                if (collection == 'comments') {
                  FirebaseFirestore.instance.collection('comment');
                  FirebaseFirestore.instance
                      .collection('comments')
                      .doc(docStr)
                      .update({
                    keyToDelete: FieldValue.delete(),
                  });

                  // print(docStr);
                  Navigator.pop(context);
                }

                Fluttertoast.showToast(
                  msg: (collection == 'properties')
                      ? "Deleting post completed"
                      : 'Deleting comment completed',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: kAccentColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
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

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the object is still mounted before calling setState
        setState(() {
          // Update the state
        });
      }
    });

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
                      _showDialogBox(
                          context,
                          'properties',
                          widget.item.location as String,
                          widget.item.dateTime.toString());
                    },
                    icon: const Icon(Icons.delete)),
              ],
            )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
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
                            showCommentSheet(context, comments, data);

                            // _scrollToBottom();

                            // final RenderBox? myWidgetBox =
                            //     myWidgetKey.currentContext?.findRenderObject()
                            //         as RenderBox?;
                            // if (myWidgetBox != null) {
                            //   final position =
                            //       myWidgetBox.localToGlobal(Offset.zero);
                            //   _scrollController.animateTo(position.dy,
                            //       duration: Duration(seconds: 1),
                            //       curve: Curves.easeInOut);
                            // }
                          },
                          icon: Icon(
                            LineIcon.comments().icon,
                            color: kPrimaryColor,
                          )),
                    ],
                  ),
                ],
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

                    return GestureDetector(
                      onTap: () {
                        // print('CLICKED');\
                        final currUser = FirebaseAuth.instance.currentUser;
                        bool isCurrUserProfile =
                            (widget.item.tenantID == currUser!.uid);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                    isCurrUserProfile: isCurrUserProfile,
                                    uid: widget.item.tenantID as String,
                                  )),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                (data['profile_url'] == "" ||
                                        data['profile_url'] == null)
                                    ? default_profile_url
                                    : data['profile_url']),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            data['fullname'],
                            style: kSubTextStyle,
                          ),
                        ],
                      ),
                    );
                  }),

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
                widget.item.description as String,
                style: kSmallTextStyle,
              ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(item: widget.item),
                      ),
                    );
                  },
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

              // RepaintBoundary(
              //   key: myWidgetKey,
              //   child: ExpansionTile(
              //     collapsedIconColor: kPrimaryColor,
              //     iconColor: kPrimaryColor,
              //     title: Column(
              //       children: [
              //         Text((isViewedComment) ? 'Comments' : '',
              //             style: kPrimTextStyle),
              //       ],
              //     ),
              //     onExpansionChanged: (isExpanded) {
              //       if (isExpanded) {
              //         print('Expansion tile expanded!');
              //         isViewedComment = true;
              //       } else {
              //         print('Expansion tile collapsed!');
              //         isViewedComment = false;
              //       }

              //       setState(() {});
              //     },
              //     leading: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         SizedBox(height: 13),
              //         Text(
              //           (isViewedComment) ? '' : 'Tap to view comments',
              //           style: kSmallPrimTextStyle,
              //         ),
              //       ],
              //     ),
              //     // leading: Icon(Icons.comment, color: kPrimaryColor),

              //     // title: Text('Comments'),
              //     children: <Widget>[
              //       // Padding(
              //       //   padding: const EdgeInsets.all(16.0),
              //       //   child: Text(
              //       //     'Comment',
              //       //     style: kPrimTextStyle,
              //       //   ),
              //       // ),
              //       Container(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             TextField(
              //               textCapitalization: TextCapitalization.sentences,
              //               controller: commentController,
              //               maxLines: null,
              //               decoration: InputDecoration(
              //                 hintText: 'Type a comment',
              //                 hintStyle: kSmallPrimTextStyle,
              //                 border: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                     color: kPrimaryColor,
              //                   ),
              //                   borderRadius: BorderRadius.circular(32.0),
              //                 ),
              //                 enabledBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                     color: kPrimaryColor,
              //                   ),
              //                   borderRadius: BorderRadius.circular(32.0),
              //                 ),
              //                 focusedBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                     color: kPrimaryColor,
              //                   ),
              //                   borderRadius: BorderRadius.circular(32.0),
              //                 ),
              //                 suffixIcon: IconButton(
              //                   icon: Icon(Icons.send, color: kPrimaryColor),
              //                   onPressed: () async {
              //                     if (commentController.text.isNotEmpty) {
              //                       Fluttertoast.showToast(
              //                         msg: "Adding comment . . .",
              //                         toastLength: Toast.LENGTH_SHORT,
              //                         gravity: ToastGravity.BOTTOM,
              //                         timeInSecForIosWeb: 1,
              //                         backgroundColor: kAccentColor,
              //                         textColor: Colors.white,
              //                         fontSize: 16.0,
              //                       );
              //                       final currUser2 =
              //                           FirebaseAuth.instance.currentUser;

              //                       // currUser.

              //                       //* getting data without using FutureBuilder or StreamBuilder
              //                       final documentSnapshot =
              //                           await FirebaseFirestore.instance
              //                               .collection('users')
              //                               .doc(currUser2?.uid)
              //                               .get();

              //                       DateTime now = DateTime.now();
              //                       String formattedDate =
              //                           DateFormat('yyyy-MM-dd - HH:mm:ss')
              //                               .format(now);

              //                       if (documentSnapshot.exists) {
              //                         final data2 = documentSnapshot.data();

              //                         final comments = FirebaseFirestore
              //                             .instance
              //                             .collection('comments');

              //                         final newComment = {
              //                           '$formattedDate|${currUser2?.uid as String}|comment':
              //                               {
              //                             'name': data2?['fullname'],
              //                             'profile_url': data2?['profile_url'],
              //                             'comment':
              //                                 commentController.text.trim(),
              //                             'datePosted': formattedDate,
              //                             'uid': currUser2!.uid,
              //                             'likes': null,
              //                           }
              //                         };

              //                         DocumentReference docRef =
              //                             FirebaseFirestore.instance
              //                                 .collection('comments')
              //                                 .doc(commentId);

              //                         docRef.get().then((docSnapshot) {
              //                           if (docSnapshot.exists) {
              //                             comments
              //                                 .doc(commentId)
              //                                 .update(newComment)
              //                                 .then((value) {
              //                               // property data added successfully
              //                               print('comment added succesfully');
              //                             }).catchError((error) {
              //                               // an error occurred while adding the property data
              //                               print(
              //                                   'an error occurred while adding the property data');
              //                             });
              //                           } else {
              //                             comments
              //                                 .doc(commentId)
              //                                 .set(newComment)
              //                                 .then((value) {
              //                               // property data added successfully
              //                               print('comment added succesfully');
              //                             }).catchError((error) {
              //                               // an error occurred while adding the property data
              //                               print(
              //                                   'an error occurred while adding the property data');
              //                             });
              //                           }
              //                         });
              //                       }
              //                     }

              //                     setState(() {});
              //                     commentController.clear();

              //                     // print(DateTime.now().toString());
              //                   },
              //                 ),
              //               ),
              //               style: kSmallTextStyle,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCommentSheet(BuildContext context,
      List<UserComment> comments, Map<String, dynamic> data) {
    return showModalBottomSheet(
      backgroundColor: kBGColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: kBGColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Comments',
                      style: kPrimTextStyle,
                    ),
                  ),
                ),
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
                          hintText: 'Type a comment',
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

                                final currUser2 =
                                    FirebaseAuth.instance.currentUser;

                                // currUser.

                                //* getting data without using FutureBuilder or StreamBuilder
                                final documentSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(currUser2?.uid)
                                    .get();

                                DateTime now = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd - HH:mm:ss')
                                        .format(now);

                                if (documentSnapshot.exists) {
                                  final data2 = documentSnapshot.data();

                                  final comments = FirebaseFirestore.instance
                                      .collection('comments');

                                  final newComment = {
                                    '$formattedDate|${currUser2?.uid as String}|comment':
                                        {
                                      'name': data2?['fullname'],
                                      'profile_url': data2?['profile_url'],
                                      'comment': commentController.text.trim(),
                                      'datePosted': formattedDate,
                                      'uid': currUser2!.uid,
                                      'likes': null,
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
                                }
                              }

                              setState(() {});
                              commentController.clear();

                              // print(DateTime.now().toString());
                            },
                          ),
                        ),
                        style: kSmallTextStyle,
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('comments')
                        .doc(commentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print("PASSED A");
                        return const Center(
                          child: Text(
                            'No Comment Posts Yet',
                            style: kSubTextStyle,
                          ),
                        );
                      }

                      // if (snapshot.hasError) {
                      //   return Center(
                      //     child: Text(
                      //       'Error: ${snapshot.error}',
                      //       style: kSubTextStyle,
                      //     ),
                      //   );
                      // }
                      // if (!snapshot.hasData) {
                      //   return const Center(
                      //     child: Text(
                      //       'No Comment Posts Yet',
                      //       style: kSubTextStyle,
                      //     ),
                      //   );
                      // }

                      if (snapshot.hasData) {
                        commentId =
                            '${widget.item.dateTime}|${widget.item.tenantID as String}';
                        comments = [];

                        try {
                          data = snapshot.data!.data() as Map<String, dynamic>;
                          commentData = data;
                        } catch (e) {
                          print("PASSED B");
                          return const Center(
                            child: Text(
                              'No Comment Posts Yet',
                              style: kSubTextStyle,
                            ),
                          );
                        }
                      }

                      // if (data.keys.isEmpty) {
                      //   return Expanded(
                      //     flex: 3,
                      //     child: const Center(
                      //       child: Text(
                      //         'No Comment Posts Yet',
                      //         style: kSubTextStyle,
                      //       ),
                      //     ),
                      //   );
                      // }

                      for (var k in data.keys) {
                        List likes =
                            (data[k]['likes'] == null) ? [] : data[k]['likes'];

                        UserComment newComment = UserComment(
                          name: data[k]['name'],
                          comment: data[k]['comment'],
                          datePosted: data[k]['datePosted'],
                          profile_url: (data[k]['profile_url'] == null)
                              ? default_profile_url
                              : data[k]['profile_url'],
                          userId: data[k]['uid'],
                          likes: likes.length,
                        );

                        comments.add(newComment);
                      }

                      comments.sort((a, b) {
                        DateTime dateTimeA = DateTime.parse(
                            "${a.datePosted!.split(" - ")[0]} ${a.datePosted!.split(" - ")[1]}");
                        DateTime dateTimeB = DateTime.parse(
                            "${b.datePosted!.split(" - ")[0]} ${b.datePosted!.split(" - ")[1]}");
                        return dateTimeB.compareTo(dateTimeA);
                      });
                      return ListView.builder(
                        itemCount: comments.length,
                        physics: const NeverScrollableScrollPhysics(),
                        //physics:
                        //AlwaysScrollableScrollPhysics(), // make the comment ListView always scrollable
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String newFormattedDateTime = formatDateTime(
                              comments[index].datePosted as String);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // print('CLICKED');\
                                      final currUser =
                                          FirebaseAuth.instance.currentUser;
                                      bool isCurrUserProfile =
                                          (comments[index].userId ==
                                              currUser!.uid);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile(
                                                  isCurrUserProfile:
                                                      isCurrUserProfile,
                                                  uid: comments[index].userId
                                                      as String,
                                                )),
                                      );
                                    },
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('comments')
                                                .doc(commentId)
                                                .get()
                                                .then((doc) {
                                              if (doc.exists) {
                                                List<dynamic> likes =
                                                    doc['${comments[index].datePosted}|${comments[index].userId}|comment.likes'] ??
                                                        [];
                                                if (likes
                                                    .contains(currUser?.uid)) {
                                                  // Remove the user ID from the likes array
                                                  FirebaseFirestore.instance
                                                      .collection('comments')
                                                      .doc(commentId)
                                                      .update({
                                                    '${comments[index].datePosted}|${comments[index].userId}|comment.likes':
                                                        FieldValue.arrayRemove(
                                                            [currUser?.uid])
                                                  }).then((_) {
                                                    Fluttertoast.showToast(
                                                      msg: "Undo like comment",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          kAccentColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                    print(
                                                        'Removed currUser?.uid from array in Firestore');
                                                  }).catchError((error) => print(
                                                          'Failed to remove currUser?.uid: $error'));
                                                } else {
                                                  // Add the user ID to the likes array
                                                  FirebaseFirestore.instance
                                                      .collection('comments')
                                                      .doc(commentId)
                                                      .update({
                                                    '${comments[index].datePosted}|${comments[index].userId}|comment.likes':
                                                        FieldValue.arrayUnion(
                                                            [currUser?.uid])
                                                  }).then((_) {
                                                    print(
                                                        'Added currUser?.uid to array in Firestore');

                                                    Fluttertoast.showToast(
                                                      msg: "Like comment",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          kAccentColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  }).catchError((error) => print(
                                                          'Failed to add currUser?.uid: $error'));
                                                }
                                              } else {
                                                print(
                                                    'Document does not exist');
                                              }
                                            }).catchError((error) => print(
                                                    'Failed to get document: $error'));

                                            setState(() {});
                                          },
                                          icon: Icon(LineIcon.arrowUp().icon,
                                              color: kPrimaryColor),
                                        ),
                                        Text(
                                          comments[index].likes.toString(),
                                          style: kSmallTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (currUser!.uid == comments[index].userId)
                                    Row(
                                      children: [
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              indexToEdit = index;
                                              EditComment(
                                                  context,
                                                  comments,
                                                  comments[index].comment
                                                      as String);
                                            },
                                            icon: Icon(Icons.edit,
                                                color: kPrimaryColor),
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              // _showDialogBox(context, 'comments', '${comments[index].datePosted}' + '|' + '${comments[index].userId}|comment');

                                              _showDialogBox(
                                                  context,
                                                  'comments',
                                                  '${widget.item.dateTime}|${widget.item.tenantID as String}',
                                                  '${comments[index].datePosted}|${comments[index].userId}|comment');

                                              comments.remove(index);
                                            },
                                            icon: Icon(Icons.delete,
                                                color: kPrimaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  // const SizedBox(width: 8),
                                  if (currUser!.uid != comments[index].userId)
                                    IconButton(
                                      onPressed: () async {
                                        final commentReports = FirebaseFirestore
                                            .instance
                                            .collection('reports')
                                            .doc('comments');

                                        DateTime now = DateTime.now();
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd - HH:mm:ss')
                                                .format(now);

                                        final currUser2 =
                                            FirebaseAuth.instance.currentUser;

                                        //* getting data without using FutureBuilder or StreamBuilder
                                        final documentSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(currUser2?.uid)
                                                .get();

                                        if (documentSnapshot.exists) {
                                          data = documentSnapshot.data()!;

                                          final newReport = {
                                            'reportedBy': currUser2!.uid,
                                            'name': comments[index].name,
                                            'datePosted':
                                                comments[index].datePosted,
                                            'profile_url':
                                                comments[index].profile_url,
                                            'uid': comments[index].userId,
                                            'dateReported': formattedDate,
                                            'comment': comments[index].comment,
                                          };

                                          commentReports.update({
                                            '${comments[index].datePosted}|${comments[index].userId}|${currUser2.uid}|report':
                                                newReport,
                                          });

                                          Fluttertoast.showToast(
                                            msg:
                                                "This comment has been reported",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: kAccentColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.report,
                                          color: kPrimaryColor),
                                    ),
                                ],
                              ),
                              Text(
                                newFormattedDateTime,
                                style: kSmallPrimTextStyle,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> EditComment(
      BuildContext context, List<UserComment> comments, String prevComment) {
    // FocusScope.of(context).requestFocus(new FocusNode());
    _editCommentController.text = prevComment;
    return showModalBottomSheet(
      backgroundColor: kBGColor,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _editCommentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type a new comment',
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
                    ),
                    style: kSmallTextStyle,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel', style: kSmallPrimTextStyle),
                  onPressed: () {
                    _editCommentController.clear();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Update', style: kSmallPrimTextStyle),
                  onPressed: () {
                    print('pressed');
                    print(indexToEdit);
                    print(
                        '${comments[indexToEdit].datePosted}|${comments[indexToEdit].userId}|comment');
                    // Do something with the updated value

                    // FirebaseFirestore.instance.collection('comments').doc('${widget.item.dateTime}|${widget.item.tenantID as String}').update({
                    //   '${comments[indexToEdit].datePosted}|${comments[indexToEdit].userId}|comment': {
                    //     'comment': _editCommentController.text.trim(),
                    //   },
                    // });

                    FirebaseFirestore.instance
                        .collection('comments')
                        .doc('${widget.item.dateTime}|${widget.item.tenantID}')
                        .update({
                      '${comments[indexToEdit].datePosted}|${comments[indexToEdit].userId}|comment.comment':
                          _editCommentController.text.trim(),
                    });

                    _editCommentController.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDateTime(String datePosted) {
    DateTime serverDateTime;

    try {
      serverDateTime =
          DateFormat('yyyy-MM-dd - HH:mm:ss').parse(datePosted).toLocal();
    } catch (e) {
      print('Error parsing datetime: $e');
      return '';
    }

    // Get the current date and time in your local timezone
    final localDateTime = DateTime.now();

    // Calculate the difference between the adjusted server time and your local time
    final difference = localDateTime.difference(serverDateTime);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat.yMMMd().add_jm().format(serverDateTime);
    }
  }
}
