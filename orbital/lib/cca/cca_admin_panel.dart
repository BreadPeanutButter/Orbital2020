import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orbital/services/auth.dart';
import 'package:flushbar/flushbar.dart';
import 'cca_admin_add.dart';

class CCAAdminPanel extends StatefulWidget {
  final database = Firestore.instance;
  final String ccaName;
  Auth auth;
  DocumentReference docRef;
  int previousIndex;

  CCAAdminPanel(
      {@required this.ccaName,
      @required this.auth,
      @required this.previousIndex}) {
    docRef = database.collection('CCA').document(ccaName);
  }

  @override
  _CCAAdminPanelState createState() => _CCAAdminPanelState();
}

class _CCAAdminPanelState extends State<CCAAdminPanel> {
  void _flushBar(BuildContext context) {
    Flushbar(
      icon: Icon(FontAwesomeIcons.times, color: Colors.white),
      title: 'Oops! Prohibited Action',
      message: 'You cannot remove yourself as Admin.',
      duration: Duration(seconds: 2),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      addAdminButton(context),
      Container(
          padding: EdgeInsets.all(8),
          child: Text("Delete an Admin by swiping left on the card.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
        height: 8,
      ),
      adminList()
    ]);
  }

  Widget adminList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.database
          .collection('User')
          .where("AdminOf", arrayContains: widget.docRef.documentID)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.documents.isEmpty) {
          return new Center(
              child: Text(
            'No admins available ☹️',
            style: TextStyle(fontSize: 30),
          ));
        } else {
          return new Expanded(
              child: ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return _getSlidable(document.documentID);
            }).toList(),
          ));
        }
      },
    );
  }

  Widget addAdminButton(BuildContext context) {
    return Container(
        width: 280,
        padding: EdgeInsets.all(8),
        child: CupertinoButton.filled(
          child: Row(children: [
            Icon(Icons.add),
            SizedBox(
              width: 10,
            ),
            Text('Add Admin'),
          ]),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CCAAdminAdd(
                          ccaName: widget.ccaName,
                          docRef: widget.docRef,
                          previousIndex: widget.previousIndex,
                        )));
          },
        ));
  }

  Widget _getSlidable(String adminID) {
    return FutureBuilder(
        future: widget.database.collection('User').document(adminID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                height: 90,
                child: ListTile(
                  title: Text(
                    snapshot.data['Name'],
                    style: TextStyle(fontSize: 23),
                  ),
                  subtitle: Text(snapshot.data['Email'],
                      style: TextStyle(fontSize: 19)),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                    caption: 'Delete',
                    color:
                        widget.auth.uid != adminID ? Colors.red : Colors.grey,
                    icon: Icons.delete,
                    onTap: () {
                      if (adminID == widget.auth.uid) {
                        _flushBar(context);
                      } else {
                        _deleteDialog(snapshot.data['Name'], adminID);
                      }
                    }),
              ],
            );
          }
        });
  }

  void _deleteDialog(String name, String adminID) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation: Delete Admin"),
          content: new Text(
              "Would you like to remove $name as Admin of ${widget.ccaName}?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.database
                    .collection('User')
                    .document(adminID)
                    .updateData({
                  "AdminOf": FieldValue.arrayRemove([widget.docRef.documentID])
                });
              },
            ),
          ],
        );
      },
    );
  }
}
