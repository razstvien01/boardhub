import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/item_model.dart';

class ChatRoom extends StatefulWidget {
  final Item item;
  const ChatRoom({super.key, required this.item});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final currUser = FirebaseAuth.instance.currentUser;
  
  void initState()
  {
    print('Passed');
    print(widget.item.tenantID! + '|' + widget.item.dateTime + '|' + currUser!.uid);
  }
  
  
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
        // title: Text(
        //   widget.category_name as String,
        //   style: kSubTextStyle,
        // ),
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
        // actions: [
        //   if (currUser!.uid == widget.item.tenantID)
        //     Row(
        //       children: [
        //         IconButton(
        //             onPressed: () {
        //               // _showDialogBox(context);

        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => EditPosts(
        //                           item: widget.item,
        //                         )),
        //               );
        //             },
        //             icon: const Icon(Icons.edit)),
        //         IconButton(
        //             onPressed: () {
        //               _showDialogBox(
        //                   context,
        //                   'properties',
        //                   widget.item.location as String,
        //                   widget.item.dateTime.toString());
        //             },
        //             icon: const Icon(Icons.delete)),
        //       ],
        //     )
        // ],
      ),
      
    );
  }
}