import 'package:flutter/material.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/cca/event_normal_view.dart';
import 'package:orbital/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../app_drawer.dart';

class EventFeed extends StatelessWidget {
  final database = Firestore.instance;
  Auth auth = new Auth();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text('Event Feed', style: TextStyle(color: Colors.black)),
            centerTitle: true),
        drawer: AppDrawer(drawer: Drawers.eventfeed),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              database.collection('Event').orderBy('DateCreated', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('No Events Available ☹️');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new SizedBox(
                        height: 100,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                side: new BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(4.0)),
                            margin: EdgeInsets.all(3),
                            elevation: 3.0,
                            shadowColor: Colors.blue,
                            child: InkWell(
                                highlightColor: Colors.blueAccent,
                                onTap: () => goToEventPage(context, document),
                                child: ListTile(
                                  title: new Text(document['CCA']  + ': ' + document['Name'],
                                      style: TextStyle(fontSize: 24)),
                                  subtitle: new Text(document['EventTime'],
                                      style: TextStyle(fontSize: 20)),
                                ))));
                  }).toList(),
                );
            }
          },
        ));
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
