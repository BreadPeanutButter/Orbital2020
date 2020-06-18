import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CCANormalAbout extends StatelessWidget {
  final DocumentSnapshot document;

  CCANormalAbout({this.document});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final String category = document['Category'];
    final String description = document['Description'];
    final String email = document['Contact'];
    final String imageURL = document['profile image'];

    return ListView(children: [
      Image.network(
          imageURL,
          height: 200,
          width: 200,
          ),
      Container(height: 50, child:Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text(category, style: TextStyle(fontSize: 20)))), //category
      Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text(description, style: TextStyle(fontSize: 20))), //description
      Container(height: 50, child: Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text(email, style: TextStyle(fontSize: 20)))), //email
      Card(), //external sites
    ]);
  }
}
