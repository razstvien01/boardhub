import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  
  DatabaseService({required this.uid});
  
  late CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  
  Future deleteUser(){
    return userCollection.doc(uid).delete();
  }
}