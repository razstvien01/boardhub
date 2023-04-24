import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icon.dart';
import 'package:rent_house/constant.dart';

class PostFunctions with ChangeNotifier {
  // Future addLike(BuildContext context, String postID, String subDocId) async{
  //   return FirebaseFirestore.instance.collection('properties').doc(
  //     postID
  //   ).collection('no_of_likes').doc(subDocId).set({
  //     'no_of_likes': FieldValue.increment(1),
  //     'username': Provider.of
  //   })
  // }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      //'username'
      //'userid'
      //useremail
      //time: Timetamp.now()
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: kBGColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: kLightColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kLightColor,
                  ),
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(docId)
                      .collection('comments')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.11,
                          width: MediaQuery.of(context).size.width,
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
                                          'https://i.pinimg.com/736x/ae/b1/43/aeb143366a35e1bcade5a6423b1d0aa2.jpg'),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'USERNAME',
                                              style: kSmallTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(LineIcon.arrowUp().icon,
                                              color: kPrimaryColor),
                                        ),
                                        Text(
                                          '0',
                                          style: kSmallTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete,
                                              color: kPrimaryColor),
                                        ),
                                        Text(
                                          '0',
                                          style: kSmallTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: kPrimaryColor,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        'Sample Comment afeafehunfiosnds',
                                        style: kSmallTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              Divider(
                                color: kLightColor.withOpacity(0.2),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                // FirebaseFirestore.instance.collection('posts').doc(docId).collection('comments').orderBy('time').snapshots(),
              ),
            ],
          ),
        );
      },
    );
  }
}
