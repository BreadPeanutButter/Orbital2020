import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orbital/services/auth.dart';

class CCAAdminPanel extends StatefulWidget {
  final database = Firestore.instance;
  final String ccaName;
  Auth auth;
  DocumentReference docRef;
  DocumentSnapshot docSnapshot;

  CCAAdminPanel(
      {@required this.ccaName, @required this.auth}) {
    docRef = database.collection('CCA').document(ccaName);
  }

  @override
  _CCAAdminPanelState createState() => _CCAAdminPanelState();
}

class _CCAAdminPanelState extends State<CCAAdminPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      addAdminButton(context),
      FutureBuilder(
          future: widget.docRef.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              widget.docSnapshot = snapshot.data;
              return Center(
                child: OrientationBuilder(
                  builder: (context, orientation) => _buildList(context),
                ),
              );
            }
          })
    ]);
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
          onPressed: () => null,
        ));
  }

  Widget _buildList(BuildContext context) {
    List adminList = List.from(widget.docSnapshot['Admin']);
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _getSlidable(adminList[index], index);
      },
      itemCount: adminList.length,
    );
  }

  Widget _getSlidable(String adminID, int index) {
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
                    color: Colors.red[200],
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                height: 90,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigoAccent,
                    child: Text('${index + 1}'),
                    foregroundColor: Colors.white,
                  ),
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
                      _deleteDialog(snapshot.data['Name'], adminID);
                    }),
              ],
            );
          }
        });
  }

  void _deleteDialog(String name, String adminID) {
    // flutter defined function
    if (adminID == widget.auth.uid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Restricted Action"),
            content: new Text("You cannot delete yourself as Admin."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        },
      );
    } else {
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
                      .collection('CCA')
                      .document(widget.ccaName)
                      .updateData({
                    "Admin": FieldValue.arrayRemove([adminID])
                  });
                  DocumentSnapshot snap = await widget.docRef.get();
                  setState(() {
                    widget.docSnapshot = snap;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
}
