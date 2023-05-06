import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/message.dart';
import 'package:rent_house/screens/chat/chat_room.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final currUser = FirebaseAuth.instance.currentUser;
  List<Message> messages = [];

  String getLatestFormattedDateTime(String format1, String format2) {
    DateTime now = DateTime.now();
    String formattedDate1 = DateFormat(format1).format(now);
    String formattedDate2 = DateFormat(format2).format(now);
    return (formattedDate1.compareTo(formattedDate2) > 0)
        ? formattedDate1
        : formattedDate2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: const Text("Chat"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Chat",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }

                    messages = [];

                    if (snapshot.hasData) {
                      Map<String, dynamic> data = {};

                      // print(snapshot.data.)

                      // Get the documents from the collection

                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;
                        
                      try {
                        for (var k in documents) {
                          List<String> parts = k.id.split('|');

                          if (parts[0] == currUser!.uid ||
                              parts[2] == currUser!.uid) {
                            if (parts[0] != currUser!.uid) {
                              Message m = Message(
                                id: parts[0],
                                currUid: currUser!.uid,
                                snippet: 'Sample',
                                time: 'Sample',
                                avatar: default_profile_url,
                                chatID: k.id,
                                title: parts[3],
                              );

                              List<Map<String, String>> messDate = [];

                              try{

                              }catch(e){

                              }

                              // for(var item in snapshot.data!.do)
                              // print(m.chatID);
                              messages.add(m);
                            } else {

                              Message m = Message(
                                  avatar: default_profile_url,
                                  chatID: k.id,
                                  id: currUser!.uid,
                                  currUid: parts[2],
                                  time: 'Sample',
                                  snippet: 'Latest chat',
                                  title: parts[3]);

                              Map<String, String> dateSnippet = {};

                              documents.forEach((document) {
                                // String name = document.data()['name'];
                                // print('Name: $name');

                                print('Document: ' + document.data().toString());

                                Map<String, dynamic> doc = document.data() as Map<String, dynamic>;

                                for(var k in doc.keys)
                                {
                                  print(k);
                                }
                                // print(document.data()!['dateTime']);
                                // for(var k in document)
                                // {

                                // }
                              });
                              messages.add(m);

                              // print(m.chatID);
                              print(messages);
                              // ChatRoom(chatID: chatID, chatName: widget.item.title as String, tenantID: widget.item.tenantID as String)
                            }

                            print(messages.length);
                          }
                        }
                      } catch (e) {}
                    }

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(messages[index].id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              }

                              // print(snapshot.data!.data());
                              Map<String, dynamic> data = {};
                              if (snapshot.hasData) {
                                try {
                                  data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                } catch (e) {}

                                for (var k in data.keys) {}
                              }

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        chatID: messages[index].chatID,
                                        title: '',
                                        // chatName: '',
                                        // tenantID: messages[index].currUid
                                      ),
                                    ),
                                  );
                                },
                                horizontalTitleGap: 3.0,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                  vertical: 2.0,
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      (data['profile_url'] == "" ||
                                              data['profile_url'] == null)
                                          ? default_profile_url
                                          : data['profile_url']),
                                  radius: 32.0,
                                ),
                                title: Text(
                                  messages[index].title,
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // subtitle: Text(
                                //   messages[index].snippet,
                                //   style: const TextStyle(
                                //     color: Colors.deepOrange,
                                //     fontWeight: FontWeight.normal,
                                //   ),
                                // ),
                                // trailing: Text(
                                //   messages[index].time,
                                //   style: const TextStyle(
                                //     color: Colors.deepOrange,
                                //     fontWeight: FontWeight.normal,
                                //   ),
                                // ),
                              );
                            });
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
