import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CreateEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateEventState();
  }
}

class _CreateEventState extends State<CreateEvent> {
  String _name, _time, _details, _location;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide an Event name';
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
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Provide date/time of event';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Time',
                            hintText: 'Date/Time',
                          ),
                          onSaved: (input) => _time = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: 'Leave empty if not applicable.',
                          ),
                          onSaved: (input) => _location = input,
                        )),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: CupertinoButton.filled(
                        child: Text('Publish'),
                        onPressed: null,
                      ),
                    )
                  ]),
                ))));
  }
}
