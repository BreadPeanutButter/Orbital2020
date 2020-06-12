import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  
  Future<FirebaseUser> getCurrentUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user; 
  } 

}