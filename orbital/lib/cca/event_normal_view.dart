
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class EventNormalView extends StatelessWidget {
  final DocumentSnapshot document;
  bool closed;

  EventNormalView({@required this.document});

  @override
  Widget build(BuildContext context) {
    final String name = document['Name'];
    final String details = document['Details'];
    final String eventTime = document['EventTime'];
    final String location = document['Location'];
    final String imageURL = document['image'];
    final bool closed = document['Closed'];

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

    

  BoxDecoration myBoxDecoration(Color colour) {
    return BoxDecoration(
      border: Border.all(
        color: colour,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(7.0)
      ),

    );
 }

  Widget myWidgetClosing() {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(8.0),
      decoration: myBoxDecoration(Colors.green), 
      child: Text(
        "This Event is now closed",
        textAlign: TextAlign.center,
        style: GoogleFonts.ptSans(fontSize: 25, color: Colors.green)
      ),
    );
  }

  Widget closedEvent(DocumentSnapshot doc){
    if(doc['Closed'] == true){
      return myWidgetClosing();
    }
    else{
      return SizedBox(height: 0,);
    }
  }

  Widget myWidget(String info) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(10.0),
      decoration: myBoxDecoration(Colors.blue), 
      child: Text(
        info,
        style: GoogleFonts.ptSans(fontSize: 20)
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
            closedEvent(document),
            SizedBox(height: 5,),
            Text("Details", style:  TextStyle(fontSize: 18, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(details),
            SizedBox(height: 20.0),
            Text("Date and time", style:  TextStyle(fontSize: 18, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),
            myWidget(eventTime),
            SizedBox(height: 20.0),
            Text("Location:", style:  TextStyle(fontSize: 18, fontStyle:  FontStyle.italic, fontWeight: FontWeight.bold)),
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
