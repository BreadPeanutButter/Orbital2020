import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/screens/authetication/sign_up.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Welcome!',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset("images/logo.png", fit: BoxFit.fill)),
              SizedBox(height: 30),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an email';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    icon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                onSaved: (input) => _email = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide a password';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.vpn_key),
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: 400,
                  child: Column(children: [
                    SizedBox(
                        width: 290,
                        height: 55,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          color: Colors.blue,
                          onPressed: _signIn,
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 22),
                          ),
                        )),
                    SizedBox(height: 20),
                    SizedBox(
                        height: 55,
                        width: 290,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: Colors.blue,
                            onPressed: navigateToSignUp,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 22),
                            ))),
                    SizedBox(height: 20),
                    SizedBox(
                        width: 290,
                        height: 55,
                        child: OutlineButton(
                          splashColor: Colors.grey,
                          onPressed: () async {
                            await loginWithGoogle();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          highlightElevation: 0,
                          borderSide: BorderSide(color: Colors.grey[600]),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/google_logo.png",
                                    height: 33,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.grey[700],
                                        )),
                                  ),
                                ]),
                          ),
                        )),
                    SizedBox(height: 20),
                    SizedBox(
                        height: 55,
                        width: 290,
                        child: FlatButton.icon(
                          icon: Icon(FontAwesomeIcons.userSecret),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          color: Colors.blue,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/exploreanonymous'),
                          label: Text(
                            'Guest Sign In',
                            style: TextStyle(fontSize: 22),
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    )
                  ]))
            ],
          )),
    );
  }

  Future signInAnonymously() {
    return _auth.signInAnonymously();
  }

  void createRecord(Firestore databaseReference, FirebaseUser user) async {
    await databaseReference.collection("User").document(user.uid).setData({
      'Email': user.email,
      'Name': user.displayName,
      'Favourite': <String>[],
      'BookmarkedEvent': <String>[],
      'DateJoined': DateTime.now(),
      'AdminOf': <String>[],
      'googleSignedIn': true
    });
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) return false;
      AuthResult res =
          await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      final snapShot =
          await databaseReference.collection("User").document(user.uid).get();
      if (!snapShot.exists) {
        createRecord(databaseReference, user);
        Navigator.pushNamed(context, '/explore');
      } else {
        Navigator.pushNamed(context, '/explore');
      }

      if (res.user == null) return false;
      return true;
    } catch (e) {
      print(e.message);
      print("Error signing in with google");
      return false;
    }
  }

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
  }

  void _signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushNamed(context, '/explore');
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Text('Incorrect email or password. \nTry again.'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _formKey.currentState.reset();
                          FocusScope.of(context).unfocus();
                        })
                  ]);
            });
      }
    }
  }
}
