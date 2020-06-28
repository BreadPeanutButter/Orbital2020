import 'package:flutter/material.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/cca/event_normal_view.dart';
import 'package:orbital/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EventFeedCategory extends StatelessWidget {
  final database = Firestore.instance;
  final String category;
  Auth auth;
  static const index = {
    "Academic": 1,
    "Adventure": 2,
    "Arts": 3,
    "Cultural": 4,
    "Health": 5,
    "Social Cause": 6,
    "Specialist": 7,
    "Sports": 8,
    "Technology": 9
  };

  EventFeedCategory({@required this.auth, @required this.category});

  Widget closedEvent(DocumentSnapshot doc) {
    if (doc['Closed'] == true) {
      return Image.asset(
        "images/closed.png",
        height: 100,
        width: 100,
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: database
            .collection('Event')
            .where("Category", isEqualTo: category)
            .orderBy('Closed')
            .orderBy('DateCreated', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.documents.isEmpty) {
            return new Center(
                child: Text(
              'No events available ☹️',
              style: TextStyle(fontSize: 30),
            ));
          } else {
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
                            onTap: () => goToEventPage(context, document),
                            child: ListTile(
                              title: new Text(
                                  document['CCA'] + ': ' + document['Name'],
                                  style: TextStyle(fontSize: 24)),
                              subtitle: new Text(document['EventTime'],
                                  style: TextStyle(fontSize: 20)),
                              trailing: closedEvent(document),
                            ))));
              }).toList(),
            );
          }
        });
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
              builder: (context) => EventNormalView.fromFeed(
                    document: document,
                    index: index[document['Category']],
                  )));
    }
  }
}
