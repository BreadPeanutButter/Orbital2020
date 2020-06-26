import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbital/cca/cca_admin_view.dart';
import 'package:orbital/cca/event_admin_view.dart';
import 'package:orbital/services/auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class CCAAdminEdit extends StatefulWidget {
  DocumentSnapshot ccaDocument;
  CCAAdminEdit({@required this.ccaDocument});

  @override
  State<StatefulWidget> createState() {
    return _CCAAdminEditState();
  }
}


class _CCAAdminEditState extends State<CCAAdminEdit> {
  File _image;
  String description, contact, imageURL;

  void initState() {
    super.initState();
    imageURL = widget.ccaDocument['image'];

  }

  @override
  Widget build(BuildContext context) {
    description = widget.ccaDocument['Description'];
    contact = widget.ccaDocument['Contact'];
    final GlobalKey<FormState> _key = GlobalKey();
    final TextEditingController descriptionController = new TextEditingController();
    final TextEditingController contactController = new TextEditingController();
    descriptionController.text = description;
    contactController.text = contact;
    
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

    
  void _successDialog(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success!"),
          content: new Text(
              "Congratulations, you have edited your CCA! You can now view ${doc['Name']}."),
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
                  Navigator.push(context,MaterialPageRoute(builder: (c) => CCAAdminView(document : doc)));
                  
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
        'Description' : description,
        'Contact': contact,
        'image' : imageURL
        
                          
      });
      DocumentSnapshot snapShot = await widget.ccaDocument.reference.get();
       _successDialog(snapShot);
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
                          controller: descriptionController,
                          onChanged: (String value) {
                            description = value;
                          }
                      )),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: new TextField(
                          decoration: const InputDecoration(labelText: "Provide events details", hintText: 'What the event is about'),
                          autocorrect: true,
                          controller: contactController,
                          onChanged: (String value) {
                            contact = value;
                          }
                    )),
                    
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
