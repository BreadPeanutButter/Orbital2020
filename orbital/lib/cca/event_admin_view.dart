import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/event_admin_edit.dart';
import 'package:intl/intl.dart';

class EventAdminView extends StatelessWidget {
  final DocumentSnapshot document;

  EventAdminView({@required this.document});

  @override
  Widget build(BuildContext context) {
    final String name = document['Name'];
    final String details = document['Details'];
    final String eventTime = document['EventTime'];
    final String location = document['Location'];
    final String imageURL = document['image'];
    final String registrationInstructions = document['RegisterInstructions'];
    final String bookmarkCount = document['BookmarkCount'].toString();
    final String createdBy = document['CreatedBy'];
    final Timestamp dateCreated = document['DateCreated'];

    Widget imageWidget() {
      if (imageURL == null) {
        return SizedBox(height: 20);
      } else {
        return Image.network(
          imageURL,
          height: 200,
          width: 200,
        );
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
      return Container(
          margin: const EdgeInsets.all(1.0),
          padding: const EdgeInsets.all(8.0),
          decoration: myBoxDecoration(Colors.red),
          child: Row(children: <Widget>[
            Icon(FontAwesomeIcons.times, color: Colors.red, size: 28),
            Text("  This Event is now closed",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSans(fontSize: 25, color: Colors.red)),
          ]));
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
        decoration: myBoxDecoration(Colors.red),
        child: Text(info,
            style: GoogleFonts.ptSans(
              fontSize: 20,
            )),
      );
    }

    Widget helper(DocumentSnapshot document) {
      return Card(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                imageWidget(),
                closedEvent(document),
                SizedBox(
                  height: 5,
                ),
                Text("Name:",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(name),
                SizedBox(height: 20.0),
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
                Text("Location:",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(location),
                SizedBox(height: 20.0),
                Text("Sign up details",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(registrationInstructions),
                SizedBox(height: 20.0),
                Text("Bookmark Count",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(bookmarkCount),
                SizedBox(height: 20.0),
                Text("Created by and date created",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(createdBy + "\n" + dateCreated.toDate().toString()),
                SizedBox(height: 50),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) =>
                                EventAdminEdit(ccaDocument: document)));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  textColor: Colors.red,
                  splashColor: Colors.red,
                  color: Colors.green,
                ),
                CupertinoButton.filled(
                    onPressed: null, child: Text('Bookmark')),
              ],
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(document['Name'], style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: helper(document));
  }
}
