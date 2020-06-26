import 'package:flutter/material.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/cca/event_normal_view.dart';
import 'package:orbital/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EventFeedAll extends StatelessWidget {
  final database = Firestore.instance;
  Auth auth;

  EventFeedAll({@required this.auth});

  Widget closedEvent(DocumentSnapshot doc){
    if(doc['Closed'] == true){
      return Image.network(
        'https://firebasestorage.googleapis.com/v0/b/nus-whattodo.appspot.com/o/closed_event_image%2Fclosed-stamp-png.png?alt=media&token=c945c36e-b975-442a-94b6-5d91a39623b8'
      );
    }
    else{
      return null;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: database
          .collection('Event')
          .orderBy('DateCreated', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
                child: Text(
              'No events available ☹️',
              style: TextStyle(fontSize: 20),
            ));
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new SizedBox(
                    height: 100,
                    child: 
                    Card(shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        margin: EdgeInsets.all(3),
                        elevation: 3.0,
                        shadowColor: Colors.blue,
                        child: InkWell(
                            highlightColor: Colors.blueAccent,
                            onTap: () => goToEventPage(context, document),
                            child: ListTile(
                              title: new Text(
                                  document['CCA'] + ': ' + document['Name'],
                                  style: TextStyle(fontSize: 24)),
                              subtitle: new Text(document['EventTime'],
                                  style: TextStyle(fontSize: 20)),
                              leading: closedEvent(document),
                            ))));
              }).toList(),
            );
        }
      },
    );
  }

  void goToEventPage(BuildContext context, DocumentSnapshot document) async {
    bool userIsAdmin = await auth.isAdmin(document['CCA']);
    if (userIsAdmin) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventAdminView(
                    document: document,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventNormalView(
                    document: document,
                  )));
    }
  }
}
