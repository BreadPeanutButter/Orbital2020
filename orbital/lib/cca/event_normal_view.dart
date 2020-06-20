import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class EventNormalView extends StatelessWidget {
  final DocumentSnapshot document;

  EventNormalView({@required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(document['Name'], style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: ListView(children: [
          Container(
              height: 50,
              child: Card(
                  margin: EdgeInsets.all(5),
                  elevation: 1.0,
                  shadowColor: Colors.blue,
                  child: Text(document['Details'],
                      style: TextStyle(fontSize: 20)))),
          Card(
              margin: EdgeInsets.all(5),
              elevation: 1.0,
              shadowColor: Colors.blue,
              child:
                  Text(document['EventTime'], style: TextStyle(fontSize: 20))),
          Container(
              height: 50,
              child: Card(
                  margin: EdgeInsets.all(5),
                  elevation: 1.0,
                  shadowColor: Colors.blue,
                  child: Text(document['Location'],
                      style: TextStyle(fontSize: 20)))),
          SizedBox(height: 50),
          CupertinoButton.filled(onPressed: null, child: Text('Bookmark')),
        ]));
  }
}
