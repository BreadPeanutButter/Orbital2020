import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/cca/event_normal_view.dart';
import 'package:orbital/cca/create_event.dart';

class CCAAdminEventlist extends StatelessWidget {
  String ccaName;
  CCAAdminEventlist({@required this.ccaName});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      padding: EdgeInsets.all(8),
      child: CupertinoButton.filled(
        child: Text('Publish'),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEvent(
                      ccaName: ccaName,
                    ))),
      ),
    );
  }
}
