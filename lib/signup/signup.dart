import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/signin/components/default_button.dart';
import 'package:rent_house/ud_widgets/clear_full_button.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';
import 'package:rent_house/ud_widgets/empty_appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //* Text  Controllers
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isObscure1 = true;

  //* dispose function
  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  //* Add user detail function to the database
  Future addUserDetails(String username, String email) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

    await docUser.set({
      'username': username,
      'email': email,
      'enable': true,
      'bookmark': {},
    });
  }

  //* sign up button function
  Future signUp() async {
    // formKey.currentState!.validate();

    if (_passwordController1.text.trim() == _passwordController2.text.trim()) {
      // try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController1.text.trim(),
        );

        //* Add user details
        await addUserDetails(
            _userController.text.trim(), _emailController.text.trim());

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/auth', (route) => false);
        Navigator.of(context).pushReplacementNamed('/auth');
      // } on FirebaseAuthException catch (e) {
      //   formKey.currentState!.validate();

      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(content: Text(e.message.toString()));
      //       });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      // appBar: EmptyAppBar(),
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
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _userController,
                      hintText: 'Username',
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    SizedBox(
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
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    DefaultTextField(
                      validator: passwordValidator,
                      controller: _passwordController1,
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
                      height: kDefaultPadding,
                    ),
                    DefaultTextField(
                      validator: passwordValidator,
                      controller: _passwordController2,
                      hintText: 'Confirm Password',
                      icon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscure1,
                      isObscure: () {
                        setState(() {
                          _isObscure1 = !_isObscure1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClearFullButton(
                      colorText: 'Sign In',
                      onPressed: ()
                      {
                        Navigator.of(context).pushReplacementNamed('/signin');
                      },
                      whiteText: 'Already have an account? ',
                    ),
                    DefaultButton(
                      btnText: 'Sign Up',
                      onPressed: signUp,
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
