import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_house/constant.dart';
import 'package:rent_house/ud_widgets/default_textfield.dart';

class AddProperty extends StatefulWidget {
  final String property_type;
  
  const AddProperty({super.key, required this.property_type});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final currUser = FirebaseAuth.instance.currentUser;
  
  @override
  void dispose()
  
  {
    _titleController.dispose();
    _descriptionController.dispose();    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBGColor,
        toolbarHeight: 80.0,
        title: Text(
          'Add ${widget.property_type}',
          style: kSubTextStyle,
        ),
      ),
      backgroundColor: kBGColor,
      body: SingleChildScrollView(
        child: Container(
          child: Form(
                child: Column(
                  children: [
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _titleController,
                      hintText: 'Title',
                      icon: Icons.title,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    
                    DefaultTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: _descriptionController,
                      hintText: 'Description',
                      icon: Icons.description,
                      keyboardType: TextInputType.text,
                      maxLines: 8,
                      obscureText: false,
                      
                    ),
                    // DefaultTextField(
                    //   validator: (value) {
                    //     return null;
                    //   },
                    //   controller: _nameController,
                    //   hintText: 'Full Name',
                    //   icon: Icons.person_2,
                    //   keyboardType: TextInputType.text,
                    //   obscureText: false,
                    // ),
                    // SizedBox(
                    //   height: kDefaultPadding,
                    // ),
                    // DefaultTextField(
                    //   validator: (value) {
                    //     return null;
                    //   },
                    //   controller: _numberController,
                    //   hintText: 'Contact Number',
                    //   icon: Icons.phone,
                    //   keyboardType: TextInputType.text,
                    //   obscureText: false,
                    // ),
                    // SizedBox(
                    //   height: kDefaultPadding,
                    // ),
                    // SizedBox(
                    //   width: 250,
                    //   height: 45,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       //* if text is empty
                    //       if (_userController.text.trim() == '' ||
                    //           _nameController.text.trim() == '' ||
                    //           _numberController.text.trim() == '') {
                    //         // AlertDialog(
                    //         //   content: Text("Don't leave the entry empty."),
                    //         // );
                    //         return;
                    //       }

                    //       //* update
                    //       FirebaseFirestore.instance
                    //           .collection('users')
                    //           .doc('${currUser?.uid}')
                    //           .update({
                    //         'username': _userController.text.trim(),
                    //         'fullname': _nameController.text.trim(),
                    //         'contact number': _numberController.text.trim(),
                    //       });

                    //       widget.refresh();

                    //       //* pop
                    //       Navigator.pop(context);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: kPrimaryColor,
                    //         side: BorderSide.none,
                    //         shape: StadiumBorder()),
                    //     child: Text(
                    //       "Confirm",
                    //       style: kSubTextStyle,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: kBigPadding,
                    // ),
                    // ElevatedButton(
                    //   onPressed: () async{
                    //     await AuthService().deleteUser();
                    //     FirebaseAuth.instance.signOut();
                    //     Navigator.pop(context);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: kAccentColor,
                    //     elevation: 0,
                    //     foregroundColor: kPrimaryColor,
                    //     shape: StadiumBorder(),
                    //     side: BorderSide.none,
                    //   ),
                    //   child: Text(
                    //     "Delete Account",
                    //   ),
                    // ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}