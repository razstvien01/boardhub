

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
    final List<Cities> cities =[
    Cities(city: 'Cebu', pict: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Cebu_City_%28Aerial%29.jpg/1280px-Cebu_City_%28Aerial%29.jpg', ),
    Cities(city: 'Bohol', pict: 'https://as2.ftcdn.net/v2/jpg/02/45/12/75/1000_F_245127528_7gZopPwmB8Uiey1gRy9NLmejKOdFtnbr.jpg'),
    Cities(city: 'Leyte', pict: 'https://as1.ftcdn.net/v2/jpg/05/36/90/62/1000_F_536906217_zySORJiXroWbYVca6XlkNAysVuSebeKv.jpg'),
    Cities(city: 'Samar', pict: 'https://as1.ftcdn.net/v2/jpg/04/74/74/30/1000_F_474743011_kYbOiWraGtT6LeAuPfMNXmsEANinb7lK.jpg'),
    Cities(city: 'Negros', pict: 'https://philippineholidays.com.au/wp-content/uploads/2015/04/Talisay-Negros-Occidental.jpg'),
    Cities(city: 'Masbate', pict: 'https://masbatecity.balinkbayan.gov.ph/wp-content/uploads/2016/09/thecityofmasbate.jpg'),
    Cities(city: 'Panay', pict: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/d0/92/bc/the-view.jpg?w=700&h=-1&s=1'),
    Cities(city: 'Romblon', pict: 'https://www.karlaroundtheworld.com/wp-content/uploads/2017/08/Cobrador-Islad-2.png'),
    Cities(city: 'Palawan', pict: 'https://greenglobaltravel.com/wp-content/uploads/2019/08/Palawan-Coron-Resorts-Coron-Westown-Resort.jpg'),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Places', style: TextStyle(color: Colors.grey[800]),),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
    body: Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Cebu_City_%28Aerial%29.jpg/1280px-Cebu_City_%28Aerial%29.jpg'),
          ),
          title: Text("Cebu City, Cebu",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){
            
            setState(() {
              theCurrLoc = "Cebu City, Cebu";
            });
            
            
            widget.refresh();
            
            Navigator.of(context).pop();
            
          },
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://as2.ftcdn.net/v2/jpg/02/45/12/75/1000_F_245127528_7gZopPwmB8Uiey1gRy9NLmejKOdFtnbr.jpg'),
          ),
          title: Text("Talisay City, Cebu",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){
            
            theCurrLoc = "Talisay City, Cebu";
            
            widget.refresh();
            
            Navigator.of(context).pop();
            
          },
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://as1.ftcdn.net/v2/jpg/05/36/90/62/1000_F_536906217_zySORJiXroWbYVca6XlkNAysVuSebeKv.jpg'),
          ),
          title: Text("Leyte",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://as1.ftcdn.net/v2/jpg/04/74/74/30/1000_F_474743011_kYbOiWraGtT6LeAuPfMNXmsEANinb7lK.jpg'),
          ),
          title: Text("Samar",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://philippineholidays.com.au/wp-content/uploads/2015/04/Talisay-Negros-Occidental.jpg'),
          ),
          title: Text("Negros",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://masbatecity.balinkbayan.gov.ph/wp-content/uploads/2016/09/thecityofmasbate.jpg'),
          ),
          title: Text("Masbate",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/d0/92/bc/the-view.jpg?w=700&h=-1&s=1'),
          ),
          title: Text("Panay",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://www.karlaroundtheworld.com/wp-content/uploads/2017/08/Cobrador-Islad-2.png'),
          ),
          title: Text("Romblon",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:NetworkImage('https://greenglobaltravel.com/wp-content/uploads/2019/08/Palawan-Coron-Resorts-Coron-Westown-Resort.jpg'),
          ),
          title: Text("Palawan",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: (){},
          enabled: true,
          trailing: Icon(Icons.place),
        ),
      ],
    ),
    );
  }
}