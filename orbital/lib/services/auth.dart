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

  Future<bool> getCurrentUser() async {
    mCurrentUser = await FirebaseAuth.instance.currentUser();
    uid = mCurrentUser.uid;
    DocumentSnapshot document =
        await firestoreInstance.collection('User').document(uid).get();
    name = document.data["Name"];
    email = document.data["Email"];
    return true;
  }

  Future<List<String>> getFavourites() async {
    await getCurrentUser();
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('User').document(uid).get();
    return List.from(snapshot['Favourite']);
  }

  Future<bool> isFavouriteCCA(String ccaName) async {
    getCurrentUser();
    return (await getFavourites()).contains(ccaName);
  }

  Future<bool> isAdmin(String ccaName) async {
    getCurrentUser();
    return List.from((await firestoreInstance
            .collection('CCA')
            .document(ccaName)
            .get())['Admin'])
        .contains(uid);
  }

  void addFavouriteCCA(String ccaName) {
    getCurrentUser();

    firestoreInstance.collection('User').document(uid).updateData({
      "Favourite": FieldValue.arrayUnion([ccaName])
    });
    firestoreInstance
        .collection('CCA')
        .document(ccaName)
        .updateData({"FavouriteCount": FieldValue.increment(1)});
  }

  void removeFavouriteCCA(String ccaName) {
    firestoreInstance.collection('User').document(uid).updateData({
      "Favourite": FieldValue.arrayRemove([ccaName])
    });
    firestoreInstance
        .collection('CCA')
        .document(ccaName)
        .updateData({"FavouriteCount": FieldValue.increment(-1)});
  }
}
