import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/event_admin_edit.dart';
import 'package:flushbar/flushbar.dart';

class EventAdminView extends StatefulWidget {
  Auth auth = new Auth();
  final DocumentSnapshot document;
  bool bookmarked;

  EventAdminView({@required this.document});

  @override
  _EventAdminViewState createState() => _EventAdminViewState();
}

class _EventAdminViewState extends State<EventAdminView> {
  void _flushBar(BuildContext context) {
    String ccaName = widget.document['CCA'];
    Flushbar(
      icon: !widget.bookmarked
          ? Icon(
              FontAwesomeIcons.grinAlt,
              color: Colors.white,
            )
          : Icon(FontAwesomeIcons.frown, color: Colors.white),
      title: !widget.bookmarked ? "Hooray!" : "Awww",
      message: !widget.bookmarked
          ? "You have added $ccaName to your Bookmarks"
          : "You have removed $ccaName from your Bookmarks",
      duration: Duration(seconds: 2),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.document['Name'];
    final String details = widget.document['Details'];
    final String eventTime = widget.document['EventTime'];
    final String location = widget.document['Location'];
    final String imageURL = widget.document['image'];
    final String registrationInstructions =
        widget.document['RegisterInstructions'];
    final String bookmarkCount = widget.document['BookmarkCount'].toString();
    final String createdBy = widget.document['CreatedBy'];
    final Timestamp dateCreated = widget.document['DateCreated'];

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
      return Column(children: [
        SizedBox(height: 8),
        Container(
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(8.0),
            decoration: myBoxDecoration(Colors.red[900]),
            child: Row(children: <Widget>[
              Icon(FontAwesomeIcons.bullhorn, color: Colors.red[900], size: 28),
              Text("  This Event is now closed.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(
                      fontSize: 25,
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold)),
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
              shrinkWrap: true,
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
                myWidget(createdBy + '\n' + dateCreated.toDate().toString().substring(0,10)),
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
              ],
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(name, style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            Ink(
                decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(
                        side: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ))),
                child: FutureBuilder(
                    future: widget.auth
                        .isBookmarkedEvent(widget.document.documentID),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        widget.bookmarked = snapshot.data;
                        return IconButton(
                          highlightColor: Colors.red[700],
                          icon: Icon(Icons.bookmark),
                          iconSize: 35,
                          onPressed: () {
                            _flushBar(context);
                            if (widget.bookmarked) {
                              widget.auth
                                  .unbookmarkEvent(widget.document.documentID);
                            } else {
                              widget.auth
                                  .bookmarkEvent(widget.document.documentID);
                            }
                            setState(() {
                              widget.bookmarked = !widget.bookmarked;
                            });
                          },
                          color:
                              widget.bookmarked ? Colors.orange : Colors.white,
                        );
                      }
                    }))
          ],
        ),
        body: helper(widget.document));
  }
}
