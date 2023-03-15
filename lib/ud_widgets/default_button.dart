import 'package:rent_house/constant.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  const DefaultButton({
    super.key,
    required this.btnText,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: TextButton(
        
        onPressed: onPressed,
        child: Text(btnText.toUpperCase()),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: kLessPadding),
          backgroundColor: kPrimaryColor,
          foregroundColor: kLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kShape),
          ),
          // shape: Roun
        ),
      ),
    );
  }
}
