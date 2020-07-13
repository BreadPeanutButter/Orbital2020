import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

class EventAdminEdit extends StatefulWidget {
  DocumentSnapshot ccaDocument;
  int index;
  bool fromEventFeed = false;
  bool fromMyEvents = false;
  bool fromCCA = false;

  EventAdminEdit.fromCCA({@required this.ccaDocument, @required this.index}) {
    fromCCA = true;
  }
  EventAdminEdit.fromEventFeed(
      {@required this.ccaDocument, @required this.index}) {
    fromEventFeed = true;
  }
  EventAdminEdit.fromMyEvents({@required this.ccaDocument}) {
    fromMyEvents = true;
  }
  @override
  State<StatefulWidget> createState() {
    return _EventAdminEditState();
  }
}

class _EventAdminEditState extends State<EventAdminEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  File _image;
  String name, details, eventTime, location, registrationInstructions, imageURL;
  bool closed;
  bool isLoading = false;

  void initState() {
    super.initState();
    imageURL = widget.ccaDocument['image'];
    closed = widget.ccaDocument['Closed'];
  }

  @override
  Widget build(BuildContext context) {
    name = widget.ccaDocument['Name'];
    details = widget.ccaDocument['Details'];
    eventTime = widget.ccaDocument['EventTime'];
    location = widget.ccaDocument['Location'];
    registrationInstructions = widget.ccaDocument['RegisterInstructions'];
    final GlobalKey<FormState> _key = GlobalKey();
    final TextEditingController nameController = new TextEditingController();
    final TextEditingController detailsController = new TextEditingController();
    final TextEditingController eventTimeController =
        new TextEditingController();
    final TextEditingController locationController =
        new TextEditingController();
    final TextEditingController imageURLController =
        new TextEditingController();
    final TextEditingController RIController = new TextEditingController();
    nameController.text = name;
    detailsController.text = details;
    eventTimeController.text = eventTime;
    locationController.text = location;
    imageURLController.text = imageURL;
    RIController.text = registrationInstructions;

    showAlertDialog(BuildContext context) {
      Widget OkayButton = FlatButton(
        child: Text("Okay"),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {});
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

    void _successDialogEdit(DocumentSnapshot doc) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Success!"),
            content:
                new Text("You have edited ${doc['Name']}. Press Okay to view."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              OutlineButton(
                  highlightedBorderColor: Colors.blue,
                  borderSide: BorderSide(color: Colors.blue),
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (widget.fromCCA) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEdit(
                                    document: doc,
                                    index: widget.index,
                                  )));
                    } else if (widget.fromMyEvents) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromMyEvents(
                                    document: doc,
                                  )));
                    } else if (widget.fromEventFeed) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEventFeed(
                                  document: doc, index: widget.index)));
                    }
                  }),

              SizedBox(width: 110),
            ],
          );
        },
      );
    }

    void _closeDialog(DocumentSnapshot doc) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Success"),
            content: new Text("You have closed the event!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              OutlineButton(
                  highlightedBorderColor: Colors.blue,
                  borderSide: BorderSide(color: Colors.blue),
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (widget.fromCCA) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEdit(
                                    document: doc,
                                    index: widget.index,
                                  )));
                    } else if (widget.fromMyEvents) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromMyEvents(
                                    document: doc,
                                  )));
                    } else if (widget.fromEventFeed) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEventFeed(
                                  document: doc, index: widget.index)));
                    }
                  }),

              SizedBox(width: 110),
            ],
          );
        },
      );
    }

    void _openDialog(DocumentSnapshot doc) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Success"),
            content: new Text("You have re-opened the event!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              OutlineButton(
                  highlightedBorderColor: Colors.blue,
                  borderSide: BorderSide(color: Colors.blue),
                  child: new Text("Okay"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (widget.fromCCA) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEdit(
                                  document: doc, index: widget.index)));
                    } else if (widget.fromMyEvents) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromMyEvents(
                                    document: doc,
                                  )));
                    } else if (widget.fromEventFeed) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => EventAdminView.fromEventFeed(
                                  document: doc, index: widget.index)));
                    }
                  }),
              SizedBox(width: 110),
            ],
          );
        },
      );
    }

    void _publishEvent() async {
      print(imageURL);
      widget.ccaDocument.reference.updateData({
        'Name': name,
        'Details': details,
        'Location': location,
        'RegisterInstructions': registrationInstructions,
        'EventTime': eventTime,
        'image': imageURL
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
      _successDialogEdit(snapShot);
    }

    void _closeEvent() async {
      widget.ccaDocument.reference.updateData({'Closed': true});
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
      _closeDialog(snapShot);
    }

    void _openEvent() async {
      widget.ccaDocument.reference.updateData({'Closed': false});
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
      _openDialog(snapShot);
    }

    Future uploadImage(BuildContext context) async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(pickedFile.path);
        isLoading = true;
      });
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('event_profile/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(dowurl.toString());
      setState(() {
        imageURL = dowurl.toString();
        isLoading = false;
      });
      print(imageURL);
      showAlertDialog(context);
    }

    Widget imageWidget() {
      if (imageURL == null) {
        return SizedBox(height: 50);
      } else {
        return Image.network(
          imageURL,
          height: 200,
          width: 200,
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Event'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Center(
            child: Form(
                autovalidate: true,
                key: _key,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 30),
                    imageWidget(),
                    SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            onPressed: () {
                              uploadImage(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Change',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            textColor: Colors.red,
                            splashColor: Colors.red,
                            color: Colors.green,
                          ),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                            decoration: const InputDecoration(
                                labelText: "Name of event"),
                            autocorrect: true,
                            controller: nameController,
                            onChanged: (String value) {
                              name = value;
                            })),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                            decoration: const InputDecoration(
                                labelText: "Provide events details",
                                hintText: 'What the event is about'),
                            autocorrect: true,
                            controller: detailsController,
                            onChanged: (String value) {
                              details = value;
                            })),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                            decoration: const InputDecoration(
                                labelText: "Provide event date and time",
                                hintText: 'When is the event held'),
                            autocorrect: true,
                            controller: eventTimeController,
                            onChanged: (String value) {
                              eventTime = value;
                            })),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                            decoration: const InputDecoration(
                                labelText: "Provide event location",
                                hintText: 'Where is the event held'),
                            autocorrect: true,
                            controller: locationController,
                            onChanged: (String value) {
                              location = value;
                            })),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                            decoration: const InputDecoration(
                                labelText: "Provide sign up instructions",
                                hintText: 'How to sign up'),
                            autocorrect: true,
                            controller: RIController,
                            onChanged: (String value) {
                              registrationInstructions = value;
                            })),
                    SizedBox(height: 20),
                    ButtonTheme(
                      minWidth: 200,
                      height: 50,
                      buttonColor: widget.ccaDocument['Closed']
                          ? Colors.green
                          : Colors.red,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: widget.ccaDocument['Closed']
                                    ? Colors.green
                                    : Colors.red)),
                        onPressed: widget.ccaDocument['Closed']
                            ? _openEvent
                            : _closeEvent,
                        child: widget.ccaDocument['Closed']
                            ? Text("Re-open Event",
                                style: TextStyle(fontSize: 15))
                            : Text("Close Event",
                                style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    SizedBox(height: 20),
                    ButtonTheme(
                      minWidth: 200,
                      height: 50,
                      buttonColor: Colors.blue,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          _publishEvent();
                        },
                        child: Text("Done", style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]),
                ))));
  }
}
