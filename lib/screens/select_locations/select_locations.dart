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
  // final List<Cities> cities = [
  //   Cities(
  //     city: 'Cebu City, Cebu',
  //     pict:
  //         'https://sugbo.ph/wp-content/uploads/2021/12/Fuente-John-Kimwell-Laluma.jpg',
  //   ),
  //   Cities(
  //       city: 'Talisay City, Cebu',
  //       pict:
  //           'https://sugbo.ph/wp-content/uploads/2021/05/Talisay-City-Plaza-1024x462.jpg'),
  //   Cities(
  //       city: 'Mandaue City, Cebu',
  //       pict:
  //           'https://kmcmaggroup.com/ImageGen.ashx?image=/media/664897/why-mandaue-city-is-the-next-key-location-in-visayas-compressor.jpg&Compression=60'),
  //   Cities(
  //     city: 'Lapu-Lapu City, Cebu',
  //     pict:
  //         'https://a.travel-assets.com/findyours-php/viewfinder/images/res70/129000/129096-Cebu.jpg?impolicy=fcrop&w=1040&h=580&q=mediumHigh',
  //   ),
  //   Cities(
  //     city: 'Danao City, Cebu',
  //     pict:
  //         'https://www.phtourguide.com/wp-content/uploads/2010/07/DSC_3950.jpg',
  //   ),
  //   Cities(
  //     city: 'Naga City, Cebu',
  //     pict:
  //         'https://sa.kapamilya.com/absnews/abscbnnews/media/ancx/culture/2021/39/1naga.jpg',
  //   ),
  //   Cities(
  //     city: 'Carcar City, Cebu',
  //     pict:
  //         'https://cdn4.premiumread.com/?url=https://sunstar.com.ph/uploads/images/2022/01/18/333562.jpg&w=1000&q=100&f=webp&t=2',
  //   ),
  //   Cities(
  //     city: 'Toledo City, Cebu',
  //     pict:
  //         'https://i0.wp.com/www.theweekenddispatch.com/wp-content/uploads/2018/07/Toledo-Cebu-copper-city.jpg?w=728&ssl=1',
  //   ),
  //   Cities(
  //     city: 'Bogo City, Cebu',
  //     pict:
  //         'https://scontent.fceb1-3.fna.fbcdn.net/v/t39.30808-6/213557984_1944166512432001_1685830670273595679_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=e3f864&_nc_ohc=HsDHADBoQfgAX-0a__q&_nc_ht=scontent.fceb1-3.fna&oh=00_AfDfBF4EnbnquibSTwUEFbyDQLxXTZFliUv0sNqk-Y6c4g&oe=64359A05',
  //   ),
  //   Cities(
  //     city: 'San Fernando, Cebu',
  //     pict:
  //         'https://i0.wp.com/peoplaid.com/wp-content/uploads/2020/07/San-Fernando-Shines.jpg?w=579&ssl=1',
  //   ),
  // ];

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
        backgroundColor: kBGColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text(
          "Choose location",
          style: kSubTextStyle,
        ),
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
      ),
    );
  }
}
