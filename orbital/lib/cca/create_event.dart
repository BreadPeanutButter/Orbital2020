import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/services/auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class CreateEvent extends StatefulWidget {
  Auth auth = new Auth();
  DocumentSnapshot ccaDocument;

  CreateEvent({@required this.ccaDocument});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateEventState();
  }
}

class _CreateEventState extends State<CreateEvent> {
  String _name, _time, _details, _location, _register, _imageURL, _createdBy;
  File _image;
  final GlobalKey<FormState> _key = GlobalKey();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Close this page"),
          content: new Text(
              "The event will not be saved. Do you still want to close this page?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.blue[700],
            icon: Icon(FontAwesomeIcons.times),
            iconSize: 35,
            onPressed: _showDialog,
            color: Colors.white,
          ),
          title: Text('Create Event'),
          centerTitle: true,
        ),
        body: Center(
            child: Form(
                autovalidate: true,
                key: _key,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                            'Complete and submit the form below to create a new Event',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(height: 20),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide event name';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'My Event',
                          ),
                          onSaved: (input) => _name = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide event details';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Details',
                            hintText: 'What the event is about',
                          ),
                          onSaved: (input) => _details = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide event date and time';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Date and Time, DD/MM/YY HH:MM',
                            hintText: 'When is the event held',
                          ),
                          onSaved: (input) => _time = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide location of event';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: 'Where event is held',
                          ),
                          onSaved: (input) => _location = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide sign up instructions';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Sign Up',
                            hintText: 'How to sign up',
                          ),
                          onSaved: (input) => _register = input,
                        )),
                        Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'please provide your name';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Created by who',
                            hintText: 'Who created this event',
                          ),
                          onSaved: (input) => _createdBy = input,
                        )),
                    SizedBox(height: 20),
                    Padding( padding: EdgeInsets.only(top: 0),
                    child: IconButton(
                       icon: Icon(
                          FontAwesomeIcons.camera,
                           size: 30.0,
                       ),
                       onPressed: () => uploadImage(context),
                    )),
                    Text("Upload display image"),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Publish'),
                        onPressed: _publishEvent,
                      ),
                    ),
                  ]),
                ))));
  }

  void _successDialog(DocumentSnapshot doc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success!"),
          content: new Text(
              "Congratulations, you have published a new event! You can now view ${doc['Name']}."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Hurray!"),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(ctx);
                  Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (c) => EventAdminView(
                                document: doc,
                              )));
                }),

            SizedBox(width: 110),
          ],
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget OkayButton = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Uploading image"),
      content: Text("Image uploaded"),
      actions: [
        OkayButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

    Future uploadImage(BuildContext context) async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(pickedFile.path);
      });
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('event_profile/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      setState(() {
        _imageURL = dowurl.toString();
      });
      showAlertDialog(context);
      print(_imageURL);
  }

  void _publishEvent() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      CollectionReference collectionRef =
          Firestore.instance.collection('Event');
      DocumentReference documentRef = await collectionRef.add({
        'Name': _name,
        'Category': widget.ccaDocument['Category'],
        'image': _imageURL,
        'Details': _details,
        'CCA': widget.ccaDocument['Name'],
        'Location': _location,
        'DateCreated': DateTime.now(),
        'RegisterInstructions': _register,
        'BookmarkCount': 0,
        'EventTime': _time,
        'CreatedBy': _createdBy,
        'Closed': false
      });
      DocumentSnapshot snapShot = await documentRef.get();
       _successDialog(snapShot);
    }
  }
}
