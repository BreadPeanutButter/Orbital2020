import 'dart:math';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/services/auth.dart';
import 'package:flushbar/flushbar.dart';

class EventFeedbackForm extends StatefulWidget {
  final db = Firestore.instance;
  Auth auth;
  DocumentSnapshot eventDocument;

  EventFeedbackForm({@required this.eventDocument, @required this.auth});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventFeedbackFormState();
  }
}

class _EventFeedbackFormState extends State<EventFeedbackForm> {
  final GlobalKey<FormState> _key = GlobalKey();
  String _feedback = "";
  double _rating = 5;
  bool _anon = false;
  static const anonNames = [
    "Tiger",
    "Apple",
    "Durian",
    "Buffalo",
    "Alligator",
    "Lizard",
    "Flower",
    "Penguin",
    "Sandwich",
    "Hamburger",
    "Poodle",
    "Turkey",
    "Chicken",
    "Cookie",
    "Corgi",
    "Otter",
    "Shrub",
    "Cherry",
    "Jedi",
    "Sith Lord"
  ];

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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Close this page"),
          content: new Text(
              "Your feedback will not be saved. Do you still want to close this page?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        );
      },
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
    return Container(
        width: 340,
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(Colors.blue),
        child: Column(children: [
          Text(
              "How satisfied are you with ${widget.eventDocument['Name']} overall?",
              style: TextStyle(
                fontSize: 18,
              )),
          SizedBox(height: 10),
          RatingBar(
            glow: true,
            itemSize: 50,
            allowHalfRating: true,
            initialRating: 5,
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
            onRatingUpdate: (rating) {
              setState(() => _rating = rating);
            },
          ),
          SizedBox(height: 5),
          Center(
              child: Column(children: [
            Text("$_rating/5.0",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text("${rate[_rating]}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ])),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    String message =
        'Your feedback for ${widget.eventDocument['Name']} will only be seen by Admins of ${widget.eventDocument['CCA']}.\n' +
            'Do not hesistate to be honest with us!\n' +
            'You can choose to give your feedback anonymously. ' +
            'If you submit anonymously, your name and email will be hidden.\n' +
            'You can only submit one feedback per event.';

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.blue[700],
            icon: Icon(FontAwesomeIcons.times),
            iconSize: 35,
            onPressed: _showDialog,
            color: Colors.white,
          ),
          title: Text(
            'Feedback',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Form(
          autovalidate: true,
          key: _key,
          child: SingleChildScrollView(
              child: Column(children: [
            SizedBox(height: 5),
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  "images/feedback.jpg",
                  fit: BoxFit.fill,
                )),
            Container(
                padding: EdgeInsets.all(8),
                child: Text('Help us make our events better!',
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
            _ratingBar(),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Feedback (optional)',
                    hintText:
                        'What did you like about the event?\nHow could we have done better?',
                  ),
                  onSaved: (input) => _feedback = input,
                )),
            SizedBox(height: 30),
            Container(
                width: 340,
                child: CheckboxListTile(
                  value: _anon,
                  onChanged: (val) => setState(() => _anon = !_anon),
                  activeColor: Colors.blue,
                  title: Text(
                    "Go Anonymous",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "Put on a disguise",
                    style: TextStyle(fontSize: 16),
                  ),
                  secondary: _anon
                      ? Icon(
                          FontAwesomeIcons.userSecret,
                          color: Colors.black,
                          size: 40,
                        )
                      : Icon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                          size: 40,
                        ),
                )),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(8),
              child: CupertinoButton.filled(
                child: Text('Submit'),
                onPressed: submitAlert,
              ),
            ),
            SizedBox(height: 30),
          ])),
        ));
  }

  void _submitFlushBar(BuildContext context) {
    String eventName = widget.eventDocument['Name'];
    Flushbar(
      icon: Icon(FontAwesomeIcons.grinAlt, color: Colors.white),
      title: "Thank you!",
      message: "You submitted feedback for $eventName.",
      duration: Duration(seconds: 3),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(context);
  }

  void submitAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Submit Feedback"),
          content: new Text("Are you ready to submit your feedback?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  submitFeedback();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _submitFlushBar(context);
                }),
          ],
        );
      },
    );
  }

  void submitFeedback() {
    _key.currentState.save();
    DocumentReference ref = widget.eventDocument.reference;
    ref.collection("Feedback").document(widget.auth.uid).setData({
      "Event": widget.eventDocument['Name'],
      "Rating": _rating,
      "Comment": _feedback,
      "DateTime": DateTime.now(),
      "Name": _anon
          ? "Anonymous " + anonNames[Random().nextInt(20)]
          : widget.auth.name,
      "Email":
          _anon ? "Some things are best kept secret..." : widget.auth.email,
      "Anonymous": _anon
    });

    if (!widget.eventDocument.data.containsKey("totalFeedbackCount")) {
      ref.updateData({
        "totalFeedbackCount": 0,
        "totalFeedbackScore": 0,
        "feedbackED": 0,
        "feedbackD": 0,
        "feedbackN": 0,
        "feedbackS": 0,
        "feedbackES": 0,
      });
    }

    ref.updateData({
      "totalFeedbackCount": FieldValue.increment(1),
      "totalFeedbackScore": FieldValue.increment(_rating),
      "feedbackED": //Extremely Dissatisfied
          _rating <= 1.0 ? FieldValue.increment(1) : FieldValue.increment(0),
      "feedbackD": _rating > 1.0 && _rating <= 2.0 //Dissatisfied
          ? FieldValue.increment(1)
          : FieldValue.increment(0),
      "feedbackN": _rating > 2.0 && _rating <= 3.0 //Neutral
          ? FieldValue.increment(1)
          : FieldValue.increment(0),
      "feedbackS": _rating > 3.0 && _rating <= 4.0 //Satisfied
          ? FieldValue.increment(1)
          : FieldValue.increment(0),
      "feedbackES": _rating > 4.0 && _rating <= 5.0 //Extremely Satisfied
          ? FieldValue.increment(1)
          : FieldValue.increment(0),
    });
  }
}
