import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/anonymous/cca/cca_normal_eventlist_anonymous.dart';
import 'package:orbital/cca/cca_normal_about.dart';
import 'package:orbital/cca/cca_normal_eventlist.dart';
import 'package:orbital/favourites/favourites.dart';
import 'package:orbital/services/auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

class CCANormalViewAnonymous extends StatefulWidget {
  DocumentSnapshot document;


  CCANormalViewAnonymous({@required this.document});

  @override
  _CCANormalViewState createState() => _CCANormalViewState();
}

class _CCANormalViewState extends State<CCANormalViewAnonymous> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(widget.document['Name'],
                style: TextStyle(color: Colors.black)),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 22.0),
              indicatorColor: Colors.amber[700],
              indicatorWeight: 4.0,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[50],
              tabs: <Widget>[
                Tab(
                  icon: Icon(FontAwesomeIcons.infoCircle),
                  child: Text("About"),
                ),
                Tab(
                  icon: Icon(Icons.event),
                  child: Text("Events"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CCANormalAbout(
                document: widget.document,
              ),
              CCANormalEventlistAnonymous(
                ccaDocument: widget.document,
              )
            ],
          ),
        ));
  }
}
