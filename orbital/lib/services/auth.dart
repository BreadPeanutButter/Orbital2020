import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Auth {
  FirebaseUser mCurrentUser;
  FirebaseAuth auth;
  final firestoreInstance = Firestore.instance;

  String name = "";
  String email = "";
  String uid = "";
  String dateJoined = "";
  String googleSignedIn = "";

  Auth() {
    getCurrentUser();
  }

  Future<bool> getCurrentUser() async {
    final df = new DateFormat('dd/MM/yyyy');
    mCurrentUser = await FirebaseAuth.instance.currentUser();
    uid = mCurrentUser.uid;
    DocumentSnapshot document =
        await firestoreInstance.collection('User').document(uid).get();
    name = document.data["Name"];
    email = document.data["Email"];
    dateJoined = df.format(document.data["DateJoined"].toDate());
    googleSignedIn = document.data["googleSignedIn"];
    return true;
  }

  Future<List<String>> getAdminCCAs() async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('User').document(uid).get();
    return List.from(snapshot['AdminOf']);
  }

  Future<List<String>> getFavourites() async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('User').document(uid).get();
    return List.from(snapshot['Favourite']);
  }

  Future<bool> isFavouriteCCA(String ccaName) async {
    return (await getFavourites()).contains(ccaName);
  }

  Future<List<String>> getBookmarks() async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('User').document(uid).get();
    return List.from(snapshot['BookmarkedEvent']);
  }

  Future<bool> isBookmarkedEvent(String id) async {
    return (await getBookmarks()).contains(id);
  }

  Future<bool> isAdminOf(String ccaID) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    return List.from((await firestoreInstance
            .collection('User')
            .document(uid)
            .get())['AdminOf'])
        .contains(ccaID);
  }

  void addFavouriteCCA(String ccaName) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }

    firestoreInstance.collection('User').document(uid).updateData({
      "Favourite": FieldValue.arrayUnion([ccaName])
    });
    firestoreInstance
        .collection('CCA')
        .document(ccaName)
        .updateData({"FavouriteCount": FieldValue.increment(1)});
  }

  void editName(String name) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }

    firestoreInstance
        .collection('User')
        .document(uid)
        .updateData({"Name": name});
  }

  void removeFavouriteCCA(String ccaName) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    firestoreInstance.collection('User').document(uid).updateData({
      "Favourite": FieldValue.arrayRemove([ccaName])
    });
    firestoreInstance
        .collection('CCA')
        .document(ccaName)
        .updateData({"FavouriteCount": FieldValue.increment(-1)});
  }

  void bookmarkEvent(String id) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    firestoreInstance.collection('User').document(uid).updateData({
      "BookmarkedEvent": FieldValue.arrayUnion([id])
    });
    firestoreInstance
        .collection('Event')
        .document(id)
        .updateData({"BookmarkCount": FieldValue.increment(1)});
  }

  void unbookmarkEvent(String id) async {
    if (uid.isEmpty) {
      await getCurrentUser();
    }
    firestoreInstance.collection('User').document(uid).updateData({
      "BookmarkedEvent": FieldValue.arrayRemove([id])
    });
    firestoreInstance
        .collection('Event')
        .document(id)
        .updateData({"BookmarkCount": FieldValue.increment(-1)});
  }
}
