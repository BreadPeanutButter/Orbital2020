import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/cca_normal_view.dart';
import 'package:orbital/cca/cca_admin_view.dart';
import 'package:orbital/services/auth.dart';

class ExploreFavourites extends StatelessWidget {
  static const index = 0;
  final collectionRef = Firestore.instance.collection('CCA');
  Auth auth;
  Future<List> favourites;
  List favList;

  ExploreFavourites({@required this.auth}) {
    favourites = auth.getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: favourites,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            favList = snapshot.data.reversed.toList();
            if (favList.isEmpty) {
              return Center(
                  child: Text(
                'No favourite CCAs ☹️',
                style: TextStyle(fontSize: 30),
              ));
            } else {
              return ListView.builder(
                  itemCount: favList.length,
                  itemBuilder: (BuildContext ctxt, int index) =>
                      buildBody(ctxt, index));
            }
          }
        });
  }

  Widget buildBody(BuildContext ctxt, int index) {
    return FutureBuilder(
        future: collectionRef.document(favList[index]).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return new SizedBox(
                height: 100,
                child: Card(
                    shape: RoundedRectangleBorder(
                        side:
                            new BorderSide(color: Colors.grey[600], width: 1.0),
                        borderRadius: BorderRadius.circular(4.0)),
                    margin: EdgeInsets.all(3),
                    elevation: 1.0,
                    shadowColor: Colors.blue,
                    child: InkWell(
                        highlightColor: Colors.blueAccent,
                        onTap: () => goToCCAViewPage(context, snapshot.data),
                        child: ListTile(
                          title: new Text(snapshot.data['Name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 22)),
                          subtitle: new Text(snapshot.data['Category'],
                              style: TextStyle(fontSize: 20)),
                        ))));
          }
        });
  }

  void goToCCAViewPage(BuildContext context, DocumentSnapshot document) async {
    bool userIsAdmin = await auth.isAdminOf(document.documentID);
    if (userIsAdmin) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CCAAdminView(document: document, exploreIndex: index)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CCANormalView.tab(document: document, previousIndex: index)));
    }
  }
}
