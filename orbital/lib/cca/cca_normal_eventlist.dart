import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class CCANormalEventlist extends StatelessWidget {
  final CollectionReference eventSubCollection;

  CCANormalEventlist({@required this.eventSubCollection});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: eventSubCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new Container(
                    height: 115,
                    child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 3.0,
                        shadowColor: Colors.blue,
                        child: InkWell(
                            highlightColor: Colors.blueAccent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => null));
                            },
                            child: ListTile(
                              title: new Text(document['Name'],
                                  style: TextStyle(fontSize: 24)),
                              subtitle: new Text(document['DateTime'],
                                  style: TextStyle(fontSize: 20)),
                            ))));
              }).toList(),
            );
        }
      },
    );
  }
}
