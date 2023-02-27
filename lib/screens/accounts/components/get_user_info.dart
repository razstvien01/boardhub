import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';

class GetUserInfo extends StatefulWidget {
  final String documentId;

  const GetUserInfo({
    super.key,
    required this.documentId,
  });

  @override
  State<GetUserInfo> createState() => _GetUserInfoState();
}

class _GetUserInfoState extends State<GetUserInfo> {
  Card accountTile(Map<String, dynamic> data, BuildContext context) {
    return Card(
      color: kAccentColor,
      shadowColor: kAccentColor,
      elevation: 16,
      // color: Colors.green,
      // elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        // alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: kBGColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10))),
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Text(
                  'Username: ${data['username']}',
                  style: kSubTextStyle,
                ),
                Text(
                  'Email: ${data['email']}',
                  style: TextStyle(color: kPrimaryColor),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Flushbar(
                        //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        //   flushbarStyle: FlushbarStyle.FLOATING,
                        //   reverseAnimationCurve: Curves.decelerate,
                        //   forwardAnimationCurve: Curves.elasticOut,
                        //   flushbarPosition: FlushbarPosition.TOP,
                        //   isDismissible: true,
                        //   message: (!data['enable'])
                        //       ? '${data['username']}\'s account has been enabled'
                        //       : '${data['username']}\'s account has been disabled',
                        //   icon: Icon(
                        //     Icons.info_outline,
                        //     size: 28.0,
                        //     color: Colors.blue[300],
                        //   ),
                        //   duration: Duration(seconds: 2),
                        //   leftBarIndicatorColor: kLightColor,
                        // )..show(context);

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.documentId)
                            .update({
                          'enable': !data['enable'],
                        });
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (!data['enable'])
                                ? Icons.no_accounts
                                : Icons.account_circle,
                            color: kBGColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (!data['enable']) ? Text('Unblock') : Text('Block')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     Text(
        //       'Username: ${data['username']}',
        //       style: kSubTextStyle,
        //     ),
        //     Text(
        //       'Email: ${data['email']}',
        //       style: TextStyle(color: kPrimaryColor),
        //     ),
        //     SizedBox(
        //       width: 150,
        //       child: ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             // Flushbar(
        //             //   dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        //             //   flushbarStyle: FlushbarStyle.FLOATING,
        //             //   reverseAnimationCurve: Curves.decelerate,
        //             //   forwardAnimationCurve: Curves.elasticOut,
        //             //   flushbarPosition: FlushbarPosition.TOP,
        //             //   isDismissible: true,
        //             //   message: (!data['enable'])
        //             //       ? '${data['username']}\'s account has been enabled'
        //             //       : '${data['username']}\'s account has been disabled',
        //             //   icon: Icon(
        //             //     Icons.info_outline,
        //             //     size: 28.0,
        //             //     color: Colors.blue[300],
        //             //   ),
        //             //   duration: Duration(seconds: 2),
        //             //   leftBarIndicatorColor: kLightColor,
        //             // )..show(context);

        //             FirebaseFirestore.instance
        //                 .collection('users')
        //                 .doc(widget.documentId)
        //                 .update({
        //               'enable': !data['enable'],
        //             });
        //           });
        //         },
        //         style: ButtonStyle(
        //             backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
        //         child: Padding(
        //           padding: const EdgeInsets.all(5),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Icon(
        //                 (!data['enable'])
        //                     ? Icons.no_accounts
        //                     : Icons.account_circle,
        //                 color: kBGColor,
        //               ),
        //               SizedBox(
        //                 width: 8,
        //               ),
        //               (!data['enable']) ? Text('Unblock') : Text('Block')
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return accountTile(data, context);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
