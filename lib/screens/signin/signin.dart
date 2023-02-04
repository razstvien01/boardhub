import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/screens/forgot/forgot.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';
import 'package:rent_house/screens/signin/components/default_button.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';
import 'package:rent_house/ud_widgets/empty_appbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
      
    } on FirebaseAuthException catch (e) {
      formKey.currentState!.validate();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: EmptyAppBar(),
      backgroundColor: kBGColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Rent Boarding House',
                    style: kHeadTextStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextField(
                        validator: emailValidator,
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      SizedBox(
                        height: kFixPadding,
                      ),
                      DefaultTextField(
                        validator: passwordValidator,
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isObscure,
                        isObscure: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      SizedBox(
                        height: kFixPadding,
                      ),
                      ClearFullButton(
                        whiteText: 'I forgot my ',
                        colorText: 'Password',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Forgot();
                              },
                            ),
                          );
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClearFullButton(
                              colorText: "Sign Up",
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/signup');
                              },
                              whiteText: "Don\'t have an account? ",
                            ),
                            DefaultButton(
                              btnText: "Sign In",
                              onPressed: signIn,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
