import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';

class EventFeedbackAdmin extends StatelessWidget {
  DocumentReference eventDocRef;
  DocumentSnapshot eventDocSnapshot;

  EventFeedbackAdmin(
      {@required this.eventDocRef, @required this.eventDocSnapshot});

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

  BoxDecoration myBoxDecoration(Color color) {
    return BoxDecoration(
      border: Border.all(
        color: color,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(7.0)),
    );
  }

  Widget _ratingBar() {
    var aveRating = eventDocSnapshot['totalFeedbackScore'] /
        eventDocSnapshot['totalFeedbackCount'];
    String satisfaction = aveRating <= 1.0
        ? "Extremely Dissatisfied"
        : aveRating <= 2.0
            ? "Dissatisfied"
            : aveRating <= 3.0
                ? "Neutral"
                : aveRating <= 4.0 ? "Satisfied" : "Extremely Satisfied";
    return Container(
        width: 340,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          RatingBarIndicator(
            rating: aveRating,
            itemSize: 50,
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Icon(
                    FontAwesomeIcons.angry,
                    color: Colors.red,
                  );
                case 1:
                  return Icon(
                    FontAwesomeIcons.frown,
                    color: Colors.redAccent,
                  );
                case 2:
                  return Icon(
                    FontAwesomeIcons.meh,
                    color: Colors.amber,
                  );
                case 3:
                  return Icon(
                    FontAwesomeIcons.smile,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return Icon(
                    FontAwesomeIcons.laughBeam,
                    color: Colors.green,
                  );
              }
            },
          ),
          SizedBox(height: 7),
          Text("$aveRating/5.0",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text("$satisfaction",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ]));
  }

  Widget expendableStats() {
    return ExpandableNotifier(
        initialExpanded: true,
        child: ExpandablePanel(
          header: Row(children: [
            Icon(
              FontAwesomeIcons.chartBar,
              size: 30,
            ),
            SizedBox(
              width: 12,
            ),
            Text("Statistics",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ]),
          collapsed: SizedBox(),
          expanded:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                "No. of respondents:\n  ${eventDocSnapshot['totalFeedbackCount']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text(
              "Mean satisfaction level:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _ratingBar()
          ]),
        ));
  }

  Widget expendableFeedback(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ExpandablePanel(
      header: Row(children: [
        Icon(
          FontAwesomeIcons.solidComments,
          size: 30,
        ),
        SizedBox(
          width: 14,
        ),
        Text("  Feedback",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      ]),
      collapsed: SizedBox(),
      expanded: ListView(
        shrinkWrap: true,
        children: snapshot.data.documents.map((DocumentSnapshot document) {
          return feedbackWidget(Text("${document['Comment']}"));
        }).toList(),
      ),
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
            return Card(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        expendableStats(),
                        SizedBox(
                          height: 40,
                        ),
                        expendableFeedback(snapshot)
                      ],
                    ))));
          }
        });
  }
}
