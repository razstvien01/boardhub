// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

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
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 25,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: kAccentColor,
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://pfpmaker.com/_nuxt/img/profile-3-1.3e702c5.png'),
            ),
            title: Text("Rancis has messaged you", style: kMidItalicTextStyle),
            subtitle: Text(
              '4:05pm',
              style: kSmallTextStyle,
            ),
            onTap: () {},
            enabled: true,
            trailing: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: kPrimaryColor,
                )),
          );
        },
        separatorBuilder: ((context, index) {
          return Divider();
        }),
      ),
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
