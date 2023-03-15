import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/default_button.dart';
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
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
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
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  //* Add user detail function to the database
  Future addUserDetails(String username, String fullname, String number, String email) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);

    await docUser.set({
      'username': username,
      'fullname': fullname,
      'contact number': number,
      'email': email,
      'enable': true,
      'bookmark': {},
      'role': 'user',
    });
  }

  //* sign up button function
  Future signUp() async {
    // formKey.currentState!.validate();
    
    
    if (_passwordController1.text.trim() == _passwordController2.text.trim()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController1.text.trim(),
        );

        //* Add user details
        await addUserDetails(
            _userController.text.trim(), 
            _nameController.text.trim(),
            _numberController.text.trim(),
            _emailController.text.trim());

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/auth', (route) => false);
        Navigator.of(context).pushReplacementNamed('/auth');
      } on FirebaseAuthException catch (e) {
        // formKey.currentState!.validate();

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(e.message.toString()));
            });
      }
    }
    else{
      showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text("Mismatch passwords"));
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      // appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Image(
              image: AssetImage(logo),
              height: 190.0,
            ),
            Column(
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
                  validator: nameValidator,
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_2,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                DefaultTextField(
                  validator: (value){ return null; },
                  controller: _numberController,
                  hintText: 'Contact Number',
                  icon: Icons.phone,
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
            
            SizedBox(height: kDefaultPadding,),
            
            Column(
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
          ],
        ),
      ),
    );
  }
}
