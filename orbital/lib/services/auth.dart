import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Auth {
  FirebaseUser mCurrentUser;
  FirebaseAuth auth;
  final firestoreInstance = Firestore.instance;

  String name = "";
  String email = "";
  String uid = "";

  Auth() {
    getCurrentUser();
  }

  void getCurrentUser() async {
    mCurrentUser = await FirebaseAuth.instance.currentUser();
    uid = mCurrentUser.uid;
    getName1();
    

  }

  void getName1() async {
    DocumentSnapshot document = await Firestore.instance.collection('User').document(uid).get();
    name =  document.data["Name"];
    email = document.data["Email"];
  }

}

