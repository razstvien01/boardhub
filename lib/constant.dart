import 'package:flutter/material.dart';

const kPrimaryColor = Colors.white12;
const kLightColor = Colors.white;
const kAccentColor = Colors.white38;

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

//* Text style constants
const kHeadTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: kLightColor,
);

//* Text style constants
const kSubTextStyle = TextStyle(
  fontSize: 18.0,
  color: kLightColor,
);

const kSmallTextStyle = TextStyle(
  fontSize: 16.0,
  color: kLightColor,
);

const kTitleTextStyle = TextStyle(
  fontSize: 22.0,
  color: kLightColor,
);

const kCategoryTextStyle = TextStyle(
  fontSize: 32.0,
  color: kLightColor,
  fontWeight: FontWeight.w500
);

const kLightTextStyle = TextStyle(
  fontSize: 20.0,
  color: kLightColor,
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
