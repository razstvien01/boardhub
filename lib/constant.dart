import 'package:flutter/material.dart';

import 'models/cities.dart';
import 'models/item_model.dart';


Map<String, dynamic> userGlbData = {};
//Map<String, dynamic> favItems = {};
List<Item> favItems = [];

const String default_profile_url = 'https://i.pinimg.com/736x/cb/d1/0d/cbd10dbde141f4a382cda5c8ad5e9dec.jpg';
// const String default_profile_url = 'https://i.pinimg.com/originals/13/64/28/136428aa185cbdb00b71c54c44afc047.jpg';

Map<String, dynamic> propertyData = {};
// var allPropData;
bool enable = true;
String? profileImageURL;
String? theCurrLoc = "Cebu City, Cebu";
final List<Cities> cities = [
    Cities(
      city: 'Cebu City, Cebu',
      pict:
          'https://sugbo.ph/wp-content/uploads/2021/12/Fuente-John-Kimwell-Laluma.jpg',
    ),
    Cities(
        city: 'Talisay City, Cebu',
        pict:
            'https://sugbo.ph/wp-content/uploads/2021/05/Talisay-City-Plaza-1024x462.jpg'),
    Cities(
        city: 'Mandaue City, Cebu',
        pict:
            'https://kmcmaggroup.com/ImageGen.ashx?image=/media/664897/why-mandaue-city-is-the-next-key-location-in-visayas-compressor.jpg&Compression=60'),
    Cities(
      city: 'Lapu-Lapu City, Cebu',
      pict:
          'https://a.travel-assets.com/findyours-php/viewfinder/images/res70/129000/129096-Cebu.jpg?impolicy=fcrop&w=1040&h=580&q=mediumHigh',
    ),
    Cities(
      city: 'Danao City, Cebu',
      pict:
          'https://www.phtourguide.com/wp-content/uploads/2010/07/DSC_3950.jpg',
    ),
    Cities(
      city: 'Naga City, Cebu',
      pict:
          'https://sa.kapamilya.com/absnews/abscbnnews/media/ancx/culture/2021/39/1naga.jpg',
    ),
    Cities(
      city: 'Carcar City, Cebu',
      pict:
          'https://cdn4.premiumread.com/?url=https://sunstar.com.ph/uploads/images/2022/01/18/333562.jpg&w=1000&q=100&f=webp&t=2',
    ),
    Cities(
      city: 'Toledo City, Cebu',
      pict:
          'https://i0.wp.com/www.theweekenddispatch.com/wp-content/uploads/2018/07/Toledo-Cebu-copper-city.jpg?w=728&ssl=1',
    ),
    Cities(
      city: 'Bogo City, Cebu',
      pict:
          'https://scontent.fceb1-3.fna.fbcdn.net/v/t39.30808-6/213557984_1944166512432001_1685830670273595679_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=e3f864&_nc_ohc=HsDHADBoQfgAX-0a__q&_nc_ht=scontent.fceb1-3.fna&oh=00_AfDfBF4EnbnquibSTwUEFbyDQLxXTZFliUv0sNqk-Y6c4g&oe=64359A05',
    ),
    Cities(
      city: 'San Fernando, Cebu',
      pict:
          'https://i0.wp.com/peoplaid.com/wp-content/uploads/2020/07/San-Fernando-Shines.jpg?w=579&ssl=1',
    ),
    Cities(
      city: 'Manila City, Metro Manila',
      pict:
          'https://vidalia.com.ph/images/header/home-page.jpg?2021-05-14',
    ),
  ];



// const kBGColor = Color.fromARGB(214, 0, 0, 0);
Color kBGColor = Colors.black;
// Color kBGColor = (Colors.red[500] as Color);


const kLightColor = Colors.white;
Color kAccentColor = const Color.fromARGB(143, 255, 153, 0);
Color kPrimaryColor = const Color.fromARGB(255, 197, 89, 17);
// const kPrimaryColor = Color.fromARGB(255, 255, 152, 0);

//* Default appbar height
const kAppBarHeight = 56.0;

//* Default round button radius
const kRadius = 0.0;
const kDefaultRadius = 20.0;

//* Default padding
const kCatPadding = 45.0;
const kBigPadding = 30.0;
const kDefaultPadding = 20.0;
const kLessPadding = 10.0;
const kFixPadding = 16.0;

const kShape = 30.0;

//* Images path
const String logo = 'assets/images/logo.png';

//* Text style constants
const kHeadTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: kLightColor,
);

//* Text style constants
const kSubTextStyle =
    TextStyle(fontSize: 20.0, color: kLightColor, fontWeight: FontWeight.bold);

const kSmallTextStyle = TextStyle(
  fontSize: 14.0,
  color: kLightColor,
);

TextStyle kSmallPrimTextStyle = TextStyle(
  // fontWeight: FontWeight.bold,
  fontSize: 14,
  color: kPrimaryColor,
  // overflow: TextOverflow.ellipsis,
);

const kMidItalicTextStyle = TextStyle(
  fontSize: 16.0,
  color: kLightColor,
  fontStyle: FontStyle.italic,
);

const kTitleTextStyle = TextStyle(
  fontSize: 22.0,
  color: kLightColor,
  fontWeight: FontWeight.bold,
);

const kCategoryTextStyle = TextStyle(
  fontSize: 32.0,
  color: kLightColor,
  fontWeight: FontWeight.w500,
  overflow: TextOverflow.ellipsis,
);

TextStyle kAccentTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 18,
  color: kAccentColor,
  overflow: TextOverflow.ellipsis,
);

const kLightTextStyle = TextStyle(
  fontSize: 20.0,
  color: kLightColor,
  overflow: TextOverflow.ellipsis,
);

TextStyle kPrimTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: kPrimaryColor,
  overflow: TextOverflow.ellipsis,
);

//* Validators
String? emailValidator(String? value) {
  if (value!.isEmpty) {
    return 'Must be filled';
  }
  if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return null;
  }
  return 'Enter correct email';
}

String? passwordValidator(String? value) {
  if (!(value!.length > 5) && value.isNotEmpty) {
    return "Should contain more than 5 characters";
  }

  if (value.isEmpty) {
    return "Should not be empty";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value!.isEmpty) {
    return 'Must be filled';
  }
  
  if(RegExp('[a-zA-Z]').hasMatch(value))
  {
    return null;
  }

  return "Enter a Valid Name";
}
