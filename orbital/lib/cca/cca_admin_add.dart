import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cca_admin_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';

class CCAAdminAdd extends StatefulWidget {
  final userCollection = Firestore.instance.collection('User');
  final String ccaName;
  DocumentReference docRef;
  DocumentSnapshot docSnapshot;

  CCAAdminAdd({@required this.ccaName, @required this.docRef});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CCAAdminAddState();
  }
}

class _CCAAdminAddState extends State<CCAAdminAdd> {
  String _email;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final message = "Making a user an Admin will give that user special access to the ${widget.ccaName} page." +
        " Admins can edit page content, create events and edit events among other privileges." +
        " Only add users that are members of the ${widget.ccaName} CCA and who were given approval by the CCA in-charge.\n\n\n" +
        "Enter the email of a user to make the user an admin of ${widget.ccaName}.";
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.blue[700],
            icon: Icon(FontAwesomeIcons.times),
            iconSize: 35,
            onPressed: () async {
              DocumentSnapshot document = await widget.docRef.get();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CCAAdminView.tab(
                            document: document,
                            index: 2,
                          )));
            },
            color: Colors.white,
          ),
          title: Text('Add Admin'),
          centerTitle: true,
        ),
        body: Form(
            autovalidate: true,
            key: _key,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Image.asset(
                "images/admin.jpg",
                height: 200,
                width: 200,
              ),
              Container(
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: 1,
                    autovalidate: true,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide email';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'user@nus.com',
                    ),
                    onSaved: (input) => _email = input,
                  )),
              SizedBox(height: 10),
              Ink(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                    width: 3,
                    color: Colors.black,
                  ))),
                  child: IconButton(
                    highlightColor: Colors.blue[500],
                    icon: Icon(Icons.add),
                    iconSize: 50,
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        _key.currentState.save();
                        _addDialog(context);
                      }
                    },
                    color: Colors.black,
                  )),
              SizedBox(height: 15),
              Text("Add"),
            ]))));
  }

  void _addAdmin(String uid) {
    widget.docRef.updateData({
      "Admin": FieldValue.arrayUnion([uid])
    });
  }

  Future<bool> _isAdmin(String uid) async {
    widget.docSnapshot = await widget.docRef.get();
    List adminList = List.from(widget.docSnapshot['Admin']);
    return adminList.contains(uid);
  }

  void _addDialog(BuildContext ctx) async {
    // 1. User doesnt exist
    // 2. User already admin
    // 3. Possible to add

    QuerySnapshot snapshot = await widget.userCollection
        .where('Email', isEqualTo: _email)
        .getDocuments();

    if (snapshot.documents.isEmpty) {
      //User doesnt exist
      showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Oops!"),
            content: new Text(
                "There is no such user with this email. Add an existing user."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
            ],
          );
        },
      );
    } else {
      DocumentSnapshot user = snapshot.documents[0];
      bool alreadyAdmin = await _isAdmin(user.documentID);

      if (alreadyAdmin) {
        showDialog(
          context: ctx,
          builder: (BuildContext ctx) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Oops!"),
              content: new Text(
                  "${user['Name']} is already an Admin of ${widget.ccaName}."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                    child: new Text("Okay"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: ctx,
          builder: (BuildContext ctx) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Add Admin Confirmation"),
              content: new Text(
                  "Add ${user['Name']} as Admin of ${widget.ccaName}?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                    child: new Text("No"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
                FlatButton(
                    child: new Text("Yes!"),
                    onPressed: () {
                      _addAdmin(user.documentID);
                      Navigator.of(ctx).pop();
                      _key.currentState.reset();
                      _successFlushBar(ctx, user['Name']);
                    }),
              ],
            );
          },
        );
      }
    }
  }

  void _successFlushBar(BuildContext context, String name) {
    Flushbar(
      icon: Icon(FontAwesomeIcons.grinBeam, color: Colors.white),
      title: 'Hurray!',
      message: '$name is now an Admin of ${widget.ccaName}!',
      duration: Duration(seconds: 3),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(context);
  }

}
