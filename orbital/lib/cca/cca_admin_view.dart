import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/cca/cca_normal_about.dart';
import 'package:orbital/cca/cca_normal_eventlist.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class CCAAdminView extends StatelessWidget {
  final DocumentSnapshot document;

  CCAAdminView({@required this.document});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            title:
                Text(document['Name'], style: TextStyle(color: Colors.black)),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 22.0),
              indicatorColor: Colors.amber[700],
              indicatorWeight: 4.0,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[50],
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.star),
                  child: Text("About"),
                ),
                Tab(
                  icon: Icon(Icons.whatshot),
                  child: Text("Events"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CCANormalAbout(
                document: document,
              ),
              CCANormalEventlist(
                eventSubCollection: document.reference.collection('Event'),
              )
            ],
          ),
        ));
  }
}
