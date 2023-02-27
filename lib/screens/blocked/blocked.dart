import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';

class Blocked extends StatefulWidget {
  const Blocked({super.key});

  @override
  State<Blocked> createState() => _BlockedState();
}

class _BlockedState extends State<Blocked> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Image(
                  image: AssetImage(logo),
                  height: 190.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                      ),
                      child: Text(
                        'We regret to inform you that your account has been restricted by the administrator due to possible violation of our established guidelines. We kindly request you to review our terms of use and contact us if you have any questions or concerns.',
                        style: kSubTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    // DefaultTextField(
                    //   validator: emailValidator,
                    //   controller: _emailController,
                    //   hintText: 'Email Address',
                    //   icon: Icons.email,
                    //   keyboardType: TextInputType.emailAddress,
                    //   obscureText: false,
                    // ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClearFullButton(
                      whiteText: 'Back to ',
                      colorText: 'Sign in',
                      onPressed: () {
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AuthStateChange()));
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                                    .pushReplacementNamed('/auth');
                      },
                    ),
                    // DefaultButton(
                    //   btnText: 'Go Back',
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
