import 'package:flutter/material.dart';


Map<String, dynamic> userGlbData = {};
bool enable = true;

// const kBGColor = Color.fromARGB(214, 0, 0, 0);
Color kBGColor = (Colors.black as Color);
// Color kBGColor = (Colors.red[500] as Color);


const kLightColor = Colors.white;
Color kAccentColor = (Color.fromARGB(143, 255, 153, 0) as Color);
Color kPrimaryColor = Color.fromARGB(255, 197, 89, 17);
// const kPrimaryColor = Color.fromARGB(255, 255, 152, 0);

String? imageURL;

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
