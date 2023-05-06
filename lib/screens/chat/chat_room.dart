import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/chatbox.dart';
import 'package:rent_house/screens/profile/profile.dart';

class ChatRoom extends StatefulWidget {
  // final Message messages;
  // final Item item;
  final String chatID;
  // final String tenantID;
  late String title;
  ChatRoom({super.key, required this.chatID, required this.title});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final currUser = FirebaseAuth.instance.currentUser;
  final TextEditingController text = TextEditingController();
  List<ChatBoxModel> chats = [];
  var otherUser;
  List<String> parts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _timer?.cancel();
    text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    parts = widget.chatID.split('|');

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc((parts[0] != currUser!.uid) ? parts[0] : parts[2])
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          otherUser = snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: kBGColor,
            appBar: AppBar(
              backgroundColor: kBGColor,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: kPrimaryColor,
              ),
              title: Text(
                // (widget.title == '') ? 'TITLE' : widget.title,
                parts[3],
                style: kSubTextStyle,
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        // Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: kPrimaryColor,
                      ));
                },
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      }

                      chats = [];

                      if (snapshot.hasData) {
                        Map<String, dynamic> data = {};

                        try {
                          data = snapshot.data!.data() as Map<String, dynamic>;
                        } catch (e) {
                          return Expanded(
                            // child: ListView(

                            //   reverse: true,
                            //   children: chats.toList(),
                            // ),
                            child: ListView.builder(
                              reverse: true,
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                print('INDEX ' + index.toString());

                                return ChatBox(
                                    context,
                                    chats[index].text,
                                    chats[index].isFromMe,
                                    chats[index].dateTime,
                                    chats[index].imageUrl,
                                    chats[index].name,
                                    parts,
                                    currUser,
                                    );
                              },
                            ),
                          );
                        }

                        // Widget cb = ChatBox(data, isFromMe)

                        for (var k in data.keys) {
                          if (k == 'title') {
                            widget.title = data[k];
                            // setState(() {

                            // });
                            continue;
                          }
                          bool isFromMe =
                              (data[k]['uid'] == currUser!.uid) ? true : false;

                          // Widget cb = ChatBox(
                          //     data[k]['text'],
                          //     isFromMe,
                          //     data[k]['dateTime'],
                          //     default_profile_url,
                          //     otherUser['fullname']);
                          ChatBoxModel cbm = ChatBoxModel(
                            dateTime: data[k]['dateTime'],
                            imageUrl: default_profile_url,
                            isFromMe: isFromMe,
                            name: otherUser['fullname'],
                            text: data[k]['text'],
                          );
                          chats.add(cbm);
                        }

                        chats.sort((a, b) {
                          DateTime dateTimeA = DateTime.parse(
                              "${a.dateTime.split(" - ")[0]} ${a.dateTime.split(" - ")[1]}");
                          DateTime dateTimeB = DateTime.parse(
                              "${b.dateTime.split(" - ")[0]} ${b.dateTime.split(" - ")[1]}");
                          return dateTimeB.compareTo(dateTimeA);
                        });
                      }

                      return Expanded(
                        // child: ListView(
                        //   reverse: true,
                        //   children: chats.toList(),
                        // ),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ChatBox(
                                context,
                                chats[index].text,
                                chats[index].isFromMe,
                                chats[index].dateTime,
                                chats[index].imageUrl,
                                chats[index].name,
                                parts,
                                currUser,
                                );
                          },
                        ),
                      );
                    }),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: text,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.deepOrange,
                            border: InputBorder.none,
                            hintText: "Type message here",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (text.text.trim() != '') {
                            // var cb = ChatBox(text.text.trim()
                            // , false);

                            // chats.add(cb);

                            setState(() {
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd - kk:mm:ss')
                                      .format(now);
                              // var cb = ChatBox(text.text.trim(), true,
                              //     formattedDate, default_profile_url, '');

                              ChatBoxModel cbm = ChatBoxModel(
                                dateTime: formattedDate,
                                imageUrl: default_profile_url,
                                isFromMe: true,
                                name: '',
                                text: default_profile_url,
                              );
                              chats.add(cbm);

                              chats.insert(0, cbm);

                              if (chats.length == 1) {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.chatID)
                                    .set({
                                  // 'title': widget.title,
                                  '${text.text.trim()} | $formattedDate': {
                                    'text': text.text.trim(),
                                    'dateTime': formattedDate,
                                    'uid': currUser!.uid,
                                  },
                                  // 'title': widget.title,
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.chatID)
                                    .update({
                                  '${text.text.trim()} | $formattedDate': {
                                    'text': text.text.trim(),
                                    'dateTime': formattedDate,
                                    'uid': currUser!.uid,
                                  }
                                });
                              }
                            });
                          }
                          text.clear();
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.deepOrange,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

Widget ChatBox(BuildContext context, String text, bool isFromMe,
    String dateTime, String imageUrl, String name, List<String> parts, User? currUser) {
  return Row(
    mainAxisAlignment:
        isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (!isFromMe)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        isCurrUserProfile: false,
                        uid:(parts[0] != currUser!.uid) ? parts[0] : parts[2],
                      )),
            );
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 20.0,
          ),
        ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromMe)
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          Container(
            width: 250.0,
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: isFromMe ? Colors.deepOrange[400] : Colors.deepOrange[200],
              borderRadius: isFromMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(0))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(12.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateTime.toString(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12.0,
                      ),
                    ),
                    // SizedBox(width: 5,),
                    if (isFromMe)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
