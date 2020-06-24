import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/cca/cca_admin_about.dart';
import 'package:orbital/cca/cca_admin_eventlist.dart';
import 'package:orbital/cca/cca_admin_panel.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class CCAAdminView extends StatefulWidget {
  Auth auth = new Auth();
  DocumentSnapshot document;
  bool favCCA;

  CCAAdminView({@required this.document});

  @override
  _CCAAdminViewState createState() => _CCAAdminViewState();
}

class _CCAAdminViewState extends State<CCAAdminView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _snackBar() {
    String ccaName = widget.document['Name'];
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 2),
      content: Text(
        !widget.favCCA
            ? "You have added $ccaName to your Favourites"
            : "You have removed $ccaName from your Favourites",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(widget.document['Name'],
                style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
              Ink(
                  decoration: ShapeDecoration(
                      color: Colors.red,
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
                              _snackBar();
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
                Tab(
                  icon: Icon(Icons.person),
                  child: Text("Admin"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CCAAdminAbout(
                document: widget.document,
              ),
              CCAAdminEventlist(
                ccaDocument: widget.document
              ),
              CCAAdminPanel(ccaName: widget.document['Name'])
            ],
          ),
        ));
  }
}
