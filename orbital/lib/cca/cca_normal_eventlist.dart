import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/event_normal_view.dart';

class CCANormalEventlist extends StatelessWidget {
  final database = Firestore.instance;
  DocumentSnapshot ccaDocument;

  CCANormalEventlist({@required this.ccaDocument});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: database
          .collection('Event')
          .where("CCA", isEqualTo: ccaDocument['Name'])
          .orderBy('DateCreated', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text(
              'No events available ☹️',
              style: TextStyle(fontSize: 20),
            );
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
                                      builder: (context) =>
                                          EventNormalView(document: document)));
                            },
                            child: ListTile(
                              title: new Text(
                                  document['CCA'] + ': ' + document['Name'],
                                  style: TextStyle(fontSize: 24)),
                              subtitle: new Text(document['EventTime'],
                                  style: TextStyle(fontSize: 20)),
                            ))));
              }).toList(),
            );
        }
      },
    );
  }
}
