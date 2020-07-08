import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/services/auth.dart';

class EventFeedbackForm extends StatefulWidget {
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
  double _rating = 3;
  bool _anon = false;

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
          Text("How satisfied are you with ${widget.eventDocument['Name']}?",
              style: TextStyle(
                fontSize: 18,
              )),
          SizedBox(height: 10),
          RatingBar(
            glow: true,
            itemSize: 50,
            allowHalfRating: true,
            initialRating: 3,
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
              child: Text("$_rating/5.0",
                  style: TextStyle(
                    fontSize: 18,
                  ))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    String message =
        'Your feedback will only be seen by Admins of ${widget.eventDocument['CCA']}.\n' +
            'Do not hesistate to be honest with us!\n' +
            'You can choose to give your feedback anonymously or otherwise. ' +
            'If you submit anonymously, your name and email will be hidden.';

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.blue[700],
            icon: Icon(FontAwesomeIcons.times),
            iconSize: 35,
            onPressed: _showDialog,
            color: Colors.white,
          ),
          title: Text('Event Feedback'),
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
              padding: EdgeInsets.all(8),
              child: CupertinoButton.filled(
                child: Text('Submit'),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 30),
          ])),
        ));
  }
}
