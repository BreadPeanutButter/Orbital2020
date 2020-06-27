import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/screens/event_feed/event_feed_all.dart';
import 'package:orbital/services/auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class EventAdminEdit extends StatefulWidget {
  DocumentSnapshot ccaDocument;
  EventAdminEdit({@required this.ccaDocument});

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

  void initState() {
    super.initState();
    imageURL = widget.ccaDocument['image'];
    closed =  widget.ccaDocument['Closed'];
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
    final TextEditingController eventTimeController = new TextEditingController();
    final TextEditingController locationController = new TextEditingController();
    final TextEditingController imageURLController = new TextEditingController();
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
          setState(() {
            
          });
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
          content: new Text(
              "Congratulations, you have edited the event! You can now view ${doc['Name']}."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Hurray!"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (c) => EventAdminView(document : doc)));
                  
                }),

            SizedBox(width: 110),
          ],
        );
      },
    );
  }

    void _successDialogClosed(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success!"),
          content: new Text(
              "Congratulations, you have closed the event!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Event is now closed!"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (c) => EventAdminView(document : doc)));
                  
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
        'Name' : name,
        'Details': details,
        'Location': location,
        'RegisterInstructions': registrationInstructions,
        'EventTime': eventTime,
        'image' : imageURL
        
                          
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
       _successDialogEdit(snapShot);
    }

    void _closedEvent() async{
      widget.ccaDocument.reference.updateData({
        'Closed' : true
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
      _successDialogClosed(snapShot);
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
      print(dowurl.toString());
      setState(() {
        imageURL = dowurl.toString();

      });
      print(imageURL);
      showAlertDialog(context);

  }

    Widget imageWidget(){
      if(imageURL == null){
        return SizedBox(height: 50);
      }
      else{
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
                    RaisedButton.icon(
                        onPressed: (){ uploadImage(context);},
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        label: Text('Change', 
                        style: TextStyle(color: Colors.white, fontSize: 15),),
                        icon: Icon(Icons.edit, color: Colors.white,), 
                        textColor: Colors.red,
                        splashColor: Colors.red,
                        color: Colors.green,),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Name of event"),
                          autocorrect: true,
                          controller: nameController,
                          onChanged: (String value) {
                            name = value;
                          }
                      )),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Provide events details", hintText: 'What the event is about'),
                          autocorrect: true,
                          controller: detailsController,
                          onChanged: (String value) {
                            details = value;
                          }
                    )),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Provide event date and time", hintText: 'When is the event held'),
                          autocorrect: true,
                          controller: eventTimeController,
                          onChanged: (String value) {
                            eventTime = value;
                        }
                    )),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Provide event location", hintText: 'where is the event held'),
                          autocorrect: true,
                          controller: locationController,
                          onChanged: (String value) {
                            location = value;
                        }
                    )),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Provide sign up instructions", hintText: 'How to sign up'),
                          autocorrect: true,
                          controller: RIController,
                          onChanged: (String value) {
                            registrationInstructions = value;
                        }
                    )),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Closed Event'),
                        onPressed: () {
                            _closedEvent();
                        } 
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Done'),
                        onPressed: () {
                            _publishEvent();

                        } 
                      ),
                      
                    ),
 
                  ]),
                ))));
    
  }
  
}
