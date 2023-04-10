import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/default_button.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  //* controls the text in the email textfield
  final _emailController = TextEditingController();
  
  //* dispose the value of _email controller to avoid memory leakage
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  //* passwordReset button
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email.'),
          );
        },
      );
      // Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                      ),
                      child: Text(
                        'Enter your registered email address. We\'ll send you an email to reset youre password.',
                        style: kSubTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    DefaultTextField(
                      validator: emailValidator,
                      controller: _emailController,
                      hintText: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
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
                        Navigator.of(context).pop();
                      },
                    ),
                    DefaultButton(
                      btnText: 'Submit',
                      onPressed: passwordReset,
                    ),
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
