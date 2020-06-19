import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/cca_normal_view.dart';
import 'package:orbital/services/auth.dart';

class ExploreCategory extends StatelessWidget {
  final database = Firestore.instance;
  final Auth auth;
  final String category;

  ExploreCategory({@required this.auth, @required this.category});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: database.collection('CCA').where("Category", isEqualTo: category).orderBy('Name').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new SizedBox(
                    height: 100,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        margin: EdgeInsets.all(3),
                        elevation: 3.0,
                        shadowColor: Colors.blue,
                        child: InkWell(
                            highlightColor: Colors.blueAccent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CCANormalView(
                                            document: document,
                                            auth: auth,
                                          )));
                            },
                            child: ListTile(
                              title: new Text(document['Name'],
                                  style: TextStyle(fontSize: 24)),
                              subtitle: new Text(document['Category'],
                                  style: TextStyle(fontSize: 20)),
                            ))));
              }).toList(),
            );
        }
      },
    );
  }
}
