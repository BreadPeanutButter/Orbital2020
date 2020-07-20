import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orbital/services/auth.dart';
import 'app_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  Auth auth;
  Profile({@required this.auth});

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
    final GoogleSignIn googleSignIn = GoogleSignIn();

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset password"),
      content: Text(
          "Would you like to reset your password? An email will be sent to you after you press continue."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future resetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  route(Auth auth) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Profile(
                  auth: auth,
                )));
  }

  startTime(Auth auth) async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route(auth));
  }

  CreateAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit name"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                elevation: 5,
                child: Text("Submit"),
                onPressed: () {
                  widget.auth.editName(customController.text.toString());
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/eventfeed');
                  Auth auth = new Auth();
                  startTime(auth);
                },
              )
            ],
          );
        });
  }


  void _successDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content:
              new Text("You have logout from your account"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Ok"),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  });
                }),

            SizedBox(width: 110),
          ],
        );
      },
    );
  }

  Widget actionButtons(bool googleSignedIn) {
    if(googleSignedIn != true){
      return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Container(
                    child: new RaisedButton(
                  child: new Text("Change password"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                )),
              ),
              flex: 2,
            ),
          ],
        ),
      );
    }

    else{
      return SizedBox();
    }

  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.blue[500],
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(7.0)),
    );
  }

  Widget myWidgetName(String info) {
    return Container(
      width: 500,
      //margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.user,
            color: Colors.blue[600],
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Text(
                info,
                style: GoogleFonts.ptSans(fontSize: 23, color: Colors.black),
                softWrap: true,
              )),
          new Spacer(
            flex: 1,
          ),
          FlatButton.icon(
              onPressed: () => CreateAlertDialog(context),
              icon: Icon(FontAwesomeIcons.edit),
              label: Text("Edit")),
        ],
      ),
    );
  }

  Widget myWidgetDate(String info) {
    return Container(
      width: 500,
      //margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.calendarAlt,
            color: Colors.blue[600],
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Text(info,
                  style:
                      GoogleFonts.ptSans(fontSize: 23, color: Colors.black))),
        ],
      ),
    );
  }

  Widget myWidgetEmail(String info) {
    return Container(
      width: 500,
      //margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.envelope,
            color: Colors.blue[600],
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(
              child: Text(info,
                  style:
                      GoogleFonts.ptSans(fontSize: 23, color: Colors.black))),
        ],
      ),
    );
  }

  Widget myLayoutWidget(Widget widget) {
    return Align(
      alignment: Alignment(-0.8, -0.8),
      child: widget,
    );
  }

  Widget myLayoutName(Widget widget) {
    return Align(
      alignment: Alignment(-0.85, -0.85),
      child: widget,
    );
  }

  Widget profileWidget() {
    String name = widget.auth.name;
    String email = widget.auth.email;
    String dateJoined = 'Joined ' + widget.auth.dateJoined;
    bool googleSignedIn = widget.auth.googleSignedIn;
    return new Scaffold(
        appBar: new AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        drawer: AppDrawer(drawer: Drawers.profile),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 15),
            SizedBox(
              width: 70,
            ),
            Icon(
              FontAwesomeIcons.solidIdCard,
              color: Colors.black,
              size: 230,
            ),
            SizedBox(
              width: 1,
            ),
            SizedBox(height: 30),
            myLayoutName(myWidgetName(name)),
            SizedBox(height: 20),
            myLayoutWidget(myWidgetEmail(email)),
            SizedBox(height: 25),
            myLayoutWidget(myWidgetDate(dateJoined)),
            actionButtons(googleSignedIn),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auth.name.isEmpty || widget.auth.email.isEmpty) {
      return FutureBuilder(
          future: widget.auth.getCurrentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return profileWidget();
            }
          });
    } else {
      return profileWidget();
    }
  }
}
