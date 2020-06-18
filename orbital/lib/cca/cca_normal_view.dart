import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/cca/cca_normal_about.dart';
import 'package:orbital/cca/cca_normal_eventlist.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class CCANormalView extends StatefulWidget {
  Auth auth;
  DocumentSnapshot document;
  bool favCCA;

  CCANormalView({@required this.document, @required this.auth});

  @override
  _CCANormalViewState createState() => _CCANormalViewState();
}

class _CCANormalViewState extends State<CCANormalView> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(widget.document['Name'],
                style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
              Ink(
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: CircleBorder(
                          side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ))),
                  child: FutureBuilder(
                      future:
                          widget.auth.isFavouriteCCA(widget.document['Name']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          widget.favCCA = snapshot.data;
                          return IconButton(
                            highlightColor: Colors.blue[900],
                            icon: Icon(Icons.star),
                            iconSize: 35,
                            onPressed: () {
                              if (widget.favCCA) {
                                widget.auth.removeFavouriteCCA(
                                    widget.document['Name']);
                              } else {
                                widget.auth
                                    .addFavouriteCCA(widget.document['Name']);
                              }
                              setState(() {
                                widget.favCCA = !widget.favCCA;
                              }); 
                            },
                            color: widget.favCCA ? Colors.orange : Colors.white,
                          );
                        }
                      }))
            ],
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
                document: widget.document,
              ),
              CCANormalEventlist(
                eventSubCollection:
                    widget.document.reference.collection('Event'),
              )
            ],
          ),
        ));
  }
}
