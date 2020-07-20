import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/cca/event_feedback_form.dart';
import 'package:orbital/cca/event_feedbacked_view.dart';
import 'package:orbital/my_events/my_events.dart';
import 'package:orbital/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';

class EventNormalViewAnonymous extends StatefulWidget {
  final DocumentSnapshot document;
  EventNormalViewAnonymous({@required this.document});


  @override
  _EventNormalViewAnonymousState createState() => _EventNormalViewAnonymousState();
}

class _EventNormalViewAnonymousState extends State<EventNormalViewAnonymous> {

  @override
  Widget build(BuildContext context) {
    final String name = widget.document['Name'];
    final String details = widget.document['Details'];
    final String eventTime = widget.document['EventTime'];
    final String registrationInstructions =
        widget.document['RegisterInstructions'];
    final String location = widget.document['Location'];
    final String imageURL = widget.document['image'];

    Widget imageWidget() {
      if (imageURL == null) {
        return SizedBox(height: 20);
      } else {
        return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              imageURL,
              fit: BoxFit.fill,
            ));
      }
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

    Widget myWidgetClosing() {
      return Column(children: [
        SizedBox(height: 16),
        Container(
            height: 70,
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(4.0),
            decoration: myBoxDecoration(
              Colors.red[900],
            ),
            child: Row(children: <Widget>[
              Icon(FontAwesomeIcons.bullhorn, color: Colors.red[900], size: 28),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 6,
                  child: Text("  This Event is now closed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSans(
                          fontSize: 27,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w800))),
            ])),
        SizedBox(height: 15),
      ]);
    }

    Widget closedEvent(DocumentSnapshot doc) {
      if (doc['Closed'] == true) {
        return myWidgetClosing();
      } else {
        return SizedBox(height: 0);
      }
    }

    Widget myWidget(String info) {
      return Container(
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(Colors.blue),
        child: Text(info, style: GoogleFonts.ptSans(fontSize: 20)),
      );
    }

    Widget helper() {
      return Card(
          margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                imageWidget(),
                closedEvent(widget.document),
                SizedBox(
                  height: 15,
                ),
                Text("Event",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(name),
                SizedBox(
                  height: 20,
                ),
                Text("Details",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(details),
                SizedBox(height: 20.0),
                Text("Date and time",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(eventTime),
                SizedBox(height: 20.0),
                Text("Location",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(location),
                SizedBox(height: 20.0),
                Text("Sign up",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(registrationInstructions),
                SizedBox(height: 50.0),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ));
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
        )),
            
        body: helper()
        );
  }
}
