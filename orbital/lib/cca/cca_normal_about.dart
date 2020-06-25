import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/painting/_network_image_io.dart';
import 'package:google_fonts/google_fonts.dart';

class CCANormalAbout extends StatelessWidget {
  final DocumentSnapshot document;

  CCANormalAbout({this.document});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final String category = document['Category'];
    final String description = document['Description'];
    final String email = document['Contact'];
    final String imageURL = document['Image'];

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

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.blue,
      width: 3.0,
    ),
    borderRadius: BorderRadius.all(
       Radius.circular(7.0)
    ),

  );
}

  Widget myWidget(String info) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(10.0),
      decoration: myBoxDecoration(), 
      child: Text(
        info,
        style: GoogleFonts.ptSans()
      ),
    );
}



  Widget helper() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            getWidget(),
            SizedBox(height: 5,),
            Text("Category", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(category),
            SizedBox(height: 6.0),
            Text("Description", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(description),
            SizedBox(height: 6.0),
            Text("Email and contact:", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(email),
            
          ],
        ),
      )
    );
  }

  

    return Scaffold(
      body: helper(),
    );
  }
}
