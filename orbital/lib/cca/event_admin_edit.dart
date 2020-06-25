import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital/cca/event_admin_view.dart';
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
  String name, details, eventTime, location, registrationInstructions;

  @override
  Widget build(BuildContext context) {
    name = widget.ccaDocument['Name'];
    details = widget.ccaDocument['Details'];
    eventTime = widget.ccaDocument['EventTime'];
    location = widget.ccaDocument['Location'];
    String imageURL = widget.ccaDocument['Image'];
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
    

    

    
  void _successDialog(DocumentSnapshot doc) {
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
    

    void _publishEvent() async {
      print(imageURL);
      widget.ccaDocument.reference.updateData({
        'Name' : name,
        'Details': details,
        'Location': location,
        'RegisterInstructions': registrationInstructions,
        'EventTime': eventTime,
        'Image' : imageURL
        
                          
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
       _successDialog(snapShot);
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
                    SizedBox(height: 30),
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
                    SizedBox(height: 30),
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
                    SizedBox(height: 30),
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
                    SizedBox(height: 20),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Publish'),
                        onPressed: () {
                            _publishEvent();

                        } 
                      ),
                    ),
                  ]),
                ))));
    
  }
  
}

