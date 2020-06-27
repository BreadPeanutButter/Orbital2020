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
          'SignUp!',
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Image.asset(
                "images/logo.png",
                height: 200,
                width: 200,
              ),
              TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Please provide a username';
                }
              },
              decoration: InputDecoration(
                labelText: 'Name'
              ),
              onSaved: (input) => _name = input,
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide an email';
                }
              },
              decoration: InputDecoration(
                labelText: 'Email'
              ),
              onSaved: (input) => _email = input,
            ),
            TextFormField(
              validator: (input) {
                if(input.length < 8){
                  return 'Longer password please';
                }
              },
              decoration: InputDecoration(
                labelText: 'Password'
              ),
              onSaved: (input) => _password = input,
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign up'),
            ),
          ],
        )
      ),
    );
  }

  void createRecord(Firestore databaseReference, FirebaseUser user) async {
    await databaseReference.collection("User")
        .document(user.uid)
        .setData({
          'Email': _email,
          'Name': _name,
          'Favourite': <String>[],
          'BookmarkedEvent': <String>[],
          'DateJoined': DateTime.now()
        });
  }

   void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(), fullscreenDialog: true));
  }

  void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        final databaseReference = Firestore.instance;
        createRecord(databaseReference, user);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  SignIn()));
      }catch(e){
        showDialog( 
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 5),(){
               Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Sign in failed'),
              content: Text("This email is being used! Please try another email."),
              actions: [
                FlatButton(
                  onPressed:  () => SchedulerBinding.instance.addPostFrameCallback((_) {
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