import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/cca/cca_categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/services/auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:orbital/cca/cca_admin_view.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class CreateCCA extends StatefulWidget {
  Auth auth = new Auth();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateCCAState();
  }
}

class _CreateCCAState extends State<CreateCCA> {
  String _name, _description, _contact, _cat, _imageURL;
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
              "Your application will not be saved. Do you still want to close this page?"),
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
                  Navigator.pop(context);
                }),
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

  Future getImage(BuildContext context) async {
    double _progress = 0;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      _imageURL = dowurl.toString();
    });
    showAlertDialog(context);

    uploadTask.events.listen((event) {
      setState(() {
        _progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        Text('Uploading ${(_progress * 100).toStringAsFixed(2)} %');
        CircularProgressIndicator(value: _progress);
      });
    }).onError((error) {
      // do something to handle error
    });

    print(_imageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.blue[900],
            icon: Icon(Icons.cancel),
            iconSize: 45,
            onPressed: _showDialog,
            color: Colors.white,
          ),
          title: Text('CCA Application'),
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
                            'Complete and submit the form below to create a new CCA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: DropDownFormField(
                        autovalidate: true,
                        titleText: 'CCA Category',
                        hintText: 'Category',
                        value: _cat,
                        validator: (input) {
                          if (input == null) {
                            return "Select a category";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _cat = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _cat = value;
                          });
                        },
                        dataSource: [
                          {
                            "display": "Academic",
                            "value": "Academic",
                          },
                          {
                            "display": "Adventure",
                            "value": "Adventure",
                          },
                          {
                            "display": "Arts",
                            "value": "Arts",
                          },
                          {
                            "display": "Cultural",
                            "value": "Cultural",
                          },
                          {
                            "display": "Health",
                            "value": "Health",
                          },
                          {
                            "display": "Social Cause",
                            "value": "Social Cause",
                          },
                          {
                            "display": "Specialist",
                            "value": "Specialist",
                          },
                          {
                            "display": "Sports",
                            "value": "Sports",
                          },
                          {
                            "display": "Technology",
                            "value": "Technology",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: true,
                          validator: (input) {
                            if (input.isEmpty || input == null) {
                              return 'Provide a CCA name';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'My CCA',
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
                            if (input.isEmpty || input == null) {
                              return 'Provide a CCA Description';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'What we do',
                          ),
                          onSaved: (input) => _description = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: true,
                          maxLines: null,
                          validator: (input) {
                            if (input.isEmpty || input == null) {
                              return 'Users will see this. Enter each form of contact on a new line.';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Contact details',
                            hintText: 'Email: cca@nus.com\nWhatsapp: 8888 8888',
                          ),
                          onSaved: (input) => _contact = input,
                        )),
                    SizedBox(height: 20),
                    Padding( padding: EdgeInsets.only(top: 0),
                    child: IconButton(
                       icon: Icon(
                          FontAwesomeIcons.camera,
                           size: 50.0,
                       ),
                       onPressed: () =>  getImage(context),
                    )),
                    SizedBox(height: 10),
                    Text("Upload display image"),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Reset form'),
                        onPressed: () {
                          _key.currentState.reset();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Submit Application'),
                        onPressed: _submitApplication,
                      ),
                    )
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
              "Congratulations, you have created a new CCA! You are now the admin of ${doc['Name']}."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Hurray!"),
                onPressed: () {
                  Navigator.pushNamed(ctx, '/explore');
                  Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (c) => CCAAdminView(
                                document: doc,
                              )));
                }),

            SizedBox(width: 110),
          ],
        );
      },
    );
  }

  void _failureDialog(String name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Oops!"),
          content: new Text(
              "The CCA $name already exists. Choose a non-existing name to proceed."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                }),
            SizedBox(width: 110),
          ],
        );
      },
    );
  }

  void _submitApplication() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      final docRef = Firestore.instance.collection('CCA').document(_name);
      final snapShot = await docRef.get();
      if (snapShot.exists) {
        _failureDialog(_name);
      } else {
        await docRef.setData({
          'Name': _name,
          'Category': _cat,
          'Description': _description,
          'image': _imageURL,
          'Contact': _contact,
          'DateJoined': DateTime.now(),
          'Admin': <String>[widget.auth.uid],
          'FavouriteCount': 0
        });
        DocumentSnapshot _newSnapShot = await docRef.get();
        _successDialog(_newSnapShot);
      }
    }
  }
}
