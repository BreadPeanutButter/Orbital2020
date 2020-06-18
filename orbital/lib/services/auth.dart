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
    getName();
  }

  void getName() async {
    DocumentSnapshot document =
        await firestoreInstance.collection('User').document(uid).get();
    name = document.data["Name"];
    email = document.data["Email"];
  }

  Future<bool> isFavouriteCCA(String ccaName) async {
   
   DocumentSnapshot snapshot = await Firestore.instance.collection('User').document(uid).get();
   return List.from(snapshot['Favourite']).contains(ccaName);

  }

  void addFavouriteCCA(String ccaName) {
    DocumentReference document =  
        firestoreInstance.collection('User').document(uid);
    document.updateData({
      "Favourite": FieldValue.arrayUnion([ccaName])
    });
  }

  void removeFavouriteCCA(String ccaName) {
    DocumentReference document =
        firestoreInstance.collection('User').document(uid);
    document.updateData({
      "Favourite": FieldValue.arrayRemove([ccaName])
    });
  }
}
