import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:orbital/services/auth.dart';

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

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Profile!',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: new Center(
        child : Column(
        children: <Widget>[
          Image.asset(
                "images/logo.png",
                height: 200,
                width: 200,
              ),
          SizedBox(height: 40),
          Text('Name: ' + widget.auth.name, style: TextStyle(fontSize: 20,  height: 1.2 )),
          SizedBox(height: 20),
          Text('Email: ' + widget.auth.email, style: TextStyle(fontSize: 15)),
          SizedBox(height: 20),
          new RaisedButton(
          onPressed: () => signOut(),
          child: new Text(
            "Logout",
          )),
          new RaisedButton(
          onPressed: null,
          child: new Text(
            "Change password",
          ))
          ],
          
    )));
    
  }

  
  

  
 
}