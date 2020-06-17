import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'profile.dart';

enum Drawers { activity, explore, event, profile }

class AppDrawer extends StatelessWidget {
  Drawers drawer;
  Auth auth;

  AppDrawer({@required this.drawer}) {
    auth = new Auth();
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Column(children: <Widget>[
      DrawerHeader(
        child: Image.asset("images/logo.png"),
      ),
      Ink(
          color: drawer == Drawers.activity ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_one),
            title: Text('Activity Feed'),
            onTap: () => Navigator.pushNamed(context, '/activity'),
          )),
      Ink(
          color: drawer == Drawers.explore ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_two),
            title: Text('Explore CCAs'),
            onTap: () => Navigator.pushNamed(context, '/explore'),
          )),
      Ink(
          color: drawer == Drawers.event ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_3),
            title: Text('My Events'),
            onTap: null,
          )),
      Ink(
          color: drawer == Drawers.profile ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_4),
            title: Text('My Profile'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Profile(
                          auth: auth,
                        ))),
          )),
    ]));
  }
}
