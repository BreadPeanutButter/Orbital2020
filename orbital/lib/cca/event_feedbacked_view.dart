import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EventFeedbackedView extends StatelessWidget {
  DocumentSnapshot feedbackDocument;

  EventFeedbackedView({@required this.feedbackDocument});

  static var rate = {
    0: "Extremely Dissatisfied",
    0.5: "Extremely Dissatisfied",
    1.0: "Extremely Dissatisfied",
    1.5: "Dissatisfied",
    2.0: "Dissatisfied",
    2.5: "Neutral",
    3.0: "Neutral",
    3.5: "Satisfied",
    4.0: "Satisfied",
    4.5: "Extremely Satisfied",
    5.0: "Extremely Satisfied"
  };

  BoxDecoration myBoxDecoration(Color color) {
    return BoxDecoration(
      border: Border.all(
        color: color,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(7.0)),
    );
  }

  Widget myWidget(String info) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(10.0),
      decoration: myBoxDecoration(Colors.blue),
      child: Text(info, style: GoogleFonts.ptSans(fontSize: 20)),
    );
  }

  Widget userWidget() {
    final bool anon = feedbackDocument['Anonymous'];
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(10.0),
      decoration: myBoxDecoration(Colors.blue),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              anon
                  ? Icon(FontAwesomeIcons.userSecret)
                  : Icon(FontAwesomeIcons.solidUser),
              SizedBox(
                width: 8,
              ),
              Text(feedbackDocument['Name'],
                  style: GoogleFonts.ptSans(fontSize: 20))
            ],
          ),
          Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.solidEnvelope),
              SizedBox(
                width: 8,
              ),
              Text(
                feedbackDocument['Email'],
                style: GoogleFonts.ptSans(
                    fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _ratingBar() {
    return Container(
        width: 340,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(Colors.blue),
        child: Column(children: [
          RatingBarIndicator(
            rating: feedbackDocument['Rating'],
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
          SizedBox(height: 5),
          Center(
              child: Column(children: [
            Text("${feedbackDocument['Rating']}/5.0",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text("${rate[feedbackDocument['Rating']]}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ])),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    String message =
        "You have already submitted feedback for ${feedbackDocument['Event']}. " +
            "We greatly appreciate your feedback and will strive to improve! " +
            "If you have anything else to add, please contact us through our official contact channels.";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.blue[700],
          icon: Icon(FontAwesomeIcons.times),
          iconSize: 35,
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text(
          'Feedback',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Card(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(shrinkWrap: true, children: <Widget>[
                SizedBox(height: 5),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      "images/feedback.jpg",
                      fit: BoxFit.fill,
                    )),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Text('Thank you for your feedback!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(15),
                    child: Text(message,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(height: 20),
                Text("User Info",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                userWidget(),
                SizedBox(
                  height: 20,
                ),
                Text("Rating",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                _ratingBar(),
                SizedBox(
                  height: 20,
                ),
                Text("Feedback",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(feedbackDocument['Comment'] == ""
                    ? "None"
                    : feedbackDocument['Comment']),
                SizedBox(
                  height: 20,
                ),
                Text("Date Submitted",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(feedbackDocument['DateTime']
                    .toDate()
                    .toString()
                    .substring(0, 16)),
                SizedBox(
                  height: 20,
                ),
              ]))),
    );
  }
}
