import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/painting/_network_image_io.dart';

class CCANormalAbout extends StatelessWidget {
  final DocumentSnapshot document;

  CCANormalAbout({this.document});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final String category = document['Category'];
    final String description = document['Description'];
    final String email = document['Contact'];
    final String imageURL = document['image'];

    Widget getWidget(){
      if(imageURL == null){
        return SizedBox(height: 20);
      }
      else{
        return Image.network(
          imageURL,
          height: 200,
          width: 200,
          );
      }
    }

    return ListView(children: [
      getWidget(),
      Container(height: 50, child:Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text('Category: ' + category, style: TextStyle(fontSize: 20)))), //category
      Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text('Description: ' + description, style: TextStyle(fontSize: 20))), //description
      Container(height: 50, child: Card(
          margin: EdgeInsets.all(5),
          elevation: 1.0,
          shadowColor: Colors.blue,
          child: Text('Email and contact: ' + email, style: TextStyle(fontSize: 20)))), //email
      Card(), //external sites
    ]);
  }
}
