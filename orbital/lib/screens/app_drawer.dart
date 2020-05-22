import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Column(children: <Widget>[
      DrawerHeader(
        child: Image.asset("images/logo.png"),
      ),
      ListTile(
        leading: Icon(Icons.looks_one),
        title: Text('Activity Feed'),
        onTap: null,
      ),
      ListTile(
        leading: Icon(Icons.looks_two),
        title: Text('Explore CCAs'),
        onTap: null,
      ),
      ListTile(
        leading: Icon(Icons.looks_3),
        title: Text('My Events'),
        onTap: null,
      ),
      ListTile(
        leading: Icon(Icons.looks_4),
        title: Text('My Profile'),
        onTap: null,
      ),
    ]));
  }
}
