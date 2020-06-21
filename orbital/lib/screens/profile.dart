import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
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
  
  signOut() async{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                      });

  } 

    showAlertDialog(BuildContext context) {
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {Navigator.of(context).pop();},
      );
      Widget continueButton = FlatButton(
        child: Text("Continue"),
        onPressed:  () {
          resetEmail(widget.auth.email);
        SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                      });
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Reset password"),
        content: Text("Would you like to reset your password? An email will be sent to you after you press continue."),
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

  Future resetEmail(String email) async{
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  void initState() {
    super.initState();
  }

    Widget actionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(drawer: Drawers.profile),
      body: new Center(
        child : Column(
        children: <Widget>[
          Image.asset(
                "images/logo.png",
                height: 250,
                width: 250,
              ),
          SizedBox(height: 40),
          Text('Name: ' + widget.auth.name, style: GoogleFonts.sriracha( textStyle: TextStyle(color: Colors.blue, letterSpacing: .5,fontSize: 25))),
          SizedBox(height: 20),
          Text('Email: ' + widget.auth.email, style: GoogleFonts.sriracha( textStyle: TextStyle(color: Colors.blue, letterSpacing: .5,fontSize: 30))),
          SizedBox(height: 20),
          actionButtons()
        ],
          
    )));
    
  }

  
  

  
 
}