// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/notif_view_profile.dart';
import 'package:rent_house/models/notification.dart';
import 'package:rent_house/screens/profile/profile.dart';

class NotificationUI extends StatefulWidget {
  //final String userName;
  //final String age;
  //final String email;
  const NotificationUI({
    Key? key,
  }) : super(
            key:
                key); //required this.userName, required this.age, required this.email}) : super(key: key);
  @override
  State<NotificationUI> createState() => _NotificationUIState();
}

class _NotificationUIState extends State<NotificationUI> {
  List<TheNotification> notifs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kBGColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text(
          "Notifications",
          style: kSubTextStyle,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('notifications').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is resolving, show a loading indicator.
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If the future throws an error, display the error message.
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            // print(snapshot.data!.data());
            final allNotifications = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            notifs = [];

            for (var i in allNotifications) {
              for (var j in i.keys) {
                if (i[j]['type'] == 'profile_viewed') {
                  List<String> parts = j.split("|");
                  // String result = parts[1].trim(); // "RN1xCD"
                  final currUser = FirebaseAuth.instance.currentUser;

                  if (parts[2].trim() == currUser!.uid) {
                    TheNotification notif = ViewProfileNotif(
                      key: j,
                      note: i[j]['note'],
                      uid: i[j]['uid'],
                      type: i[j]['type'],
                      dateViewed: i[j]['dateViewed'],
                      dateTime: i[j]['dateCreated'],
                    );

                    notifs.add(notif);
                  }
                }
              }
            }

            notifs.sort((a, b) =>
                DateTime.parse(b.dateTime!.replaceAll(' - ', ' ')).compareTo(
                    DateTime.parse(a.dateTime!.replaceAll(' - ', ' '))));

            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: notifs.length,
              itemBuilder: (context, index) {
//                 DocumentReference docRef = FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(notifs[index].uid);
// DocumentSnapshot snapshot = await docRef.get();
//                     print(docRef['']);

                return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(notifs[index].uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the future is resolving, show a loading indicator.
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // If the future throws an error, display the error message.
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      Map<String, dynamic> otherUserdata = snapshot.data!.data()
                          as Map<String,
                              dynamic>; // Get the data from the snapshot
                      return ListTile(
                        tileColor: kAccentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (otherUserdata['profile_url'] == null)
                                  ? default_profile_url
                                  : otherUserdata['profile_url']),
                        ),
                        title: Text(notifs[index].note as String,
                            style: kMidItalicTextStyle),
                        subtitle: Text(
                          notifs[index].dateTime as String,
                          style: kSmallTextStyle,
                        ),
                        onTap: () {
                          if (notifs[index].type == 'profile_viewed') {
                            print('passed');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                        isCurrUserProfile: false,
                                        uid: notifs[index].uid as String,
                                      )),
                            );
                          }
                        },
                        enabled: true,
                        trailing: IconButton(
                            onPressed: () {
                              // if (notifs[index].type == 'profile_viewed') {
                              //   print('passed');
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Profile(
                              //               isCurrUserProfile: false,
                              //               uid: notifs[index].uid as String,
                              //             )),
                              //   );
                              // }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: kPrimaryColor,
                            )),
                      );
                    });
              },
              separatorBuilder: ((context, index) {
                return Divider();
              }),
            );
          }),
    );
  }

  /*Widget message(int index){
    return Container(
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.clip,
        text: TextSpan(
          text: 'Rancis has messagd you',style: TextStyle(fontStyle: FontStyle.italic),
        )),
    );
  }*/
}
