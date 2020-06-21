
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class EventNormalView extends StatelessWidget {
  final DocumentSnapshot document;

  EventNormalView({@required this.document});

  @override
  Widget build(BuildContext context) {
    final String name = document['Name'];
    final String details = document['Details'];
    final String eventDate = document['EventDate'];
    final String eventTime = document['EventTime'];
    final String location = document['Location'];
    final String imageURL = document['Image'];

    Widget imageWidget(){
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
        color: Colors.red,
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
            imageWidget(),
            SizedBox(height: 5,),
            Text("Details", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(details),
            SizedBox(height: 6.0),
            Text("Date and time", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(eventDate + eventTime),
            SizedBox(height: 6.0),
            Text("Location:", style:  TextStyle(fontSize: 20, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(location),
            SizedBox(height: 50),
            CupertinoButton.filled(onPressed: null, child: Text('Bookmark')),
            
          ],
        ),
      )
    );
  }
    
    return Scaffold(
        appBar: AppBar(
          title: Text(name, style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: helper());
  }
}
