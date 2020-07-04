import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:orbital/screens/authetication/sign_in.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _name;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Sign Up!',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset("images/logo.png", fit: BoxFit.fill)),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please provide a username';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.account_box),
                ),
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an email';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                onSaved: (input) => _email = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.length < 8) {
                    return 'Longer password please';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.vpn_key),
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
              SizedBox(height: 10),
              CupertinoButton.filled(onPressed: signUp, child: Text('Sign Up')),
            ],
          ))),
    );
  }

  void createRecord(Firestore databaseReference, FirebaseUser user) async {
    await databaseReference.collection("User").document(user.uid).setData({
      'Email': _email,
      'Name': _name,
      'Favourite': <String>[],
      'BookmarkedEvent': <String>[],
      'DateJoined': DateTime.now()
    });
  }

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
  }

      void _successDialog() {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Success!"),
            content: new Text(
                "Sign up is sucessful! Will now redirect you to the login page"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              OutlineButton(
                  highlightedBorderColor: Colors.blue,
                  borderSide: BorderSide(color: Colors.blue),
                  child: new Text("ok"),
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

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        final databaseReference = Firestore.instance;
        createRecord(databaseReference, user);
        _successDialog();
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 5), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                title: Text('Sign in failed'),
                content:
                    Text("This email is being used! Please try another email."),
                actions: [
                  FlatButton(
                    onPressed: () =>
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/signUp', (Route<dynamic> route) => false);
                    }),
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }
}
