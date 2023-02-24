import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_house/services/auth.dart';
import 'package:rent_house/services/database.dart';

class AuthService {
  final currUser = FirebaseAuth.instance.currentUser;
  
  Future deleteUser() async
  {
    
    try {
      
      await DatabaseService(uid: currUser!.uid).deleteUser();
      await currUser!.delete();
      
      return AuthStateChange();
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
