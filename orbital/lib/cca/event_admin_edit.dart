import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool closed;
  String imageURL;
  File _image;
  String name, details, eventTime, location, registrationInstructions;
  bool isLoading = false;

  EventAdminEdit.fromCCA({@required this.ccaDocument, @required this.index}) {
    fromCCA = true;
    closed = ccaDocument['Closed'];
    imageURL = ccaDocument['image'];
    name = ccaDocument['Name'];
    details = ccaDocument['Details'];
    eventTime = ccaDocument['EventTime'];
    location = ccaDocument['Location'];
    registrationInstructions = ccaDocument['RegisterInstructions'];
  }
  EventAdminEdit.fromEventFeed(
      {@required this.ccaDocument, @required this.index}) {
    fromEventFeed = true;
    closed = ccaDocument['Closed'];
    imageURL = ccaDocument['image'];
    name = ccaDocument['Name'];
    details = ccaDocument['Details'];
    eventTime = ccaDocument['EventTime'];
    location = ccaDocument['Location'];
    registrationInstructions = ccaDocument['RegisterInstructions'];
  }
  EventAdminEdit.fromMyEvents({@required this.ccaDocument}) {
    fromMyEvents = true;
    closed = ccaDocument['Closed'];
    imageURL = ccaDocument['image'];
    name = ccaDocument['Name'];
    details = ccaDocument['Details'];
    eventTime = ccaDocument['EventTime'];
    location = ccaDocument['Location'];
    registrationInstructions = ccaDocument['RegisterInstructions'];
  }
  @override
  State<StatefulWidget> createState() {
    return _EventAdminEditState();
  }
}

class _EventAdminEditState extends State<EventAdminEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
    nameController.text = widget.name;
    detailsController.text = widget.details;
    eventTimeController.text = widget.eventTime;
    locationController.text = widget.location;
    imageURLController.text = widget.imageURL;
    RIController.text = widget.registrationInstructions;

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

    void _publishEvent() async {
      print(widget.imageURL);
      widget.ccaDocument.reference.updateData({
        'Name': widget.name,
        'Details': widget.details,
        'Location': widget.location,
        'RegisterInstructions': widget.registrationInstructions,
        'EventTime': widget.eventTime,
        'image': widget.imageURL,
        'Closed': widget.closed
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
      _successDialogEdit(snapShot);
    }

    Future uploadImage(BuildContext context) async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        widget._image = File(pickedFile.path);
        widget.isLoading = true;
      });
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('event_profile/${Path.basename(widget._image.path)}}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(widget._image);
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print(dowurl.toString());
      setState(() {
        widget.imageURL = dowurl.toString();
        widget.isLoading = false;
      });
      print(widget.imageURL);
      showAlertDialog(context);
    }

    Widget imageWidget() {
      if (widget.imageURL == null) {
        return SizedBox(height: 50);
      } else {
        return Image.network(
          widget.imageURL,
          height: 200,
          width: 200,
        );
      }
    }

    Widget closedCheckBox() {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.closed ? Colors.red[400] : Colors.green,
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          height: 90,
          width: 340,
          child: CheckboxListTile(
            value: widget.closed,
            onChanged: (val) => setState(() => widget.closed = !widget.closed),
            activeColor: widget.closed ? Colors.red[400] : Colors.green,
            title: Text(
              "Close Event",
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "Select to close event",
              style: TextStyle(fontSize: 16),
            ),
            secondary: widget.closed
                ? Icon(
                    FontAwesomeIcons.doorClosed,
                    color: Colors.black,
                    size: 40,
                  )
                : Icon(
                    FontAwesomeIcons.doorOpen,
                    color: Colors.black,
                    size: 40,
                  ),
          ));
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
                    widget.isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            onPressed: () {
                              uploadImage(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Upload Image',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            icon: Icon(
                              Icons.add_a_photo,
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
                              widget.name = value;
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
                              widget.details = value;
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
                              widget.eventTime = value;
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
                              widget.location = value;
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
                              widget.registrationInstructions = value;
                            })),
                    SizedBox(height: 20),
                    closedCheckBox(),
                    SizedBox(height: 40),
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
