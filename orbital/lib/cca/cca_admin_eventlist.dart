import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/cca/create_event.dart';

class CCAAdminEventlist extends StatelessWidget {
  final database = Firestore.instance;
  DocumentSnapshot ccaDocument;
  int index;

  CCAAdminEventlist({@required this.ccaDocument, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      publishButton(context),
      eventList(),
    ]);
  }

  Widget publishButton(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(8),
      child: CupertinoButton.filled(
        child: Row(children: [
          Icon(Icons.add),
          SizedBox(
            width: 10,
          ),
          Text('Create Event'),
        ]),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEvent(
                      ccaDocument: ccaDocument,
                    ))),
      ),
    );
  }

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

  Widget eventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: database
          .collection('Event')
          .where("CCA", isEqualTo: ccaDocument['Name'])
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
          return new Expanded(
              child: ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              String eventTime = document['EventTime'];
              return new SizedBox(
                  height: 100,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[600], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      margin: EdgeInsets.all(3),
                      elevation: 1.0,
                      shadowColor: Colors.blue,
                      child: InkWell(
                          highlightColor: Colors.blueAccent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventAdminView.fromCCA(
                                            document: document, index: index)));
                          },
                          child: ListTile(
                            title: new Text(
                                document['CCA'] + ': ' + document['Name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 22)),
                            subtitle: new Text(eventTime,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20)),
                            trailing: closedEvent(document),
                          ))));
            }).toList(),
          ));
        }
      },
    );
  }
}
