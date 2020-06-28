import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  signOut() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

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
        resetEmail(widget.auth.email);
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

  Widget actionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Logout"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  signOut();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.blue[500],
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
      child: Text(info,
          style: GoogleFonts.ptSans(fontSize: 25, color: Colors.blue[1000])),
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
    String name = 'Name: ' + widget.auth.name;
    String email = 'Email: ' + widget.auth.email;
    String dateJoined = 'Date joined: ' + widget.auth.dateJoined.substring(0,10);
    return new Scaffold(
        appBar: new AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        drawer: AppDrawer(drawer: Drawers.profile),
        body: new Align(
          alignment: Alignment.center,
            child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Row(
              children: [
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
              )
            ]),
            SizedBox(height: 30),
            myLayoutName(myWidget(name)),
            SizedBox(height: 20),
            myLayoutWidget(myWidget(email)),
            SizedBox(height: 20),
            myLayoutWidget(myWidget(dateJoined)),
            actionButtons()
          ],
        )));
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
