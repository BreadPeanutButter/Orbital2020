import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:orbital/cca/cca_admin_edit.dart';
import 'package:flutter/cupertino.dart';

class CCAAdminAbout extends StatelessWidget {
  final DocumentSnapshot document;
  int index;
  bool fromExplore = false;
  bool fromMyCCAs = false;

  CCAAdminAbout.fromExplore({this.document, this.index}) {
    fromExplore = true;
  }
  CCAAdminAbout.fromMyCCAs({this.document}) {
    fromMyCCAs = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final String name = document['Name'];
    final String category = document['Category'];
    final String description = document['Description'];
    final String email = document['Contact'];
    final String imageURL = document['image'];
    final df = new DateFormat('dd/MM/yyyy hh:mm');
    final date = df.format(document['DateJoined'].toDate());

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

    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 3.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      );
    }

    Widget myWidget(String info) {
      return Container(
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(),
        child: Text(info, style: GoogleFonts.ptSans()),
      );
    }

    Widget helper() {
      return Card(
          margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView(
              children: <Widget>[
                imageWidget(),
                SizedBox(
                  height: 5,
                ),
                Text("CCA",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(name),
                SizedBox(height: 20),
                Text("Category",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(category),
                SizedBox(height: 20.0),
                Text("Description",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(description),
                SizedBox(height: 20.0),
                Text("Email and contact",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget(email),
                SizedBox(
                  height: 20,
                ),
                Text("Created",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 7,
                ),
                myWidget("on " + date),
                SizedBox(
                  height: 50,
                ),
                RaisedButton.icon(
                  onPressed: () {
                    if (fromMyCCAs) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => CCAAdminEdit.fromMyCCAs(
                                    ccaDocument: document,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => CCAAdminEdit.fromExplore(
                                    ccaDocument: document,
                                    index: index,
                                  )));
                    }
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
      body: helper(),
    );
  }
}
