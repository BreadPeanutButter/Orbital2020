import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CCAAdminPanel extends StatefulWidget {
  final database = Firestore.instance;
  final String ccaName;
  DocumentReference docRef;
  DocumentSnapshot docSnapshot;

  CCAAdminPanel({@required this.ccaName}) {
    docRef = database.collection('CCA').document(ccaName);
  }

  @override
  _CCAAdminPanelState createState() => _CCAAdminPanelState();
}

class _CCAAdminPanelState extends State<CCAAdminPanel> {
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.red[200],
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
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
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
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
                    }),
              ],
            );
          }
        });
  }
}
