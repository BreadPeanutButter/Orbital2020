import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class EventFeedbackList extends StatelessWidget {
  DocumentReference eventDocRef;

  EventFeedbackList({@required this.eventDocRef});

  Widget feedbackWidget(Widget widget) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 3.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: eventDocRef.collection("Feedback").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.documents.isEmpty) {
            return new Center(
                child: Text(
              'No feedback available ☹️',
              style: TextStyle(fontSize: 30),
            ));
          } else {
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return feedbackWidget(Text("${document['Comment']}"));
              }).toList(),
            );
          }
        });
  }
}
