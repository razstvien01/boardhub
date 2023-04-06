import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/models/cities.dart';

class SelectLocation extends StatefulWidget {
  final VoidCallback refresh;

  const SelectLocation({super.key, required this.refresh});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final List<Cities> cities = [
    Cities(
      city: 'Cebu City, Cebu',
      pict:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Cebu_City_%28Aerial%29.jpg/1280px-Cebu_City_%28Aerial%29.jpg',
    ),
    Cities(
        city: 'Talisay City, Cebu',
        pict:
            'https://as2.ftcdn.net/v2/jpg/02/45/12/75/1000_F_245127528_7gZopPwmB8Uiey1gRy9NLmejKOdFtnbr.jpg'),
    Cities(
        city: 'Mandaue City, Cebu',
        pict:
            'https://as1.ftcdn.net/v2/jpg/05/36/90/62/1000_F_536906217_zySORJiXroWbYVca6XlkNAysVuSebeKv.jpg'),
    Cities(
      city: 'Lapu-Lapu City, Cebu',
      pict:
          'https://as1.ftcdn.net/v2/jpg/03/49/01/07/1000_F_349010756_tBJ8xRbdV7zRMQPrnht5JbKwmSLoFXaH.jpg',
    ),
    Cities(
      city: 'Danao City, Cebu',
      pict:
          'https://as2.ftcdn.net/v2/jpg/02/35/58/90/1000_F_235589098_AoYmGvL2JDTW8mKBldz7pZ9zwQR5QU5r.jpg',
    ),
    Cities(
      city: 'Naga City, Cebu',
      pict:
          'https://as1.ftcdn.net/v2/jpg/03/27/09/86/1000_F_327098693_T-9Rgcgg9X-ztoW1aiOdiJlPIYg3f3qV.jpg',
    ),
    Cities(
      city: 'Carcar City, Cebu',
      pict:
          'https://as2.ftcdn.net/v2/jpg/03/13/24/75/1000_F_313247505_SlrvfS1nDwGVp22bB8W-41LPAnRsPymt.jpg',
    ),
    Cities(
      city: 'Toledo City, Cebu',
      pict:
          'https://as1.ftcdn.net/v2/jpg/02/16/09/77/1000_F_216097714_RpIJLjxgAGvJmlDnvYeBY3ZqTt2jKsJh.jpg',
    ),
    Cities(
      city: 'Bogo City, Cebu',
      pict:
          'https://as1.ftcdn.net/v2/jpg/01/25/38/11/1000_F_125381127_EJ7LszpZb5V6U5n5HKQVwNZctmGTxtzk.jpg',
    ),
    Cities(
      city: 'San Fernando, Cebu',
      pict:
          'https://as2.ftcdn.net/v2/jpg/03/01/54/64/1000_F_301546497_Bd98pIWHYwWXqGIXHjSe8xvGMpNyyRVZ.jpg',
    ),
  ];

  final currUser = FirebaseAuth.instance.currentUser;

  ListTile placeTile(String url, String location) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
      title: Text(location, style: kSmallTextStyle),
      onTap: () {
        userGlbData['location'] = location;

        FirebaseFirestore.instance
            .collection('users')
            .doc('${currUser?.uid}')
            .update({
          'location': userGlbData['location'],
        });

        widget.refresh();

        Navigator.of(context).pop();
      },
      enabled: true,
      trailing: Icon(Icons.place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Places',
          style: kSubTextStyle,
        ),
        centerTitle: true,
        backgroundColor: kBGColor,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          ListView.builder(
              itemCount: cities.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return placeTile(cities[index].pict, cities[index].city);
              })),
        ],
        // children: <Widget>[
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Cebu_City_%28Aerial%29.jpg/1280px-Cebu_City_%28Aerial%29.jpg'),
        //     ),
        //     title: Text("Cebu City, Cebu", style: kSmallTextStyle),
        //     onTap: () {
        //       // userGlbData['location'] = "Cebu City, Cebu";
        //       setState(() {
        //         userGlbData['location'] = "Cebu City, Cebu";
        //       });

        //       FirebaseFirestore.instance
        //           .collection('users')
        //           .doc('${currUser?.uid}')
        //           .update({
        //         'location': userGlbData['location'],
        //       });

        //       widget.refresh();

        //       Navigator.of(context).pop();
        //     },
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://as2.ftcdn.net/v2/jpg/02/45/12/75/1000_F_245127528_7gZopPwmB8Uiey1gRy9NLmejKOdFtnbr.jpg'),
        //     ),
        //     title: Text("Talisay City, Cebu",
        //         style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {
        //       userGlbData['location'] = "Talisay City, Cebu";

        //       FirebaseFirestore.instance
        //           .collection('users')
        //           .doc('${currUser?.uid}')
        //           .update({
        //         'location': userGlbData['location'],
        //       });

        //       widget.refresh();

        //       Navigator.of(context).pop();
        //     },
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://as1.ftcdn.net/v2/jpg/05/36/90/62/1000_F_536906217_zySORJiXroWbYVca6XlkNAysVuSebeKv.jpg'),
        //     ),
        //     title: Text("Leyte", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://as1.ftcdn.net/v2/jpg/04/74/74/30/1000_F_474743011_kYbOiWraGtT6LeAuPfMNXmsEANinb7lK.jpg'),
        //     ),
        //     title: Text("Samar", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://philippineholidays.com.au/wp-content/uploads/2015/04/Talisay-Negros-Occidental.jpg'),
        //     ),
        //     title:
        //         Text("Negros", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://masbatecity.balinkbayan.gov.ph/wp-content/uploads/2016/09/thecityofmasbate.jpg'),
        //     ),
        //     title:
        //         Text("Masbate", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/d0/92/bc/the-view.jpg?w=700&h=-1&s=1'),
        //     ),
        //     title: Text("Panay", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://www.karlaroundtheworld.com/wp-content/uploads/2017/08/Cobrador-Islad-2.png'),
        //     ),
        //     title:
        //         Text("Romblon", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        //   ListTile(
        //     leading: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://greenglobaltravel.com/wp-content/uploads/2019/08/Palawan-Coron-Resorts-Coron-Westown-Resort.jpg'),
        //     ),
        //     title:
        //         Text("Palawan", style: TextStyle(fontStyle: FontStyle.italic)),
        //     onTap: () {},
        //     enabled: true,
        //     trailing: Icon(Icons.place),
        //   ),
        // ],
      ),
    );
  }
}
